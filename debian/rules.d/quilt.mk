# Implements the patch and unpatch targets, called when building packages.

# -*- Makefile -*-, you silly Emacs!
# vim: set ft=make:

DEBQUILTRC = debian/quiltrc
QUILTOPT   = --quiltrc $(DEBQUILTRC)
QUILT     = quilt $(QUILTOPT)

patch: $(stamp)patch-stamp
$(stamp)patch-stamp: $(stamp)unpack quilt
	@cd $(DEB_SRCDIR); \
	if $(QUILT) next >/dev/null 2>&1; then \
	  echo -n "Applying patches..."; \
	  if $(QUILT) push -a -v > ${stamp}patch-log 2>&1; then \
	    echo "successful."; \
	    mv ${stamp}patch-log $@; \
	  else \
	    echo "failed! (check ${stamp}patch-log for details)"; \
	    exit 1; \
	  fi; \
	else \
	  echo "No patches to apply"; \
	fi

#  By default, quilt looks for patches in the patches/ directory.
#  Debian maintainers often set QUILT_PATCHES="debian/patches"
#  in their $HOME/.quiltrc
#  These symbolic links are useful when running quilt interactively
#  from $(DEB_SRCDIR), or from the patch/unpatch targets.
#  Patches specific to a certain architecture are applied first.
quilt: $(stamp)unpack
	@if test -n "$(DEB_SRCDIR)" && test -d $(DEB_SRCDIR); then \
	  test -L $(DEB_SRCDIR)/debian || ln -s . $(DEB_SRCDIR)/debian; \
	  test -L $(DEB_SRCDIR)/patches || ln -s $(shell pwd)/debian/patches $(DEB_SRCDIR)/patches; \
	  if test -r debian/patches/series.$(DEB_HOST_ARCH); then \
	    pc=".pc.$(DEB_HOST_ARCH)"; \
	    test -d "$(DEB_SRCDIR)/$$pc" || mkdir "$(DEB_SRCDIR)/$$pc"; \
	    cp debian/patches/series.$(DEB_HOST_ARCH) $(DEB_SRCDIR)/$$pc/series; \
	    cd $(DEB_SRCDIR); \
	    QUILT_PC="$$pc" quilt upgrade || true; \
	    QUILT_PC="$$pc" quilt push -a || true; \
	  fi; \
	fi

unpatch: quilt
	@echo -n "Unapplying patches..."
	@cd $(DEB_SRCDIR); \
	if $(QUILT) top >/dev/null 2>&1; then \
	  if $(QUILT) pop -a -v > $(stamp)unpatch-log 2>&1; then \
	    echo "successful."; \
	  else \
	    echo "failed! (check $(stamp)unpatch-log for details)"; \
	    exit 1; \
	  fi; \
	else \
	  echo "nothing to do."; \
	fi
	-rm -f $(stamp)patch-stamp $(stamp)patch-log $(stamp)unpatch-log

