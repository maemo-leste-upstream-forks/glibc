From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH] Include <sigsetops.h> from hurd/hurd/signal.h

* hurd/hurd/signal.h [__USE_EXTERN_INLINES][_LIBC][IS_IN(libc)]: Include
<sigsetops.h>.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---
 hurd/hurd/signal.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/hurd/hurd/signal.h
+++ b/hurd/hurd/signal.h
@@ -41,6 +41,11 @@
 #include <setjmp.h>		/* For `jmp_buf'.  */
 #include <spin-lock.h>
 struct hurd_signal_preemptor;	/* <hurd/sigpreempt.h> */
+#if defined __USE_EXTERN_INLINES && defined _LIBC
+#  if IS_IN (libc)
+#    include <sigsetops.h>
+#  endif
+#endif
 
 
 /* Full details of a signal.  */
