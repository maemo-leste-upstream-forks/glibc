ifeq ($(DEB_HOST_GNU_TYPE),$(DEB_BUILD_GNU_TYPE))
cross_compiling := no
else
cross_compiling := yes
endif

include $(mkdir)/config.mk
include $(mkdir)/paths.mk
include $(mkdir)/soname.mk
include $(mkdir)/depflags.mk
include $(mkdir)/tools.mk
-include $(mkdir)/$(DEB_HOST_GNU_CPU).mk
-include $(mkdir)/$(DEB_HOST_GNU_SYSTEM).mk
-include $(mkdir)/$(DEB_HOST_GNU_TYPE).mk

ifeq ($(RELEASE),experimental)
glibc := glibc-$(RELEASE)
else
glibc := glibc
endif

include $(mkdir)/build-options.mk

ifeq ($(DEB_BUILD_OPTION_PARALLEL),yes)
  NPROCS:=$(shell getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)
  ifeq ($(NPROCS),0)
    PARALLELMFLAGS=
  else
    ifeq ($(NPROCS),-1)
      PARALLELMFLAGS=
    else
      ifeq ($(NPROCS),1)
	PARALLELMFLAGS=
      else
	ifeq ($(NPROCS),)
	  PARALLELMFLAGS=
	else
	  PARALLELMFLAGS=-j $(shell expr $(NPROCS) + $(NPROCS))
	endif
      endif
    endif
  endif
endif

HOST_CFLAGS = -pipe -O2 -fstrict-aliasing

ifeq ($(DEB_BUILD_OPTION_DEBUG),yes)
HOST_CFLAGS += -g
endif
