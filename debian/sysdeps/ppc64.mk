# build libc with nptl instead of linuxthreads
libc_MIN_KERNEL_SUPPORTED = 2.6.0
libc_add-ons = nptl $(add-ons)
libc_extra_cflags = -O3 -g1
libc_slibdir = /lib
libc_libdir = /usr/lib
libc_rtlddir = /lib64

# /lib64 and /usr/lib64 are provided as symlinks 
define libc6_extra_pkg_install
ln -sf /lib debian/$(curpass)/lib64
ln -sf lib debian/$(curpass)/usr/lib64
endef

# build 32-bit (powerpc) alternative library
GLIBC_PASSES += powerpc
DEB_ARCH_REGULAR_PACKAGES += libc6-powerpc libc6-dev-powerpc
libc6-powerpc_shlib_dep = libc6-powerpc (>= $(shlib_dep_ver))

powerpc_configure_target = powerpc-linux
powerpc_CC = $(CC) -m32
powerpc_add-ons = nptl $(add-ons)
powerpc_extra_cflags = -O3 -g1
powerpc_rtlddir = /lib
powerpc_slibdir = /lib32
powerpc_libdir = /usr/lib32
powerpc_MIN_KERNEL_SUPPORTED = 2.6.0

# create a symlink for the 32 bit dynamic linker in /lib
define libc6-powerpc_extra_pkg_install
mkdir -p debian/$(curpass)/lib
ln -s /lib32/ld.so.1 debian/$(curpass)/lib
endef
