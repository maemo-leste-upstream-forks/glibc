libc_rtlddir = /lib64

# /lib64 and /usr/lib64 are provided by glibc instead base-files: #259302.
define libc6_extra_pkg_install
ln -sf /lib debian/$(curpass)/lib64
ln -sf lib debian/$(curpass)/usr/lib64
endef

# build 32-bit (s390) alternative library
EGLIBC_PASSES += s390
DEB_ARCH_REGULAR_PACKAGES += libc6-s390 libc6-dev-s390
s390_add-ons = nptl $(add-ons)
s390_configure_target = s390-linux-gnu
s390_CC = $(CC) -m32
s390_CXX = $(CXX) -m32
s390_extra_config_options := $(extra_config_options) --disable-profile
s390_includedir = /usr/include/s390-linux-gnu
s390_slibdir = /lib32
s390_libdir = /usr/lib32

define libc6-dev-s390_extra_pkg_install
mkdir -p debian/libc6-dev-s390/usr/include/gnu
cp -af debian/tmp-s390/usr/include/s390-linux-gnu/gnu/stubs-32.h \
        debian/libc6-dev-s390/usr/include/gnu
mkdir -p debian/libc6-dev-s390/usr/include/s390-linux-gnu
endef

define libc6-s390_extra_pkg_install
mkdir -p debian/$(curpass)/lib
ln -s /lib32/ld.so.1 debian/$(curpass)/lib
endef
