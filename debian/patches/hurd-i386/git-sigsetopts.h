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
 
