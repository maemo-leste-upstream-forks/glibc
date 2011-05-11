extra_config_options = --disable-multi-arch

# build 64-bit (sparc64) alternative library
EGLIBC_PASSES += sparc64
DEB_ARCH_REGULAR_PACKAGES += libc6-sparc64 libc6-dev-sparc64
sparc64_add-ons = nptl $(add-ons)
sparc64_configure_target=sparc64-linux-gnu
sparc64_CC = $(CC) -m64
sparc64_CXX = $(CXX) -m64
libc6-sparc64_shlib_dep = libc6-sparc64 (>= $(shlib_dep_ver))
sparc64_extra_config_options = $(extra_config_options) --disable-profile
sparc64_includedir = /usr/include/sparc64-linux-gnu
sparc64_rtlddir = /lib64
sparc64_slibdir = /lib64
sparc64_libdir = /usr/lib64

define libc6-dev-sparc64_extra_pkg_install
mkdir -p debian/libc6-dev-sparc64/usr/include/gnu
cp -af debian/tmp-sparc64/usr/include/sparc64-linux-gnu/gnu/stubs-64.h \
        debian/libc6-dev-sparc64/usr/include/gnu
mkdir -p debian/libc6-dev-sparc64/usr/include/sparc64-linux-gnu
endef
