# build libc with nptl instead of linuxthreads
libc_MIN_KERNEL_SUPPORTED = 2.6.0
libc_add-ons = nptl $(add-ons)
libc_extra_cflags = -O3
libc_extra_config_options := $(extra_config_options) --with-tls --with-__thread

# /lib64 and /usr/lib64 are provided by glibc instead base-files: #259302.
define libc6_extra_pkg_install
ln -sf /lib debian/$(curpass)/lib64
ln -sf lib debian/$(curpass)/usr/lib64
endef
define libc6-udeb_extra_pkg_install
ln -sf /lib debian/$(curpass)/lib64
endef

define libc_extra_install
mv debian/tmp-libc/lib64 debian/tmp-libc/lib
mv debian/tmp-libc/usr/lib64/* debian/tmp-libc/usr/lib
for link in $$(find debian/tmp-libc/usr/lib -type l) ; do ln -sf $$(readlink $$link | sed -e "s#64##g") $$link ; done
for so in $$(find debian/tmp-libc/usr/lib -maxdepth 1 -type f -name *.so) ; do perl -pi -e "s#/lib64/#/lib/#g" $$so ; done
endef

