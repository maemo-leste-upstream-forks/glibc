ifeq ($(DEB_HOST_GNU_CPU),alpha)
DEB_BUILD_OPTIONS = nostrip parallel
else
DEB_BUILD_OPTIONS = debug parallel
endif

ifneq (,$(findstring debug,$(DEB_BUILD_OPTIONS)))
DEB_BUILD_OPTION_DEBUG = yes
else
DEB_BUILD_OPTION_DEBUG = no
endif

ifneq (,$(findstring nostrip,$(DEB_BUILD_OPTIONS)))
DEB_BUILD_OPTION_STRIP = no
else
DEB_BUILD_OPTION_STRIP = yes
endif

ifneq (,$(findstring parallel,$(DEB_BUILD_OPTIONS)))
DEB_BUILD_OPTION_PARALLEL = yes
else
DEB_BUILD_OPTION_PARALLEL = no
endif
