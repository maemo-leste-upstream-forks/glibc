# build 64-bit (sparc64) alternative library
GLIBC_PASSES += sparc64
DEB_ARCH_REGULAR_PACKAGES += libc6-sparc64 libc6-dev-sparc64
sparc64_add-ons = nptl $(add-ons)
sparc64_configure_target=sparc64-linux
sparc64_CC = $(BUILD_CC) -m64
libc6-sparc64_shlib_dep = libc6-sparc64 (>= $(shlib_dep_ver))
sparc64_extra_cflags = -g -O3
sparc64_extra_config_options = $(extra_config_options) --disable-profile
sparc64_includedir = /usr/include/sparc64-linux-gnu
sparc64_slibdir = /lib64
sparc64_libdir = /usr/lib64

define libc6-dev-sparc64_extra_pkg_install
mkdir -p debian/libc6-dev-sparc64/usr/include/gnu
cp -af debian/tmp-sparc64/usr/include/sparc64-linux-gnu/gnu/stubs-64.h \
        debian/libc6-dev-sparc64/usr/include/gnu
ln -sf . debian/libc6-dev-sparc64/usr/include/sparc64-linux-gnu
endef

# build a sparcv9 optimized library
GLIBC_PASSES += sparcv9
DEB_ARCH_REGULAR_PACKAGES += libc6-sparcv9
sparcv9_add-ons = nptl $(add-ons)
sparcv9_configure_target=sparcv9-linux
sparcv9_configure_build=sparcv9-linux
sparcv9_extra_cflags = -g -O3
sparcv9_extra_config_options = $(extra_config_options) --disable-profile
sparcv9_rtlddir = /lib
sparcv9_slibdir = /lib/v9

# build a sparcv9b optimized library
GLIBC_PASSES += sparcv9b
DEB_ARCH_REGULAR_PACKAGES += libc6-sparcv9b
sparcv9b_add-ons = nptl $(add-ons)
sparcv9b_configure_target=sparcv9b-linux
sparcv9b_configure_build=sparcv9b-linux
sparcv9b_extra_cflags = -mtune=ultrasparc3 -g -O3
sparcv9b_extra_config_options = $(extra_config_options) --disable-profile
sparcv9b_rtlddir = /lib
sparcv9b_slibdir = /lib/ultra3
