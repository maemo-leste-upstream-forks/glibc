# hppa64 needs symlink /usr/hppa64-linux/include to /usr/include
# (See: Bug#239020)  In future we may drop this file with supporting hppa64.

define libc6-dev_extra_pkg_install
mkdir -p debian/$(curpass)/usr
mkdir -p debian/$(curpass)/usr/hppa64-linux
ln -sf /usr/include debian/$(curpass)/usr/hppa64-linux/include
endef

# some hppa linuxthreads tests: ex* do not work currently even if
# TIMEOUTSCALE is set - SIGALRM from the program is just ignored.
RUN_TESTSUITE = no

