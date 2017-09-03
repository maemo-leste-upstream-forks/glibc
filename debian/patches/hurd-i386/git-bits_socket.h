commit 01969395db01fedcd3fb76d76654b24908e5757b
Author: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date:   Sun Sep 3 02:22:00 2017 +0200

    hurd: Fix getting ssize_t for <sys/socket.h>
    
            * sysdeps/mach/hurd/bits/socket.h: Include <sys/types.h> instead of
            just <bits/types.h>.

diff --git a/sysdeps/mach/hurd/bits/socket.h b/sysdeps/mach/hurd/bits/socket.h
index 6eb09a0ab3..9a412f0833 100644
--- a/sysdeps/mach/hurd/bits/socket.h
+++ b/sysdeps/mach/hurd/bits/socket.h
@@ -29,7 +29,7 @@
 #include <stddef.h>
 
 #include <limits.h>		/* XXX Is this allowed?  */
-#include <bits/types.h>
+#include <sys/types.h>
 
 /* Type for length arguments in socket calls.  */
 #ifndef __socklen_t_defined
