## We use -mno-tls-direct-seg-refs to not wrap-around segments, as it
## greatly increase the speed when running under the 32bit Xen hypervisor.
#GLIBC_PASSES += xen
#DEB_ARCH_REGULAR_PACKAGES += libc0.3-xen
#xen_extra_cflags = -mno-tls-direct-seg-refs
#xen_slibdir = /lib/$(DEB_HOST_MULTIARCH)/i686/nosegneg
#
#ifeq ($(filter stage1,$(DEB_BUILD_PROFILES)),)
#define libc0.3-dev_extra_pkg_install
#mkdir -p debian/libc0.3-dev/$(libdir)/xen
#cp -af debian/tmp-xen/$(libdir)/*.a \
#	debian/libc0.3-dev/$(libdir)/xen
#endef
#endif

# FIXME: We are having linking issues with ifunc...
#
# when linking libc_pic.os into libc.so:
# /usr/bin/ld: /tmp/glibc-2.22/build-tree/hurd-i386-libc/libc_pic.os: warning: relocation against `_hurd_self_sigstate' in readonly section `.text'
# /usr/bin/ld: read-only segment has dynamic IFUNC relocations; recompile with -fPIC
# /usr/bin/ld: failed to set dynamic section sizes: Bad value
# See
# https://sourceware.org/bugzilla/show_bug.cgi?id=18801
# https://sourceware.org/ml/libc-alpha/2016-05/msg00686.html
# https://sourceware.org/bugzilla/show_bug.cgi?id=19939
# supposed to be fixed in binutils 2.27
#
# For now we are just disabling ifunc:
export libc_cv_ld_gnu_indirect_function=no
