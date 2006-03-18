libc_slibdir = /lib
libc_libdir = /usr/lib
libc_rtlddir = /lib

# /lib64 and /usr/lib64 are provided by glibc instead base-files: #259302.
define libc0.1_extra_pkg_install
ln -sf /lib debian/$(curpass)/lib64
ln -sf lib debian/$(curpass)/usr/lib64
endef

