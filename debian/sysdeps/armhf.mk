libc_add-ons = ports nptl $(add-ons)

# Use gcc-4.6 on armhf to get correct atomic operations in thumb-2 mode
ifneq ($(DEB_HOST_ARCH),$(DEB_BUILD_ARCH))
CC     = $(DEB_HOST_GNU_TYPE)-gcc
CXX    = $(DEB_HOST_GNU_TYPE)-g++
else
CC     = gcc-4.6
CXX    = g++-4.6
endif

# To be coinstallable with armel, we install ld.so to a multiarch directory
# from the beginning.
libc_rtlddir = /lib/$(DEB_HOST_MULTIARCH)

# This is only here while Debian/armhf is still transitioning linkers
# ** THIS MUST BE REMOVED BEFORE ENABLING THE BI-ARCH BUILD BELOW **
define libc6_extra_pkg_install
mkdir -p debian/libc6/lib
ln -sf $(libc_rtlddir)/ld-linux.so.3 debian/libc6/lib
endef

#EGLIBC_PASSES += armel
#DEB_ARCH_REGULAR_PACKAGES += libc6-armel libc6-dev-armel
#armel_add-ons = ports nptl $(add-ons)
#armel_CC = $(BUILD_CC) -mfloat-abi=softfp
#armel_CXX = $(BUILD_CXX) -mfloat-abi=softfp
#armel_slibdir = /lib/arm-linux-gnueabi
#armel_libdir = /usr/lib/arm-linux-gnueabi
#armel_rtlddir = /lib
#
#define libc6-dev-armel_extra_pkg_install
#mkdir -p debian/libc6-dev-armel/usr/include
#cp -a debian/tmp-armel/usr/include/bits \
#	debian/libc6-dev-armel/usr/include/
#cp -a debian/tmp-armel/usr/include/gnu \
#	debian/libc6-dev-armel/usr/include/
#cp -a debian/tmp-armel/usr/include/sys \
#	debian/libc6-dev-armel/usr/include/
#cp debian/tmp-armel/usr/include/fpu_control.h \
#	debian/libc6-dev-armel/usr/include/
#endef
#
#define libc6-armel_extra_pkg_install
#mkdir -p debian/libc6-armel/lib
#ln -sf $(armel_slibdir)/ld-linux.so.3 debian/libc6-armel/lib
#endef
