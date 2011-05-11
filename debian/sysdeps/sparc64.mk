extra_config_options = --disable-multi-arch
libc_rtlddir = /lib64
libc_extra_cflags = -mcpu=ultrasparc

# /lib64 and /usr/lib64 are provided by glibc instead base-files: #259302.
define libc6_extra_pkg_install
ln -sf lib debian/$(curpass)/lib64
ln -sf lib debian/$(curpass)/usr/lib64
endef
