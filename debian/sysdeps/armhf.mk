# configuration options for all flavours
extra_config_options = --enable-multi-arch

# Install a compat symlink so old binaries keep working:
define libc6_extra_pkg_install
mkdir -p debian/libc6/lib/arm-linux-gnueabihf
ln -sf ld-linux-armhf.so.3 debian/libc6/lib/arm-linux-gnueabihf/ld-linux.so.3
endef

define libc6-udeb_extra_pkg_install
mkdir -p debian/libc6-udeb/lib/arm-linux-gnueabihf
ln -sf /lib/ld-linux-armhf.so.3 debian/libc6-udeb/lib/arm-linux-gnueabihf/ld-linux.so.3
endef

# multilib flavours
ifeq (,$(filter nobiarch, $(DEB_BUILD_PROFILES)))

# build soft-float (armel) alternative library
#GLIBC_PASSES += armel
#DEB_ARCH_MULTILIB_PACKAGES += libc6-armel libc6-dev-armel
#armel_configure_target = arm-linux-gnueabi
#armel_CC = $(CC) -mfloat-abi=soft
#armel_CXX = $(CXX) -mfloat-abi=soft
#armel_slibdir = /lib/arm-linux-gnueabi
#armel_libdir = /usr/lib/arm-linux-gnueabi
#
#define libc6-dev-armel_extra_pkg_install
#
#$(call generic_multilib_extra_pkg_install,libc6-dev-armel)
#
#mkdir -p debian/libc6-dev-armel/usr/include/arm-linux-gnueabihf/gnu
#cp -a debian/tmp-armel/usr/include/gnu/lib-names-soft.h \
#	debian/tmp-armel/usr/include/gnu/stubs-soft.h \
#	debian/libc6-dev-armel/usr/include/arm-linux-gnueabihf/gnu
#
#endef
#
#define libc6-armel_extra_pkg_install
#mkdir -p debian/libc6-armel/lib
#ln -sf $(armel_slibdir)/ld-linux.so.3 debian/libc6-armel/lib
#endef

endif # multilib
