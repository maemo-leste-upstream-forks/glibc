/* Optimized memset implementation for PowerPC.
   Copyright (C) 1997, 1999, 2000, 2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public License as
   published by the Free Software Foundation; either version 2 of the
   License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful, 
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with the GNU C Library; see the file COPYING.LIB.  If not, 
   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

#include <sysdep.h>
#include <bp-sym.h>
#include <bp-asm.h>

/* __ptr_t [r3] memset (__ptr_t s [r3], int c [r4], size_t n [r5])); 
   Returns 's'.

   The memset is done in two sizes:  
   less than cache line size,
   cache line (variable bits). (Most likely  16, 32 or 128 bytes)
   There is a special case for setting cache lines
   to 0, to take advantage of the dcbz instruction.  */

EALIGN (BP_SYM (memset), 5, 1)

#define rTMP    r0
#define rRTN    r3  /* initial value of 1st argument */
#if __BOUNDED_POINTERS__
# define rMEMSTART  r4  /* original value of 1st arg */
# define rCHR       r5  /* char to set in each byte */ 
# define rLEN       r6  /* length of region to set */
# define rMEMP      r10 /* address at which we are storing */
#else
# define rMEMSTART  r3  /* original value of 1st arg */
# define rCHR       r4  /* char to set in each byte */ 
# define rLEN       r5  /* length of region to set */
# define rMEMP      r6  /* address at which we are storing */
#endif
#define rALIGN  r7  /* number of bytes we are setting now (when aligning) */
#define rMEMP2  r8
#define rCACHELINESIZE r9
#define SPRG9         9

#if __BOUNDED_POINTERS__
    cmplwi  cr1, rRTN, 0 
    CHECK_BOUNDS_BOTH_WIDE (rMEMSTART, rTMP, rTMP2, rLEN)
    beq cr1, L(b0)
    STORE_RETURN_VALUE (rMEMSTART)
    STORE_RETURN_BOUNDS (rTMP, rTMP2)
L(b0):
#endif

/* take care of case for size <= 4  */
	cmplwi  cr1, rLEN, 4 
	mr 	rMEMP, rMEMSTART
	ble     cr1, L(Tiny)

/* greater than 4 .. now work up to a cache boundary */
	rlwimi  rCHR, rCHR, 8, 16, 23 /* copies the byte */
	rlwimi  rCHR, rCHR, 16, 0, 15 /* filling across the word */
/* step ahead by 0-3 bytes to get word aligned */
	andi.	rALIGN, rMEMSTART, 0x03
	cmplwi	cr1, rALIGN, 1
	blt	cr1, L(WordAligned)
	andi.   rALIGN, rALIGN, 0x01
	cmplwi  cr5, rALIGN, 0x01
	bne     cr5, L(Jump2)
	stb     rCHR, 0(rMEMP)
	subi   	rLEN, rLEN, 0x01
	add     rMEMP, rMEMP, rALIGN

L(Jump2):
	andi.    rALIGN, rMEMSTART, 0x02
	cmplwi  cr1, rALIGN, 0x02
	blt     cr1, L(WordAligned)
	sth     rCHR, 0(rMEMP)
	subi   	rLEN, rLEN, 0x02
	add     rMEMP, rMEMP, rALIGN

L(WordAligned):
	li 	rCACHELINESIZE, 0x0080
	cmplwi  cr5, rLEN, rCACHELINESIZE
/* now align to a cache line boundary assuming we don't go
   past rLEN
 */
	blt	cr5, L(LessThanCacheLineSize)
	subi   	rCACHELINESIZE,rCACHELINESIZE, 1
	and 	rALIGN,rMEMP,rCACHELINESIZE
	addi	rCACHELINESIZE,rCACHELINESIZE, 1
	sub	rALIGN,rCACHELINESIZE, rALIGN

/* rALIGN now has now many bytes until we are at a cache line */
	cmplwi	cr1, rALIGN, 0
	beq	cr1, L(CacheLine)
	sub	rLEN, rLEN, rALIGN 	
	srawi	rALIGN, rALIGN, 0x02 /* div by 4 */
/* need to bump up a bit to get to a cacheline */
	mtspr  	SPRG9, rALIGN
L(KeepGoingToCacheAlign):
	stw 	rCHR, 0(rMEMP)
	addi	rMEMP, rMEMP, 0x04
	bdnz    L(KeepGoingToCacheAlign)	
L(CacheLine):
/* ok the first bit of trivia we need to figure out is how big IS a cache line
   we are just assuming it's a 128 bytes at this point
   So we store none zero values in 2 spots, depending how the dcbz goes
   we check if the eyecatchers are still there are there ya go, we have a 
   cache line size!
*/
	divw	rALIGN, rLEN, rCACHELINESIZE
	cmplwi	cr5, rALIGN, 0
	beq	cr5, L(AreWeDone)
	stw	rCACHELINESIZE, 16(rMEMP)
	stw	rCACHELINESIZE, 32(rMEMP)
	dcbz	0,rMEMP	
	lwz	rMEMP2, 32(rMEMP)
	lwz	rALIGN, 16(rMEMP)
	cmplwi	cr1, rMEMP2, 0
	cmplwi	cr5, rALIGN, 0
	beq	cr1, L(CACHEIS128)
	beq	cr5, L(CACHEIS32)
/* cache line size is 16 bytes */
	li	rCACHELINESIZE, 0x0010
	b 	L(NextCacheLine)
L(CACHEIS128):
	li	rCACHELINESIZE, 0x0080
	b 	L(NextCacheLine)
L(CACHEIS32):
	li	rCACHELINESIZE, 0x0020
L(NextCacheLine):
	divw	rALIGN, rLEN, rCACHELINESIZE
	cmplwi	cr1, rCHR, 0  /* can we use dcbz for zero optimization? */
	mtspr	SPRG9, rALIGN
	mullw	rALIGN, rALIGN, rCACHELINESIZE
	sub	rLEN, rLEN, rALIGN
	bne	cr1, L(NeedToStore)
L(ClearOpt):
	dcbz	0,rMEMP	
	add	rMEMP,rMEMP, rCACHELINESIZE
	bdnz	L(ClearOpt)
	b	L(AreWeDone)

L(NeedToStore):
	dcbz	0,rMEMP	
	srawi	rALIGN, rCACHELINESIZE, 0x02 /* div by 4 */
L(ABlock):
	subi	rALIGN, rALIGN, 0x04
	cmplwi	cr5, rALIGN, 0
	stw 	rCHR, 0(rMEMP)
	stw 	rCHR, 4(rMEMP)
	stw 	rCHR, 8(rMEMP)
	stw 	rCHR, 12(rMEMP)
	addi	rMEMP,rMEMP, 0x10
	beq	cr5, L(NextBlock)
	b	L(ABlock)
L(NextBlock):
	bdnz	L(NeedToStore)
L(AreWeDone):
	cmplwi  cr1, rLEN, 0
	bgt     cr1, L(LessThanCacheLineSize)
	blr

	.align 5	
L(LessThanCacheLineSize):
	srawi	rALIGN, rLEN, 0x02 /* div by 4 */
	mtspr 	SPRG9, rALIGN
	mulli	rALIGN, rALIGN, 0x04	
	sub	rLEN, rLEN, rALIGN 	
L(KeepGoingSmall):
	stw 	rCHR, 0(rMEMP)
	add	rMEMP, rMEMP, 0x04
	bdnz    L(KeepGoingSmall)	
	cmplwi  cr1, rLEN, 0 
	bgt     cr1, L(Tiny)
	blr

	.align 5
L(Tiny):
/* Memset of 4 bytes or less.  */
	cmplwi  cr5, rLEN, 1
	cmplwi  cr1, rLEN, 3
	bltlr   cr5
	stb rCHR, 0(rMEMP)
	beqlr   cr5
	stb rCHR, 1(rMEMP)
	bltlr   cr1
	stb rCHR, 2(rMEMP)
	beqlr   cr1
	stb rCHR, 3(rMEMP)
	blr

END (BP_SYM (memset))
