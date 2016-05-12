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
