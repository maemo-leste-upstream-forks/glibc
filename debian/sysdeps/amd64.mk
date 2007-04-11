libc_extra_cflags = -O3 -g
libc_slibdir = /lib
libc_libdir = /usr/lib
libc_rtlddir = /lib64

# /lib64 and /usr/lib64 are provided by glibc instead base-files: #259302.
define libc6_extra_pkg_install
ln -sf /lib debian/$(curpass)/lib64
ln -sf lib debian/$(curpass)/usr/lib64
endef

# build 32-bit (i386) alternative library
GLIBC_PASSES += i386
DEB_ARCH_REGULAR_PACKAGES += libc6-i386 libc6-dev-i386
libc6-i386_shlib_dep = libc6-i386 (>= $(shlib_dep_ver))
i386_add-ons = nptl $(add-ons)
i386_configure_target = i486-linux
i386_CC = $(CC) -m32
i386_extra_cflags = -march=pentium4 -g -O3
i386_extra_config_options = $(extra_config_options) --includedir=/usr/include/i486-linux-gnu 
i386_rtlddir = /lib
i386_slibdir = /emul/ia32-linux/lib
i386_libdir = /emul/ia32-linux/usr/lib

define libc6-dev-i386_extra_pkg_install
mkdir -p debian/libc6-dev-i386/usr/include
cp -af debian/tmp-i386/usr/include/i486-linux-gnu \
	debian/libc6-dev-i386/usr/include
endef

define libc6-i386_extra_pkg_install
mkdir -p debian/libc6-i386/lib
ln -sf /emul/ia32-linux/lib/ld-linux.so.2 debian/libc6-i386/lib
ln -sf /emul/ia32-linux/lib debian/libc6-i386/lib32
ln -sf /emul/ia32-linux/usr/lib debian/libc6-i386/usr/lib32
endef

