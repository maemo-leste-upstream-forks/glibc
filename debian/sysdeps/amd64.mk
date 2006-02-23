# build libc with nptl instead of linuxthreads
libc_MIN_KERNEL_SUPPORTED = 2.6.0
libc_add-ons = nptl $(add-ons)
libc_extra_cflags = -O3 -g1
slibdir = /lib
libdir = /usr/lib
rtlddir = /lib64

# /lib64 and /usr/lib64 are provided by glibc instead base-files: #259302.
define libc6_extra_pkg_install
ln -sf /lib debian/$(curpass)/lib64
ln -sf lib debian/$(curpass)/usr/lib64
endef

