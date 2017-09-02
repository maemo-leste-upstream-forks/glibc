From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH] Include <sigsetops.h> from hurd/hurd/signal.h

* hurd/hurd/signal.h [__USE_EXTERN_INLINES][_LIBC][IS_IN(libc)]: Include
<sigsetops.h>.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---
 hurd/hurd/signal.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hurd/hurd/signal.h b/hurd/hurd/signal.h
index e03d53e6d7..c97699bcc9 100644
--- a/hurd/hurd/signal.h
+++ b/hurd/hurd/signal.h
@@ -42,6 +42,11 @@
 #include <spin-lock.h>
 #include <hurd/threadvar.h>	/* We cache sigstate in a threadvar.  */
 struct hurd_signal_preemptor;	/* <hurd/sigpreempt.h> */
+#if defined __USE_EXTERN_INLINES && defined _LIBC
+#  if IS_IN (libc)
+#    include <sigsetops.h>
+#  endif
+#endif
 
 
 /* Full details of a signal.  */
-- 
tg: (854baea9b7..) t2.26/sigsetops.h (depends on: baseline-2.26)
