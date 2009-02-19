# Because variables can be masked at anypoint by declaring
# PASS_VAR, we need to call all variables as $(call xx,VAR)
# This little bit of magic makes it possible:
xx=$(if $($(curpass)_$(1)),$($(curpass)_$(1)),$($(1)))

# We want to log output to a logfile but we also need to preserve the
# return code of the command being run.
# This little bit of magic makes it possible:
# $(call logme, [-a] <log file>, <cmd>)
define logme
(exec 3>&1; exit `( ( ( $(2) ) 2>&1 3>&-; echo $$? >&4) | tee $(1) >&3) 4>&1`)
endef


$(patsubst %,mkbuilddir_%,$(GLIBC_PASSES)) :: mkbuilddir_% : $(stamp)mkbuilddir_%
$(stamp)mkbuilddir_%: $(stamp)patch $(KERNEL_HEADER_DIR)
	@echo Making builddir for $(curpass)
	test -d $(DEB_BUILDDIR) || mkdir -p $(DEB_BUILDDIR)
	touch $@

$(patsubst %,configure_%,$(GLIBC_PASSES)) :: configure_% : $(stamp)configure_%
$(stamp)configure_%: $(stamp)mkbuilddir_%
	@echo Configuring $(curpass)
	rm -f $(DEB_BUILDDIR)/configparms
	echo "CC = $(call xx,CC)"		>> $(DEB_BUILDDIR)/configparms
	echo "CXX = $(call xx,CXX)"		>> $(DEB_BUILDDIR)/configparms
	echo "BUILD_CC = $(BUILD_CC)"		>> $(DEB_BUILDDIR)/configparms
	echo "BUILD_CXX = $(BUILD_CXX)"		>> $(DEB_BUILDDIR)/configparms
	echo "CFLAGS = $(HOST_CFLAGS)"		>> $(DEB_BUILDDIR)/configparms
	echo "BUILD_CFLAGS = $(BUILD_CFLAGS)" 	>> $(DEB_BUILDDIR)/configparms
	echo "LDFLAGS = "		 	>> $(DEB_BUILDDIR)/configparms
	echo "BASH := /bin/bash"		>> $(DEB_BUILDDIR)/configparms
	echo "KSH := /bin/bash"			>> $(DEB_BUILDDIR)/configparms
	echo "SHELL := /bin/bash"		>> $(DEB_BUILDDIR)/configparms
	echo "LIBGD = no"			>> $(DEB_BUILDDIR)/configparms
	echo "bindir = $(bindir)"		>> $(DEB_BUILDDIR)/configparms
	echo "datadir = $(datadir)"		>> $(DEB_BUILDDIR)/configparms
	echo "localedir = $(localedir)" 	>> $(DEB_BUILDDIR)/configparms
	echo "sysconfdir = $(sysconfdir)" 	>> $(DEB_BUILDDIR)/configparms
	echo "libexecdir = $(libexecdir)" 	>> $(DEB_BUILDDIR)/configparms
	echo "rootsbindir = $(rootsbindir)" 	>> $(DEB_BUILDDIR)/configparms
	echo "includedir = $(call xx,includedir)" >> $(DEB_BUILDDIR)/configparms
	echo "docdir = $(docdir)"		>> $(DEB_BUILDDIR)/configparms
	echo "mandir = $(mandir)"		>> $(DEB_BUILDDIR)/configparms
	echo "sbindir = $(sbindir)"		>> $(DEB_BUILDDIR)/configparms
	libdir="$(call xx,libdir)" ; if test -n "$$libdir" ; then \
		echo "libdir = $$libdir" >> $(DEB_BUILDDIR)/configparms ; \
	fi
	slibdir="$(call xx,slibdir)" ; if test -n "$$slibdir" ; then \
		echo "slibdir = $$slibdir" >> $(DEB_BUILDDIR)/configparms ; \
	fi
	rtlddir="$(call xx,rtlddir)" ; if test -n "$$rtlddir" ; then \
		echo "rtlddir = $$rtlddir" >> $(DEB_BUILDDIR)/configparms ; \
	fi

	# Prevent autoconf from running unexpectedly by setting it to false.
	# Also explicitly pass CC down - this is needed to get -m64 on
	# Sparc, et cetera.

	configure_build=$(call xx,configure_build); \
	if [ $(call xx,configure_target) = $$configure_build ]; then \
	  echo "Checking that we're running at least kernel version: $(call xx,MIN_KERNEL_SUPPORTED)"; \
	  if ! $(call kernel_check,$(call xx,MIN_KERNEL_SUPPORTED)); then \
	    configure_build=`echo $$configure_build | sed 's/^\([^-]*\)-\([^-]*\)$$/\1-dummy-\2/'`; \
	    echo "No.  Forcing cross-compile by setting build to $$configure_build."; \
	  fi; \
	fi; \
	$(call logme, -a $(log_build), echo -n "Build started: " ; date --rfc-2822 ; echo "---------------") ; \
	$(call logme, -a $(log_build), \
		cd $(DEB_BUILDDIR) && \
		CC="$(call xx,CC)" \
		CXX="$(call xx,CXX)" \
		AUTOCONF=false \
		MAKEINFO=: \
		$(CURDIR)/configure \
		--host=$(call xx,configure_target) \
		--build=$$configure_build --prefix=/usr --without-cvs \
		--enable-add-ons=$(standard-add-ons)"$(call xx,add-ons)" \
		--enable-profile \
		--without-selinux \
		--enable-stackguard-randomization \
		$(call xx,with_headers) $(call xx,extra_config_options))
	touch $@

$(patsubst %,build_%,$(GLIBC_PASSES)) :: build_% : $(stamp)build_%
$(stamp)build_%: $(stamp)configure_%
	@echo Building $(curpass)
	$(call logme, -a $(log_build), $(MAKE) -C $(DEB_BUILDDIR) $(NJOBS))
	$(call logme, -a $(log_build), echo "---------------" ; echo -n "Build ended: " ; date --rfc-2822)
	if [ $(curpass) = libc ]; then \
	  $(MAKE) -C $(DEB_BUILDDIR) $(NJOBS) \
	    objdir=$(DEB_BUILDDIR) install_root=$(CURDIR)/build-tree/locales-all \
	    localedata/install-locales; \
	  tar --use-compress-program /usr/bin/lzma --owner root --group root -cf $(CURDIR)/build-tree/locales-all/supported.tar.lzma -C $(CURDIR)/build-tree/locales-all/usr/lib/locale .; \
	fi
	touch $@

$(patsubst %,check_%,$(GLIBC_PASSES)) :: check_% : $(stamp)check_%
$(stamp)check_%: $(stamp)build_%
	@set -e ; \
	if [ -n "$(findstring nocheck,$(DEB_BUILD_OPTIONS))" ]; then \
	  echo "Tests have been disabled via DEB_BUILD_OPTIONS." | tee $(log_results) ; \
	elif [ $(call xx,configure_build) != $(call xx,configure_target) ] && \
	     ! $(DEB_BUILDDIR)/elf/ld.so $(DEB_BUILDDIR)/libc.so >/dev/null 2>&1 ; then \
	  echo "Flavour cross-compiled, tests have been skipped." | tee $(log_results) ; \
	elif ! $(call kernel_check,$(call xx,MIN_KERNEL_SUPPORTED)); then \
	  echo "Kernel too old, tests have been skipped." | tee $(log_results) ; \
	elif [ $(call xx,RUN_TESTSUITE) != "yes" ]; then \
	  echo "Testsuite disabled for $(curpass), skipping tests."; \
	  echo "Tests have been disabled." > $(log_results) ; \
	else \
	  echo Testing $(curpass); \
	  find $(DEB_BUILDDIR) -name '*.out' -exec rm {} ';' ; \
	  LANG="" TIMEOUTFACTOR="50" $(MAKE) -C $(DEB_BUILDDIR) $(NJOBS) -k check 2>&1 | tee $(log_test); \
	  chmod +x debian/testsuite-checking/convertlog.sh ; \
	  debian/testsuite-checking/convertlog.sh $(log_test) | tee $(log_results) ; \
	  if test -f $(log_expected) ; then \
	    echo "***************" ; \
	    chmod +x debian/testsuite-checking/compare.sh ; \
	    debian/testsuite-checking/compare.sh $(log_expected) $(log_results) ; \
	    echo "***************" ; \
	  else \
	    echo "*** WARNING ***" ; \
	    echo "Please generate expected testsuite results for this arch!" ; \
	    echo "*** WARNING ***" ; \
	  fi ; \
	fi
	touch $@

$(patsubst %,install_%,$(GLIBC_PASSES)) :: install_% : $(stamp)install_%
$(stamp)install_%: $(stamp)check_%
	@echo Installing $(curpass)
	rm -rf $(CURDIR)/debian/tmp-$(curpass)
	$(MAKE) -C $(DEB_BUILDDIR) \
	  install_root=$(CURDIR)/debian/tmp-$(curpass) install

	# Generate the list of SUPPORTED locales
	if [ $(curpass) = libc ]; then \
	  $(MAKE) -f debian/generate-supported.mk IN=localedata/SUPPORTED \
	    OUT=debian/tmp-$(curpass)/usr/share/i18n/SUPPORTED; \
	fi

	# Create the multidir directories, and the configuration file in /etc/ld.so.conf.d
	if [ $(curpass) = libc ]; then \
	  mkdir -p debian/tmp-$(curpass)/etc/ld.so.conf.d; \
	  machine=`sed '/^ *config-machine *=/!d;s/.*= *//g' $(DEB_BUILDDIR)/config.make`; \
	  os=`sed '/^ *config-os *=/!d;s/.*= *//g' $(DEB_BUILDDIR)/config.make`; \
	  triplet="$$machine-$$os"; \
	  mkdir -p debian/tmp-$(curpass)/lib/$$triplet debian/tmp-$(curpass)/usr/lib/$$triplet; \
	  conffile="debian/tmp-$(curpass)/etc/ld.so.conf.d/$$triplet.conf"; \
	  echo "# Multiarch support" > $$conffile; \
	  echo /lib/$$triplet >> $$conffile; \
	  echo /usr/lib/$$triplet >> $$conffile; \
	fi
	
	# Create a default configuration file that adds /usr/local/lib to the search path
	if [ $(curpass) = libc ]; then \
	  mkdir -p debian/tmp-$(curpass)/etc/ld.so.conf.d; \
	  echo "# libc default configuration" > debian/tmp-$(curpass)/etc/ld.so.conf.d/libc.conf ; \
	  echo /usr/local/lib >> debian/tmp-$(curpass)/etc/ld.so.conf.d/libc.conf ; \
 	fi

	$(call xx,extra_install)
	touch $@

$(stamp)doc: $(stamp)patch
	make -C $(CURDIR)/linuxthreads/man
	touch $@

$(stamp)source: $(stamp)patch
	tar -c --bzip2 -C .. \
		-f $(build-tree)/glibc-$(GLIBC_VERSION).tar.bz2 \
		$(GLIBC_SOURCES)
	touch $@

.NOTPARALLEL: $(patsubst %,install_%,$(GLIBC_PASSES))
