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
$(stamp)mkbuilddir_%: $(stamp)patch-stamp $(KERNEL_HEADER_DIR)
	@echo Making builddir for $(curpass)
	test -d $(DEB_BUILDDIR) || mkdir $(DEB_BUILDDIR)
	touch $@

$(patsubst %,configure_%,$(GLIBC_PASSES)) :: configure_% : $(stamp)configure_%
$(stamp)configure_%: $(stamp)mkbuilddir_%

	@echo Configuring $(curpass)
	rm -f $(DEB_BUILDDIR)/configparms
	echo "CC = $(call xx,CC)"	>> $(DEB_BUILDDIR)/configparms
	echo "BUILD_CC = $(BUILD_CC)"	>> $(DEB_BUILDDIR)/configparms
	echo "CFLAGS = $(HOST_CFLAGS)"	>> $(DEB_BUILDDIR)/configparms
	echo "BUILD_CFLAGS = $(BUILD_CFLAGS)" >> $(DEB_BUILDDIR)/configparms
	echo "BASH := /bin/bash"	>> $(DEB_BUILDDIR)/configparms
	echo "KSH := /bin/bash"		>> $(DEB_BUILDDIR)/configparms
	echo "mandir = $(mandir)"	>> $(DEB_BUILDDIR)/configparms
	echo "infodir = $(infodir)"	>> $(DEB_BUILDDIR)/configparms
	echo "libexecdir = $(libexecdir)" >> $(DEB_BUILDDIR)/configparms
	echo "LIBGD = no"		>> $(DEB_BUILDDIR)/configparms
	echo "sysconfdir = /etc"	>> $(DEB_BUILDDIR)/configparms
	echo "rootsbindir = /sbin"	>> $(DEB_BUILDDIR)/configparms
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
		AUTOCONF=false \
		$(CURDIR)/$(DEB_SRCDIR)/configure \
		--host=$(call xx,configure_target) \
		--build=$$configure_build --prefix=/usr --without-cvs \
		--enable-add-ons=$(standard-add-ons)"$(call xx,add-ons)" \
		--without-selinux \
		$(call xx,with_headers) $(call xx,extra_config_options))
	touch $@

$(patsubst %,build_%,$(GLIBC_PASSES)) :: build_% : $(stamp)build_%
$(stamp)build_%: $(stamp)configure_%
	@echo Building $(curpass)
	$(call logme, -a $(log_build), $(MAKE) -C $(DEB_BUILDDIR) -j $(NJOBS))
	$(call logme, -a $(log_build), echo "---------------" ; echo -n "Build ended: " ; date --rfc-2822)
	touch $@

$(patsubst %,check_%,$(GLIBC_PASSES)) :: check_% : $(stamp)check_%
$(stamp)check_%: $(stamp)build_%
	if [ -n "$(findstring nocheck,$(DEB_BUILD_OPTIONS))" ]; then \
	  echo "DEB_BUILD_OPTIONS contains nocheck, skipping tests."; \
	elif [ $(call xx,configure_build) != $(call xx,configure_target) ] && \
	     ! $(DEB_BUILDDIR)/libc.so >/dev/null 2>&1 ; then \
	  echo "Cross compiling, skipping tests."; \
	elif ! $(call kernel_check,$(call xx,MIN_KERNEL_SUPPORTED)); then \
	  echo "Kernel too old, skipping tests."; \
	elif [ $(call xx,RUN_TESTSUITE) != "yes" ]; then \
	  echo "Testsuite disabled for $(curpass), skipping tests."; \
	else \
	  echo Testing $(curpass); \
	  echo -n "Testsuite started: " | tee -a $(log_test); \
	  date --rfc-2822 | tee -a $(log_test); \
	  echo "--------------" | tee -a $(log_test); \
	  $(MAKE) -C $(DEB_BUILDDIR) -j $(NJOBS) -k check 2>&1 | tee -a $(log_test); \
	  echo "--------------" | tee -a $(log_test); \
	  echo -n "Testsuite ended: " | tee -a $(log_test); \
	  date --rfc-2822 | tee -a $(log_test); \
	fi
	touch $@

$(patsubst %,install_%,$(GLIBC_PASSES)) :: install_% : $(stamp)install_%
$(stamp)install_%: $(stamp)check_%
	@echo Installing $(curpass)
	rm -rf $(CURDIR)/debian/tmp-$(curpass)
	$(MAKE) -C $(DEB_BUILDDIR) -j $(NJOBS) \
	  install_root=$(CURDIR)/debian/tmp-$(curpass) install

	if [ $(curpass) = libc ]; then \
	  $(MAKE) -f debian/generate-supported.mk IN=$(DEB_SRCDIR)/localedata/SUPPORTED \
	    OUT=debian/tmp-$(curpass)/usr/share/i18n/SUPPORTED; \
	  $(MAKE) -C $(DEB_BUILDDIR) -j $(NJOBS) \
	    objdir=$(DEB_BUILDDIR) install_root=$(CURDIR)/debian/tmp-$(curpass) \
	    localedata/install-locales; \
	  rm -rf $(CURDIR)/debian/locales-all/usr/lib; \
	  install -d $(CURDIR)/debian/locales-all/usr/lib; \
	  mv $(CURDIR)/debian/tmp-libc/usr/lib/locale $(CURDIR)/debian/locales-all/usr/lib/locales-all; \
	  (cd $(DEB_SRCDIR)/manual && texi2html -split_chapter libc.texinfo); \
	fi

	# Remove ld.so from optimized libraries
	if [ $(curpass) != libc ] && [ $(call xx,configure_build) = $(call xx,configure_target) ]; then \
		rm -f debian/tmp-$(curpass)/$(call xx,slibdir)/ld*.so* ; \
	fi
	
	# /usr/include/nptl and /usr/lib/nptl.  It assumes tmp-libc is already installed.
	if [ $(curpass) = nptl ]; then \
	  for file in `find debian/tmp-$(curpass)/usr/include -type f | sed 's/^debian\/tmp-nptl\///'`; do \
	    if ! [ -f debian/tmp-$(curpass)/$$file ] || \
	       ! cmp -s debian/tmp-$(curpass)/$$file debian/tmp-libc/$$file; then \
	      target=`echo $$file | sed 's/^usr\/include\///'`; \
	      install -d `dirname debian/tmp-libc/usr/include/nptl/$$target`; \
	      install -m 644 debian/tmp-$(curpass)/usr/include/$$target \
			     debian/tmp-libc/usr/include/nptl/$$target; \
	    fi; \
	  done; \
	  install -d debian/tmp-libc/usr/lib/nptl; \
	  for file in libc.a libc_nonshared.a libpthread.a libpthread_nonshared.a librt.a ; do \
	    install -m 644 debian/tmp-$(curpass)/usr/lib/$$file \
			   debian/tmp-libc/usr/lib/nptl/$$file; \
	  done; \
	  for file in libc.so libpthread.so; do \
	    sed 's/\/usr\/lib\//\/usr\/lib\/nptl\//g' < debian/tmp-$(curpass)/usr/lib/$$file \
	      > debian/tmp-libc/usr/lib/nptl/$$file; \
	  done; \
	  ln -sf /lib/tls/librt.so.1 debian/tmp-libc/usr/lib/nptl/; \
	fi

	# Create the multidir directories, and the symlinks in /lib/ldconfig
	if [ $(curpass) = libc ]; then \
	  mkdir -p debian/tmp-$(curpass)/lib/ldconfig; \
	  machine=`sed '/^ *config-machine *=/!d;s/.*= *//g' $(DEB_BUILDDIR)/config.make`; \
	  os=`sed '/^ *config-os *=/!d;s/.*= *//g' $(DEB_BUILDDIR)/config.make`; \
	  mkdir -p debian/tmp-$(curpass)/lib/$$machine-$$os debian/tmp-$(curpass)/usr/lib/$$machine-$$os; \
	  ln -s /lib/$$machine-$$os debian/tmp-$(curpass)/lib/ldconfig/$$machine-$$os-lib; \
	  ln -s /usr/lib/$$machine-$$os debian/tmp-$(curpass)/lib/ldconfig/$$machine-$$os-usr-lib; \
	fi
	 
	$(call xx,extra_install)
	touch $@
