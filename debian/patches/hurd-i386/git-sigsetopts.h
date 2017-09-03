commit b794e16bcc9426e9e05ec465c6c8bab2902a50ed
Author: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date:   Sun Sep 3 01:08:49 2017 +0200

    sysdeps/generic/sigsetops.h: Remove spurious #endif

diff --git a/sysdeps/generic/sigsetops.h b/sysdeps/generic/sigsetops.h
index e8e5553981..ea2c5b5767 100644
--- a/sysdeps/generic/sigsetops.h
+++ b/sysdeps/generic/sigsetops.h
@@ -50,7 +50,6 @@
     *(dest) = *(left) | *(right);		\
     (void)0;					\
   }))
-#endif
 
 /* These macros needn't check for a bogus signal number;
    checking is done in the non-__ versions.  */
commit 06cf9d31d7caa408b35f194cdbdc17462eb935c2
Author: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date:   Sun Sep 3 01:45:19 2017 +0200

    hurd: Fix sigsetops.h macros
    
            * sysdeps/generic/sigsetops.h: Remove spurious #endif.
            (__sigismember, __sigaddset, __sigdelset): Fix referencing set
            parameter.

diff --git a/sysdeps/generic/sigsetops.h b/sysdeps/generic/sigsetops.h
index ea2c5b5767..6d1c004b04 100644
--- a/sysdeps/generic/sigsetops.h
+++ b/sysdeps/generic/sigsetops.h
@@ -56,20 +56,20 @@
 # define __sigismember(set, sig)		\
   (__extension__ ({				\
     __sigset_t __mask = __sigmask (sig);	\
-    (set) & __mask ? 1 : 0;			\
+    *(set) & __mask ? 1 : 0;			\
   }))
 
 # define __sigaddset(set, sig)			\
   (__extension__ ({				\
     __sigset_t __mask = __sigmask (sig);	\
-    (set) |= __mask;				\
+    *(set) |= __mask;				\
     (void)0;					\
   }))
 
 # define __sigdelset(set, sig)			\
   (__extension__ ({				\
     __sigset_t __mask = __sigmask (sig);	\
-    (set) &= ~__mask;				\
+    *(set) &= ~__mask;				\
     (void)0;					\
   }))
 
commit 127e7773b437bd5866a4424cc9b338bac6beb08b
Author: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date:   Sun Sep 3 04:36:29 2017 +0200

    hurd: Fix libc link
    
            * sysdeps/posix/pause.c: Include <sigsetops.h>.
            * sysdeps/posix/system.c: Include <sigsetops.h>.

diff --git a/sysdeps/posix/pause.c b/sysdeps/posix/pause.c
index 53e143d98f..7c17f49ffb 100644
--- a/sysdeps/posix/pause.c
+++ b/sysdeps/posix/pause.c
@@ -19,6 +19,7 @@
 #include <signal.h>
 #include <unistd.h>
 #include <sysdep-cancel.h>
+#include <sigsetops.h>
 
 /* Suspend the process until a signal arrives.
    This always returns -1 and sets errno to EINTR.  */
diff --git a/sysdeps/posix/system.c b/sysdeps/posix/system.c
index d49cc3f01c..56195b529f 100644
--- a/sysdeps/posix/system.c
+++ b/sysdeps/posix/system.c
@@ -24,6 +24,7 @@
 #include <sys/wait.h>
 #include <libc-lock.h>
 #include <sysdep-cancel.h>
+#include <sigsetops.h>
 
 
 #define	SHELL_PATH	"/bin/sh"	/* Path of the shell.  */
