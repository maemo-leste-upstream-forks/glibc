GLIBC_PASSES += nptl i686
DEB_ARCH_REGULAR_PACKAGES += libc6-i686

# NPTL requires at least i486 assembly.  We don't need to take
# special measures for i386 systems, since Debian kernel images now
# emulate the missing instructions on the i386.
nptl_configure_target=i486-linux
nptl_configure_build=i486-linux
nptl_extra_cflags = -march=i486 -mtune=i686 -g1 -O3

# We use -march=i686 and glibc's i686 routines use cmov, so require it.
# A Debian-local glibc patch adds cmov to the search path.
# The optimized libraries also use NPTL!
i686_add-ons = nptl $(add-ons)
i686_configure_target=i686-linux
i686_configure_build=i686-linux
i686_extra_cflags = -march=i686 -mtune=i686 -g1 -O3
i686_LIBDIR = /tls/i686/cmov
i686_MIN_KERNEL_SUPPORTED = 2.6.0
i686_extra_config_options = $(extra_config_options) --disable-profile --with-tls --with-__thread

libc_extra_config_options = $(extra_config_options) --with-tls --without-__thread

# build 64-bit (amd64) alternative library
GLIBC_PASSES += amd64
DEB_ARCH_REGULAR_PACKAGES += libc6-amd64 libc6-dev-amd64
libc6-amd64_shlib_dep = libc6-amd64 (>= $(shlib_dep_ver))

amd64_configure_target = x86_64-linux
# __x86_64__ is defined here because Makeconfig uses -undef and the
# /usr/include/asm wrappers need that symbol.
amd64_CC = $(CC) -m64 -D__x86_64__
amd64_add-ons = nptl $(add-ons)
amd64_extra_cflags = -O3 -g1
amd64_extra_config_options = $(extra_config_options) --disable-profile \
	--includedir=/usr/include/x86_64-linux-gnu
amd64_LIBDIR = 64
amd64_MIN_KERNEL_SUPPORTED = 2.6.0

define amd64_extra_install
cp debian/tmp-amd64/usr/bin/ldd debian/tmp-libc/usr/bin
endef

define libc6-dev-amd64_extra_pkg_install
dh_install -plibc6-dev-amd64 debian/tmp-amd64/usr/include/x86_64-linux-gnu \
	usr/include
endef
