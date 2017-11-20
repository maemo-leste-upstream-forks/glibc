######################################################################
# All architectures
######################################################################
# These can fail when running with other loads or in a virtual machine
test-xfail-tst-cpuclock2 = yes
test-xfail-tst-cputimer1 = yes
test-xfail-tst-timer = yes

# This is an upstream regression on multiple architectures
# see https://sourceware.org/bugzilla/show_bug.cgi?id=19303
test-xfail-tst-cancel24-static = yes

# Due to the nature of this test, it's very sensitive to system load
# in that, strangely, it wants more, not less.  Given that's hard to
# control, we'll just let it fail
test-xfail-tst-create-detached = yes

######################################################################
# alpha (including optimized flavours)
######################################################################
ifneq (,$(filter $(config-machine)-$(config-os), alpha-linux-gnu alphaev67-linux-gnu))
test-xfail-tst-backtrace5 = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-cancel19 = yes
test-xfail-check-localplt = yes
test-xfail-test-double = yes
test-xfail-test-double-finite = yes
test-xfail-test-float = yes
test-xfail-test-float-finite = yes
test-xfail-test-fenv-return = yes
test-xfail-test-snan = yes
test-xfail-tst-eintr1 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-prelink-cmp = yes
test-xfail-tst-signal3 = yes
test-xfail-tst-timer4 = yes
test-xfail-tst-waitid = yes
test-xfail-tst-writev = yes
test-xfail-XOPEN2K8/netdb.h/conform = yes
test-xfail-XOPEN2K/netdb.h/conform = yes
endif


######################################################################
# amd64
######################################################################
ifeq ($(config-machine)-$(config-os),x86_64-linux-gnu)
test-xfail-tst-backtrace6 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-waitid = yes

# This test fails intermittently on amd64. It could be a kernel issue.
# see https://sourceware.org/bugzilla/show_bug.cgi?id=19004
test-xfail-tst-robust8 = yes
endif


######################################################################
# arm64
######################################################################
ifeq ($(config-machine)-$(config-os),aarch64-linux-gnu)
test-xfail-test-fenv = yes
test-xfail-test-fenv-tls = yes
test-xfail-tst-backtrace5 = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-stack4 = yes

# This can be removed once bug#750834 is fixed
test-xfail-basic-test = yes
endif


######################################################################
# armel
######################################################################
ifeq ($(config-machine)-$(config-os),arm-linux-gnueabi)
test-xfail-test-misc = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-makecontext = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-stack4 = yes
test-xfail-tst-waitid = yes

# This can be removed once bug#748616 is fixed
test-xfail-basic-test = yes
endif


######################################################################
# armhf
######################################################################
ifeq ($(config-machine)-$(config-os),arm-linux-gnueabihf)
test-xfail-test-fenv = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-makecontext = yes
test-xfail-tst-stack4 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-waitid = yes
endif


######################################################################
# hppa
######################################################################
ifeq ($(config-machine)-$(config-os),hppa-linux-gnu)
test-xfail-check-execstack = yes
test-xfail-check-localplt = yes
test-xfail-check-textrel = yes
test-xfail-tst-audit2 = yes
test-xfail-tst-backtrace2 = yes
test-xfail-tst-backtrace3 = yes
test-xfail-tst-backtrace4 = yes
test-xfail-tst-backtrace5 = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-cleanupx4 = yes
test-xfail-tst-makecontext = yes
test-xfail-tst-protected1a = yes
test-xfail-tst-protected1b = yes
test-xfail-tst-setcontext2 = yes
test-xfail-tst-stack4 = yes
# The following tests sometimes fail due to timeouts.
test-xfail-tst-barrier5 = yes
test-xfail-tst-cond25 = yes
endif


######################################################################
# hurd-i386 (including optimized flavours)
######################################################################
ifeq ($(config-machine)-$(config-os),i686-gnu-gnu-gnu)
# sysdeps/mach/hurd/dl-sysdep.c's open_file does not support the linker
# creating files.
test-xfail-tst-null-argv = yes

# Tests failing to build
tests-unsupported += test-as-const-signal-defines
tests-unsupported += tst-cputimer1
tests-unsupported += tst-cputimer2
tests-unsupported += tst-cputimer3
tests-unsupported += tst-timer4
tests-unsupported += tst-timer5
tests-unsupported += tst-malloc-backtrace

# bounding memory allocation is not supported yet
tests-unsupported += tst-malloc-thread-fail
tests-unsupported += tst-dynarray-fail

# We don't provide /proc/cpuinfo yet
test-xfail-test-multiarch = yes

# Need actual porting
test-xfail-exe = yes
test-xfail-tst-pselect = yes
test-xfail-tst-ptrguard1-static = yes
test-xfail-tst-ptrguard1 = yes

# We don't provide ABI reference yet
test-xfail-check-abi-libcrypt = yes
test-xfail-check-abi-libdl = yes
test-xfail-check-abi-ld = yes
test-xfail-check-abi-libc = yes
test-xfail-check-abi-libhurduser = yes
test-xfail-check-abi-libpthread = yes
test-xfail-check-abi-libBrokenLocale = yes
test-xfail-check-abi-libutil = yes
test-xfail-check-abi-libmachuser = yes
test-xfail-check-abi-libm = yes
test-xfail-check-abi-libnsl = yes
test-xfail-check-abi-libanl = yes
test-xfail-check-abi-libresolv = yes
test-xfail-check-abi-librt = yes

# Overzealous test
test-xfail-tst-pathconf = yes

# Need investigation
test-xfail-check-execstack = yes
test-xfail-check-localplt = yes
test-xfail-tst-aio10 = yes
test-xfail-tst-aio9 = yes
test-xfail-tst-audit1 = yes
test-xfail-tst-audit2 = yes
test-xfail-tst-audit8 = yes
test-xfail-tst-backtrace4 = yes
test-xfail-tst-backtrace5 = yes
test-xfail-tst-chk2 = yes
test-xfail-tst-chk3 = yes
test-xfail-tst-chk5 = yes
test-xfail-tst-chk6 = yes
test-xfail-tst-fdopendir2 = yes
test-xfail-tst-fdopendir = yes
test-xfail-tst-futimesat = yes
test-xfail-tst-getconf = yes
test-xfail-tst-grantpt = yes
test-xfail-tst-lfschk2 = yes
test-xfail-tst-lfschk3 = yes
test-xfail-tst-lfschk5 = yes
test-xfail-tst-lfschk6 = yes
test-xfail-tst-longjmp_chk2 = yes
test-xfail-tst-mallocfork2 = yes
test-xfail-tst-sprofil = yes
test-xfail-tst-stackguard1-static = yes
test-xfail-tst-stackguard1 = yes
test-xfail-tst-strtod-round = yes
test-xfail-tst-sysconf = yes
test-xfail-tst-vfork3-mem = yes

# This generates GiBs of data instead of sparse files, putting build box on its knees
tests-unsupported += test-lfs

# Needs LFS support
#test-xfail-test-lfs = yes
test-xfail-tst-tzset = yes

# new in 2.21
test-xfail-test-misc = yes
test-xfail-tst-ptsname = yes
test-xfail-tst-audit9 = yes

test-xfail-POSIX2008/mqueue.h/conform = yes
test-xfail-POSIX2008/pthread.h/conform = yes
test-xfail-POSIX2008/sys/stat.h/conform = yes
test-xfail-POSIX2008/sys/statvfs.h/conform = yes
test-xfail-POSIX2008/sys/un.h/conform = yes
test-xfail-POSIX2008/termios.h/conform = yes
test-xfail-POSIX/fcntl.h/conform = yes
test-xfail-POSIX/mqueue.h/conform = yes
test-xfail-POSIX/sys/stat.h/conform = yes
test-xfail-UNIX98/mqueue.h/conform = yes
test-xfail-UNIX98/sys/stat.h/conform = yes
test-xfail-UNIX98/termios.h/conform = yes
test-xfail-XOPEN2K8/mqueue.h/conform = yes
test-xfail-XOPEN2K8/pthread.h/conform = yes
test-xfail-XOPEN2K8/sys/stat.h/conform = yes
test-xfail-XOPEN2K/sys/stat.h/conform = yes

# new in 2.22
test-xfail-tst-audit3 = yes
test-xfail-tst-prelink = yes
test-xfail-tst-tls-atexit = yes

test-xfail-POSIX2008/fcntl.h/conform = yes
test-xfail-UNIX98/sys/ipc.h/conform = yes
test-xfail-UNIX98/sys/msg.h/conform = yes
test-xfail-UNIX98/sys/resource.h/conform = yes
test-xfail-UNIX98/sys/shm.h/conform = yes
test-xfail-UNIX98/sys/statvfs.h/conform = yes
test-xfail-UNIX98/sys/un.h/conform = yes
test-xfail-XOPEN2K8/arpa/inet.h/conform = yes
test-xfail-XOPEN2K8/fcntl.h/conform = yes
test-xfail-XOPEN2K8/netdb.h/conform = yes
test-xfail-XOPEN2K8/netinet/in.h/conform = yes
test-xfail-XOPEN2K8/sys/ipc.h/conform = yes
test-xfail-XOPEN2K8/sys/msg.h/conform = yes
test-xfail-XOPEN2K8/sys/resource.h/conform = yes
test-xfail-XOPEN2K8/sys/shm.h/conform = yes
test-xfail-XOPEN2K8/sys/statvfs.h/conform = yes
test-xfail-XOPEN2K8/sys/un.h/conform = yes
test-xfail-XOPEN2K/arpa/inet.h/conform = yes
test-xfail-XOPEN2K/netdb.h/conform = yes
test-xfail-XOPEN2K/netinet/in.h/conform = yes
test-xfail-XOPEN2K/sys/ipc.h/conform = yes
test-xfail-XOPEN2K/sys/msg.h/conform = yes
test-xfail-XOPEN2K/sys/resource.h/conform = yes
test-xfail-XOPEN2K/sys/shm.h/conform = yes
test-xfail-XOPEN2K/sys/statvfs.h/conform = yes
test-xfail-XOPEN2K/sys/un.h/conform = yes
test-xfail-XPG4/sys/ipc.h/conform = yes
test-xfail-XPG4/sys/msg.h/conform = yes
test-xfail-XPG4/sys/shm.h/conform = yes

# changed in 2.22, tests were run directly, now using threads
# TODO: should be succeeding again with gnumach >= 2016-03-06
test-xfail-test-fpucw = yes
test-xfail-test-fpucw-ieee = yes
test-xfail-test-fpucw-ieee-static = yes
test-xfail-test-fpucw-static = yes
test-xfail-test-static = yes

# new in 2.23
test-xfail-test-fenv-sse-2 = yes
test-xfail-test-fenv-x87 = yes
test-xfail-tst-audit11 = yes
test-xfail-tst-audit12 = yes
test-xfail-tst-get-cpu-features = yes

# new in 2.24
test-xfail-tst-execvpe5 = yes
test-xfail-tst-spawn2 = yes
test-xfail-tst-support_record_failure = yes
test-xfail-tst-support_record_failure-2 = yes

test-xfail-UNIX98/fcntl.h/conform = yes
test-xfail-XOPEN2K/fcntl.h/conform = yes
test-xfail-XOPEN2K/mqueue.h/conform = yes
test-xfail-XOPEN2K/termios.h/conform = yes
test-xfail-XOPEN2K8/termios.h/conform = yes
test-xfail-XPG4/fcntl.h/conform = yes
test-xfail-XPG4/sys/stat.h/conform = yes
test-xfail-XPG4/termios.h/conform = yes
# fails randomly
test-xfail-tst-preadvwritev64 = yes
test-xfail-tst-preadwrite64 = yes

# fixed upstream
test-xfail-POSIX/signal.h/conform = yes

# happens on linux-i386 too
test-xfail-annexc = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-waitid = yes

# seems fixed in 2.24-3?
test-xfail-tst-secure-getenv = yes

# new in 2.25
test-xfail-tst-posix_fallocate64 = yes
test-xfail-test-fesetexcept-traps = yes
test-xfail-tst-posix_fadvise = yes
test-xfail-tst-posix_fadvise64 = yes
test-xfail-tst-vfork3 = yes
test-xfail-tst-wcstod-round = yes
test-xfail-tst-env-setuid = yes
test-xfail-tst-env-setuid-tunables = yes

# new in 2.26
test-xfail-tst-malloc-usable-static-tunables = yes
test-xfail-tst-malloc-usable-static = yes
test-xfail-tst-malloc-tcache-leak = yes
test-xfail-tst-dynarray-fail-mem = yes
test-xfail-test-errno = yes

test-xfail-UNIX98/arpa/inet.h/conform = yes
test-xfail-UNIX98/netdb.h/conform = yes
test-xfail-UNIX98/netinet/in.h/conform = yes
test-xfail-POSIX2008/arpa/inet.h/conform = yes
test-xfail-POSIX2008/netdb.h/conform = yes
test-xfail-POSIX2008/netinet/in.h/conform = yes
test-xfail-XPG42/arpa/inet.h/conform = yes
test-xfail-XPG42/fcntl.h/conform = yes
test-xfail-XPG42/netdb.h/conform = yes
test-xfail-XPG42/netinet/in.h/conform = yes
test-xfail-XPG42/sys/ipc.h/conform = yes
test-xfail-XPG42/sys/msg.h/conform = yes
test-xfail-XPG42/sys/resource.h/conform = yes
test-xfail-XPG42/sys/shm.h/conform = yes
test-xfail-XPG42/sys/stat.h/conform = yes
test-xfail-XPG42/sys/statvfs.h/conform = yes
test-xfail-XPG42/sys/un.h/conform = yes
test-xfail-XPG42/termios.h/conform = yes

# will be fixed in hurd >= 20170926
test-xfail-tst-bug18665-tcp = yes
test-xfail-tst-resolv-basic = yes
test-xfail-tst-resolv-search = yes
endif


######################################################################
# i386 (including optimized flavours)
######################################################################
ifeq ($(config-machine)-$(config-os),i686-linux-gnu)
test-xfail-tst-backtrace6 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-waitid = yes

# Probably a GCC bug: https://sourceware.org/ml/libc-alpha/2015-11/msg00533.html
test-xfail-tst-cleanupx4 = yes
endif


######################################################################
# kfreebsd-*
######################################################################
ifeq ($(config-os),kfreebsd-gnu)

# Most of these tests fail because fsid_t is defined as an union to
# support both __val (POSIX) and val (BSD) name.
test-xfail-ISO/ctype.h/conform = yes
test-xfail-ISO/signal.h/conform = yes
test-xfail-ISO/stdio.h/conform = yes
test-xfail-ISO/math.h/conform = yes
test-xfail-ISO/time.h/conform = yes
test-xfail-ISO11/ctype.h/conform = yes
test-xfail-ISO11/inttypes.h/conform = yes
test-xfail-ISO11/math.h/conform = yes
test-xfail-ISO11/signal.h/conform = yes
test-xfail-ISO11/stdint.h/conform = yes
test-xfail-ISO11/stdio.h/conform = yes
test-xfail-ISO11/time.h/conform = yes
test-xfail-ISO11/tgmath.h/conform = yes
test-xfail-ISO11/wctype.h/conform = yes
test-xfail-ISO99/ctype.h/conform = yes
test-xfail-ISO99/inttypes.h/conform = yes
test-xfail-ISO99/math.h/conform = yes
test-xfail-ISO99/signal.h/conform = yes
test-xfail-ISO99/stdint.h/conform = yes
test-xfail-ISO99/stdio.h/conform = yes
test-xfail-ISO99/time.h/conform = yes
test-xfail-ISO99/tgmath.h/conform = yes
test-xfail-ISO99/wctype.h/conform = yes
test-xfail-POSIX/aio.h/conform = yes
test-xfail-POSIX/ctype.h/conform = yes
test-xfail-POSIX/dirent.h/conform = yes
test-xfail-POSIX/fcntl.h/conform = yes
test-xfail-POSIX/grp.h/conform = yes
test-xfail-POSIX/math.h/conform = yes
test-xfail-POSIX/mqueue.h/conform = yes
test-xfail-POSIX/pthread.h/conform = yes
test-xfail-POSIX/pwd.h/conform = yes
test-xfail-POSIX/regex.h/conform = yes
test-xfail-POSIX/sched.h/conform = yes
test-xfail-POSIX/semaphore.h/conform = yes
test-xfail-POSIX/signal.h/conform = yes
test-xfail-POSIX/stdio.h/conform = yes
test-xfail-POSIX/sys/mman.h/conform = yes
test-xfail-POSIX/sys/stat.h/conform = yes
test-xfail-POSIX/sys/times.h/conform = yes
test-xfail-POSIX/sys/types.h/conform = yes
test-xfail-POSIX/time.h/conform = yes
test-xfail-POSIX/unistd.h/conform = yes
test-xfail-POSIX/utime.h/conform = yes
test-xfail-POSIX2008/aio.h/conform = yes
test-xfail-POSIX2008/ctype.h/conform = yes
test-xfail-POSIX2008/dirent.h/conform = yes
test-xfail-POSIX2008/errno.h/conform = yes
test-xfail-POSIX2008/fcntl.h/conform = yes
test-xfail-POSIX2008/grp.h/conform = yes
test-xfail-POSIX2008/inttypes.h/conform = yes
test-xfail-POSIX2008/math.h/conform = yes
test-xfail-POSIX2008/monetary.h/conform = yes
test-xfail-POSIX2008/mqueue.h/conform = yes
test-xfail-POSIX2008/net/if.h/conform = yes
test-xfail-POSIX2008/netdb.h/linknamespace = yes
test-xfail-POSIX2008/netinet/tcp.h/conform = yes
test-xfail-POSIX2008/pthread.h/conform = yes
test-xfail-POSIX2008/pwd.h/conform = yes
test-xfail-POSIX2008/regex.h/conform = yes
test-xfail-POSIX2008/sched.h/conform = yes
test-xfail-POSIX2008/semaphore.h/conform = yes
test-xfail-POSIX2008/stdint.h/conform = yes
test-xfail-POSIX2008/spawn.h/conform = yes
test-xfail-POSIX2008/stdio.h/conform = yes
test-xfail-POSIX2008/stropts.h/conform = yes
test-xfail-POSIX2008/sys/mman.h/conform = yes
test-xfail-POSIX2008/sys/select.h/conform = yes
test-xfail-POSIX2008/sys/stat.h/conform = yes
test-xfail-POSIX2008/sys/statvfs.h/conform = yes
test-xfail-POSIX2008/sys/times.h/conform = yes
test-xfail-POSIX2008/sys/types.h/conform = yes
test-xfail-POSIX2008/sys/un.h/conform = yes
test-xfail-POSIX2008/termios.h/conform = yes
test-xfail-POSIX2008/tgmath.h/conform = yes
test-xfail-POSIX2008/time.h/conform = yes
test-xfail-POSIX2008/unistd.h/conform = yes
test-xfail-POSIX2008/utime.h/conform = yes
test-xfail-POSIX2008/wctype.h/conform = yes
test-xfail-UNIX98/aio.h/conform = yes
test-xfail-UNIX98/ctype.h/conform = yes
test-xfail-UNIX98/dirent.h/conform = yes
test-xfail-UNIX98/errno.h/conform = yes
test-xfail-UNIX98/fcntl.h/conform = yes
test-xfail-UNIX98/ftw.h/conform = yes
test-xfail-UNIX98/grp.h/conform = yes
test-xfail-UNIX98/math.h/conform = yes
test-xfail-UNIX98/monetary.h/conform = yes
test-xfail-UNIX98/mqueue.h/conform = yes
test-xfail-UNIX98/pthread.h/conform = yes
test-xfail-UNIX98/pwd.h/conform = yes
test-xfail-UNIX98/regex.h/conform = yes
test-xfail-UNIX98/sched.h/conform = yes
test-xfail-UNIX98/semaphore.h/conform = yes
test-xfail-UNIX98/stdio.h/conform = yes
test-xfail-UNIX98/stdlib.h/conform = yes
test-xfail-UNIX98/stropts.h/conform = yes
test-xfail-UNIX98/sys/ipc.h/conform = yes
test-xfail-UNIX98/sys/mman.h/conform = yes
test-xfail-UNIX98/sys/msg.h/conform = yes
test-xfail-UNIX98/sys/resource.h/conform = yes
test-xfail-UNIX98/sys/sem.h/conform = yes
test-xfail-UNIX98/sys/shm.h/conform = yes
test-xfail-UNIX98/sys/socket.h/conform = yes
test-xfail-UNIX98/sys/stat.h/conform = yes
test-xfail-UNIX98/sys/statvfs.h/conform = yes
test-xfail-UNIX98/sys/time.h/conform = yes
test-xfail-UNIX98/sys/timeb.h/conform = yes
test-xfail-UNIX98/sys/times.h/conform = yes
test-xfail-UNIX98/sys/types.h/conform = yes
test-xfail-UNIX98/sys/uio.h/conform = yes
test-xfail-UNIX98/sys/un.h/conform = yes
test-xfail-UNIX98/termios.h/conform = yes
test-xfail-UNIX98/time.h/conform = yes
test-xfail-UNIX98/unistd.h/conform = yes
test-xfail-UNIX98/utime.h/conform = yes
test-xfail-UNIX98/utmpx.h/conform = yes
test-xfail-UNIX98/wchar.h/conform = yes
test-xfail-UNIX98/wctype.h/conform = yes
test-xfail-XOPEN2K/aio.h/conform = yes
test-xfail-XOPEN2K/arpa/inet.h/conform = yes
test-xfail-XOPEN2K/ctype.h/conform = yes
test-xfail-XOPEN2K/dirent.h/conform = yes
test-xfail-XOPEN2K/errno.h/conform = yes
test-xfail-XOPEN2K/fcntl.h/conform = yes
test-xfail-XOPEN2K/ftw.h/conform = yes
test-xfail-XOPEN2K/grp.h/conform = yes
test-xfail-XOPEN2K/inttypes.h/conform = yes
test-xfail-XOPEN2K/math.h/conform = yes
test-xfail-XOPEN2K/monetary.h/conform = yes
test-xfail-XOPEN2K/mqueue.h/conform = yes
test-xfail-XOPEN2K/net/if.h/conform = yes
test-xfail-XOPEN2K/netdb.h/conform = yes
test-xfail-XOPEN2K/netdb.h/linknamespace = yes
test-xfail-XOPEN2K/netinet/in.h/conform = yes
test-xfail-XOPEN2K/netinet/tcp.h/conform = yes
test-xfail-XOPEN2K/pthread.h/conform = yes
test-xfail-XOPEN2K/pwd.h/conform = yes
test-xfail-XOPEN2K/regex.h/conform = yes
test-xfail-XOPEN2K/sched.h/conform = yes
test-xfail-XOPEN2K/spawn.h/conform = yes
test-xfail-XOPEN2K/stdio.h/conform = yes
test-xfail-XOPEN2K/stdint.h/conform = yes
test-xfail-XOPEN2K/stdlib.h/conform = yes
test-xfail-XOPEN2K/stropts.h/conform = yes
test-xfail-XOPEN2K/sys/ipc.h/conform = yes
test-xfail-XOPEN2K/sys/mman.h/conform = yes
test-xfail-XOPEN2K/sys/msg.h/conform = yes
test-xfail-XOPEN2K/sys/resource.h/conform = yes
test-xfail-XOPEN2K/sys/select.h/conform = yes
test-xfail-XOPEN2K/sys/sem.h/conform = yes
test-xfail-XOPEN2K/sys/shm.h/conform = yes
test-xfail-XOPEN2K/sys/socket.h/conform = yes
test-xfail-XOPEN2K/sys/stat.h/conform = yes
test-xfail-XOPEN2K/sys/statvfs.h/conform = yes
test-xfail-XOPEN2K/sys/time.h/conform = yes
test-xfail-XOPEN2K/sys/timeb.h/conform = yes
test-xfail-XOPEN2K/sys/times.h/conform = yes
test-xfail-XOPEN2K/sys/types.h/conform = yes
test-xfail-XOPEN2K/sys/uio.h/conform = yes
test-xfail-XOPEN2K/sys/un.h/conform = yes
test-xfail-XOPEN2K/termios.h/conform = yes
test-xfail-XOPEN2K/time.h/conform = yes
test-xfail-XOPEN2K/tgmath.h/conform = yes
test-xfail-XOPEN2K/unistd.h/conform = yes
test-xfail-XOPEN2K/utime.h/conform = yes
test-xfail-XOPEN2K/utmpx.h/conform = yes
test-xfail-XOPEN2K/wchar.h/conform = yes
test-xfail-XOPEN2K/wctype.h/conform = yes
test-xfail-XOPEN2K8/aio.h/conform = yes
test-xfail-XOPEN2K8/arpa/inet.h/conform = yes
test-xfail-XOPEN2K8/ctype.h/conform = yes
test-xfail-XOPEN2K8/dirent.h/conform = yes
test-xfail-XOPEN2K8/errno.h/conform = yes
test-xfail-XOPEN2K8/fcntl.h/conform = yes
test-xfail-XOPEN2K8/ftw.h/conform = yes
test-xfail-XOPEN2K8/grp.h/conform = yes
test-xfail-XOPEN2K8/inttypes.h/conform = yes
test-xfail-XOPEN2K8/math.h/conform = yes
test-xfail-XOPEN2K8/monetary.h/conform = yes
test-xfail-XOPEN2K8/mqueue.h/conform = yes
test-xfail-XOPEN2K8/net/if.h/conform = yes
test-xfail-XOPEN2K8/netdb.h/conform = yes
test-xfail-XOPEN2K8/netdb.h/linknamespace = yes
test-xfail-XOPEN2K8/netinet/in.h/conform = yes
test-xfail-XOPEN2K8/netinet/tcp.h/conform = yes
test-xfail-XOPEN2K8/pthread.h/conform = yes
test-xfail-XOPEN2K8/pwd.h/conform = yes
test-xfail-XOPEN2K8/regex.h/conform = yes
test-xfail-XOPEN2K8/sched.h/conform = yes
test-xfail-XOPEN2K8/semaphore.h/conform = yes
test-xfail-XOPEN2K8/spawn.h/conform = yes
test-xfail-XOPEN2K8/stdio.h/conform = yes
test-xfail-XOPEN2K8/stdint.h/conform = yes
test-xfail-XOPEN2K8/stdlib.h/conform = yes
test-xfail-XOPEN2K8/stropts.h/conform = yes
test-xfail-XOPEN2K8/sys/ipc.h/conform = yes
test-xfail-XOPEN2K8/sys/mman.h/conform = yes
test-xfail-XOPEN2K8/sys/msg.h/conform = yes
test-xfail-XOPEN2K8/sys/resource.h/conform = yes
test-xfail-XOPEN2K8/sys/select.h/conform = yes
test-xfail-XOPEN2K8/sys/sem.h/conform = yes
test-xfail-XOPEN2K8/sys/shm.h/conform = yes
test-xfail-XOPEN2K8/sys/socket.h/conform = yes
test-xfail-XOPEN2K8/sys/stat.h/conform = yes
test-xfail-XOPEN2K8/sys/statvfs.h/conform = yes
test-xfail-XOPEN2K8/sys/time.h/conform = yes
test-xfail-XOPEN2K8/sys/times.h/conform = yes
test-xfail-XOPEN2K8/sys/types.h/conform = yes
test-xfail-XOPEN2K8/sys/uio.h/conform = yes
test-xfail-XOPEN2K8/sys/un.h/conform = yes
test-xfail-XOPEN2K8/termios.h/conform = yes
test-xfail-XOPEN2K8/tgmath.h/conform = yes
test-xfail-XOPEN2K8/time.h/conform = yes
test-xfail-XOPEN2K8/unistd.h/conform = yes
test-xfail-XOPEN2K8/utime.h/conform = yes
test-xfail-XOPEN2K8/utmpx.h/conform = yes
test-xfail-XOPEN2K8/wchar.h/conform = yes
test-xfail-XOPEN2K8/wctype.h/conform = yes
test-xfail-XPG4/ctype.h/conform = yes
test-xfail-XPG4/dirent.h/conform = yes
test-xfail-XPG4/errno.h/conform = yes
test-xfail-XPG4/fcntl.h/conform = yes
test-xfail-XPG4/ftw.h/conform = yes
test-xfail-XPG4/grp.h/conform = yes
test-xfail-XPG4/math.h/conform = yes
test-xfail-XPG4/monetary.h/conform = yes
test-xfail-XPG4/pwd.h/conform = yes
test-xfail-XPG4/regex.h/conform = yes
test-xfail-XPG4/stdio.h/conform = yes
test-xfail-XPG4/stdlib.h/conform = yes
test-xfail-XPG4/stropts.h/conform = yes
test-xfail-XPG4/sys/ipc.h/conform = yes
test-xfail-XPG4/sys/mman.h/conform = yes
test-xfail-XPG4/sys/msg.h/conform = yes
test-xfail-XPG4/sys/sem.h/conform = yes
test-xfail-XPG4/sys/shm.h/conform = yes
test-xfail-XPG4/sys/socket.h/conform = yes
test-xfail-XPG4/sys/stat.h/conform = yes
test-xfail-XPG4/sys/time.h/conform = yes
test-xfail-XPG4/sys/timeb.h/conform = yes
test-xfail-XPG4/sys/times.h/conform = yes
test-xfail-XPG4/sys/types.h/conform = yes
test-xfail-XPG4/sys/uio.h/conform = yes
test-xfail-XPG4/termios.h/conform = yes
test-xfail-XPG4/time.h/conform = yes
test-xfail-XPG4/unistd.h/conform = yes
test-xfail-XPG4/utime.h/conform = yes
test-xfail-XPG4/utmpx.h/conform = yes

# Most of these failures are due to headers provided by kfreebsd-kernel-headers
test-xfail-check-installed-headers-c = yes
test-xfail-check-installed-headers-c = yes
test-xfail-check-installed-headers-cxx = yes
test-xfail-check-installed-headers-c = yes
test-xfail-check-installed-headers-cxx = yes
test-xfail-check-installed-headers-c = yes
test-xfail-check-installed-headers-c = yes
test-xfail-check-installed-headers-c = yes
test-xfail-check-installed-headers-cxx = yes
test-xfail-check-installed-headers-c = yes
test-xfail-check-installed-headers-cxx = yes

# will expectedly SIGSEGV on kfreebsd 10.0 and later, due to having
# nxstack=1 by default (bug #762404)
test-xfail-tst-execstack = yes
test-xfail-tst-execstack-needed = yes
test-xfail-tst-execstack-prog = =yes
endif


######################################################################
# kfreebsd-amd64
######################################################################
ifeq ($(config-machine)-$(config-os),x86_64-kfreebsd-gnu)
test-xfail-check-local-headers = yes
test-xfail-test-sysvsem = yes
test-xfail-test-sysvshm = yes
test-xfail-tst-aio10 = yes
test-xfail-tst-aio9 = yes
test-xfail-tst-attr2 = yes
test-xfail-tst-attr3 = yes
test-xfail-tst-cancel7 = yes
test-xfail-tst-cancelx7 = yes
test-xfail-tst-default-attr = yes
test-xfail-tst-getpid1 = yes
test-xfail-tst-getpid2 = yes
test-xfail-tst-longjmp_chk = yes
test-xfail-tst-renameat = yes
test-xfail-tst-setcontext2 = yes
test-xfail-tst-shm = yes
test-xfail-tst-spawn2 = yes
test-xfail-tst-spawn3 = yes
test-xfail-tst-udp-error = yes
test-xfail-tst-waitid = yes
test-xfail-tst-writev = yes
endif


######################################################################
# kfreebsd-i386 (including optimized flavours)
######################################################################
ifeq ($(config-machine)-$(config-os),i686-kfreebsd-gnu)
test-xfail-check-local-headers = yes
test-xfail-test-sysvsem = yes
test-xfail-test-sysvshm = yes
test-xfail-tst-aio10 = yes
test-xfail-tst-aio9 = yes
test-xfail-tst-attr2 = yes
test-xfail-tst-attr3 = yes
test-xfail-tst-cancel7 = yes
test-xfail-tst-cancelx7 = yes
test-xfail-tst-cleanupx4 = yes
test-xfail-tst-default-attr = yes
test-xfail-tst-getpid1 = yes
test-xfail-tst-getpid2 = yes
test-xfail-tst-longjmp_chk = yes
test-xfail-tst-renameat = yes
test-xfail-tst-setcontext2 = yes
test-xfail-tst-shm = yes
test-xfail-tst-spawn2 = yes
test-xfail-tst-spawn3 = yes
test-xfail-tst-udp-error = yes
test-xfail-tst-waitid = yes
endif


######################################################################
# m68k
######################################################################
ifeq ($(config-machine)-$(config-os),m68k-linux-gnu)
test-xfail-annexc = yes
test-xfail-bug-nextafter = yes
test-xfail-bug-nexttoward = yes
test-xfail-bug-regex20 = yes
test-xfail-check-localplt = yes
test-xfail-localedata/sort-test = yes
test-xfail-test-double = yes
test-xfail-test-fenv = yes
test-xfail-test-float = yes
test-xfail-test-idouble = yes
test-xfail-test-ifloat = yes
test-xfail-test-misc = yes
test-xfail-tst-atomic-long = yes
test-xfail-tst-atomic = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-mqueue6 = yes
test-xfail-tst-mutexpi2 = yes
test-xfail-tst-mutexpi4 = yes
test-xfail-tst-mutexpi5a = yes
test-xfail-tst-mutexpi5 = yes
test-xfail-tst-mutexpi6 = yes
test-xfail-tst-mutexpi7a = yes
test-xfail-tst-mutexpi7 = yes
test-xfail-tst-mutexpi9 = yes
test-xfail-tst-robust1 = yes
test-xfail-tst-robust2 = yes
test-xfail-tst-robust3 = yes
test-xfail-tst-robust4 = yes
test-xfail-tst-robust5 = yes
test-xfail-tst-robust6 = yes
test-xfail-tst-robust7 = yes
test-xfail-tst-robust8 = yes
test-xfail-tst-robust9 = yes
test-xfail-tst-robustpi1 = yes
test-xfail-tst-robustpi2 = yes
test-xfail-tst-robustpi3 = yes
test-xfail-tst-robustpi4 = yes
test-xfail-tst-robustpi5 = yes
test-xfail-tst-robustpi6 = yes
test-xfail-tst-robustpi7 = yes
test-xfail-tst-robustpi8 = yes
test-xfail-tst-rxspencer = yes
endif


######################################################################
# mips*
######################################################################
ifneq (,$(filter $(config-machine)-$(config-os), mips-linux-gnu mipsel-linux-gnu mips64-linux-gnuabi64 mips64el-linux-gnuabi64 mips64-linux-gnuabin32 mips64el-linux-gnuabin32))
# MIPS GCC does not use PT_GNU_STACK markers (this is a GCC issue)
test-xfail-check-execstack = yes

# These tests require at least a kernel 4.0
test-xfail-tst-mode-switch-1 = yes
test-xfail-tst-mode-switch-2 = yes
test-xfail-tst-mode-switch-3 = yes

# Theses failures are due to a bug in the cvt.s.d instruction on some FPU
# (at least Octeon 3 and XBurst). The tininess detection is done on a
# before-rounding basis instead of an after-rounding basis.
test-xfail-test-float-fma = yes
test-xfail-test-float-finite-fma = yes

# Theses failures are due to a bug in the cvt.d.s instruction on some FPU
# (at least Octeon 3 and XBurst). The qNaN payload is not preserved in
# the conversion and a new qNaN is generated.
test-xfail-tst-strfrom = yes
test-xfail-tst-strfrom-locale = yes
endif


######################################################################
# mips
######################################################################
ifeq ($(config-machine)-$(config-os),mips-linux-gnu)
test-xfail-tst-cond16 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-stack4 = yes
test-xfail-tst-waitid = yes
endif


######################################################################
# mipsel
######################################################################
ifeq ($(config-machine)-$(config-os),mipsel-linux-gnu)
test-xfail-tst-cond16 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-stack4 = yes
test-xfail-tst-waitid = yes
endif


######################################################################
# mips64el
######################################################################
ifeq ($(config-machine)-$(config-os),mips64el-linux-gnuabi64)
test-xfail-tst-cond16 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-stack4 = yes
test-xfail-tst-waitid = yes

# These failures are due to a bug in the Loongson 3A FPU
test-xfail-test-double-lround = yes
test-xfail-test-double-finite-lround = yes
test-xfail-test-idouble-lround = yes
endif


######################################################################
# mipsn32el
######################################################################
ifeq ($(config-machine)-$(config-os),mips64el-linux-gnuabin32)
test-xfail-tst-audit1 = yes
test-xfail-tst-audit2 = yes
test-xfail-tst-audit8 = yes
test-xfail-tst-audit9 = yes
test-xfail-tst-cond16 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-stack4 = yes
test-xfail-tst-waitid = yes
endif


######################################################################
# mips64
######################################################################
ifeq ($(config-machine)-$(config-os),mips64-linux-gnuabi64)
test-xfail-tst-audit1 = yes
test-xfail-tst-audit2 = yes
test-xfail-tst-audit8 = yes
test-xfail-tst-audit9 = yes
test-xfail-tst-cond16 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-stack4 = yes
test-xfail-tst-waitid = yes
endif


######################################################################
# mipsn32
######################################################################
ifeq ($(config-machine)-$(config-os),mips64-linux-gnuabin32)
test-xfail-tst-audit1 = yes
test-xfail-tst-audit2 = yes
test-xfail-tst-audit8 = yes
test-xfail-tst-audit9 = yes
test-xfail-tst-cond16 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-stack4 = yes
test-xfail-tst-waitid = yes
endif


######################################################################
# ppc64el
######################################################################
ifeq ($(config-machine)-$(config-os),powerpc64le-linux-gnu)
test-xfail-tst-cancel17 = yes
test-xfail-tst-cancelx17 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-waitid = yes
endif

######################################################################
# ppc64
######################################################################
ifeq ($(config-machine)-$(config-os),powerpc64-linux-gnu)
test-xfail-tst-backtrace5 = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-waitid = yes

# Known failure not a regression, see https://sourceware.org/bugzilla/show_bug.cgi?id=6527
test-xfail-tst-malloc-thread-exit = yes
test-xfail-tst-malloc-thread-fail = yes
endif


######################################################################
# powerpc
######################################################################
ifeq ($(config-machine)-$(config-os),powerpc-linux-gnu)
test-xfail-tst-backtrace5 = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-waitid = yes

# Known failure not a regression, see https://sourceware.org/bugzilla/show_bug.cgi?id=6527
test-xfail-tst-malloc-thread-exit = yes
test-xfail-tst-malloc-thread-fail = yes

# Failures due to a GCC bug, see http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59412
#                            and http://gcc.gnu.org/bugzilla/show_bug.cgi?id=64811
test-xfail-test-double = yes
test-xfail-test-float = yes
test-xfail-test-idouble = yes
test-xfail-test-ifloat = yes

# Requires a recent CPU or a recent kernel for CPU feature detection
test-xfail-tst-set_ppr = yes
endif


######################################################################
# powerpcspe
######################################################################
ifeq ($(config-machine)-$(config-os),powerpc-linux-gnuspe)
test-xfail-annexc = yes
test-xfail-bug-nextafter = yes
test-xfail-bug-nexttoward = yes
test-xfail-check-localplt = yes
test-xfail-iconv-test = yes
test-xfail-isomac = yes
test-xfail-test-double = yes
test-xfail-test-fenv = yes
test-xfail-test-float = yes
test-xfail-test-idouble = yes
test-xfail-test-ifloat = yes
test-xfail-test-misc = yes
test-xfail-tst-backtrace5 = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-cancel4 = yes
test-xfail-tst-cancel5 = yes
test-xfail-tst-cancelx4 = yes
test-xfail-tst-cancelx5 = yes
test-xfail-tst-key1 = yes
test-xfail-tst-key4 = yes
test-xfail-tst-setcontext-fpscr = yes
endif


######################################################################
# s390x
######################################################################
ifeq ($(config-machine)-$(config-os),s390x-linux-gnu)
test-xfail-tst-cancel17 = yes
test-xfail-tst-cancelx17 = yes
test-xfail-tst-protected1a = yes
test-xfail-tst-protected1b = yes
test-xfail-tst-waitid = yes
endif


######################################################################
# sparc
######################################################################
ifeq ($(config-machine)-$(config-os),sparc-linux-gnu)
test-xfail-annexc = yes
test-xfail-check-localplt = yes
test-xfail-tst-backtrace2 = yes
test-xfail-tst-backtrace3 = yes
test-xfail-tst-backtrace4 = yes
test-xfail-tst-backtrace5 = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-waitid = yes

# Even if configured using --with-long-double-128, the biarch32 compiler
# on sparc64 defaults to 64-bit doubles, causing the failure below. This
# should be fixed by the following gcc patch:
# http://gcc.gnu.org/ml/gcc-patches/2013-12/msg00318.html
test-xfail-stdlib/isomac = yes
endif


######################################################################
# sparc64
######################################################################
ifeq ($(config-machine)-$(config-os),sparc64-linux-gnu)
test-xfail-ISO/setjmp.h/conform = yes
test-xfail-ISO11/setjmp.h/conform = yes
test-xfail-ISO99/setjmp.h/conform = yes
test-xfail-POSIX/pthread.h/conform = yes
test-xfail-POSIX/setjmp.h/conform = yes
test-xfail-POSIX2008/pthread.h/conform = yes
test-xfail-POSIX2008/setjmp.h/conform = yes
test-xfail-UNIX98/pthread.h/conform = yes
test-xfail-UNIX98/setjmp.h/conform = yes
test-xfail-XOPEN2K/pthread.h/conform = yes
test-xfail-XOPEN2K/setjmp.h/conform = yes
test-xfail-XOPEN2K8/pthread.h/conform = yes
test-xfail-XOPEN2K8/setjmp.h/conform = yes
test-xfail-XPG4/setjmp.h/conform = yes
test-xfail-tst-protected1a = yes
test-xfail-tst-protected1b = yes
test-xfail-tst-waitid = yes
endif


######################################################################
# x32
######################################################################
ifeq ($(config-machine)-$(config-os),x86_64-linux-gnux32)
test-xfail-ISO11/time.h/conform = yes
test-xfail-POSIX2008/mqueue.h/conform = yes
test-xfail-POSIX2008/sys/select.h/conform = yes
test-xfail-POSIX2008/sys/stat.h/conform = yes
test-xfail-POSIX2008/time.h/conform = yes
test-xfail-POSIX/mqueue.h/conform = yes
test-xfail-POSIX/sched.h/conform = yes
test-xfail-POSIX/time.h/conform = yes
test-xfail-UNIX98/mqueue.h/conform = yes
test-xfail-UNIX98/sched.h/conform = yes
test-xfail-UNIX98/time.h/conform = yes
test-xfail-XOPEN2K8/mqueue.h/conform = yes
test-xfail-XOPEN2K8/sys/select.h/conform = yes
test-xfail-XOPEN2K8/sys/stat.h/conform = yes
test-xfail-XOPEN2K8/time.h/conform = yes
test-xfail-XOPEN2K/mqueue.h/conform = yes
test-xfail-XOPEN2K/sys/select.h/conform = yes
test-xfail-XOPEN2K/time.h/conform = yes
test-xfail-tst-backtrace6 = yes
test-xfail-tst-mqueue5 = yes
test-xfail-tst-waitid = yes
endif
