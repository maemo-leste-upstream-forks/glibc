# m68k cannot be compiled with >= 2.4.xx
MIN_KERNEL_SUPPORTED := 2.2.0

# work around to build on m68k, due to gcc-4.0 ICE.  See #319312.
CC = gcc-3.4
BUILD_CC = gcc-3.4

# udeb Config
udeb_extra_cflags = 
udeb_MIN_KERNEL_SUPPORTED = 2.2.0
