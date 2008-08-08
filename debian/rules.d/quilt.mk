# Implements the patch and unpatch targets, called when building packages.

# -*- Makefile -*-, you silly Emacs!
# vim: set ft=make:

DEBQUILTRC = debian/quiltrc
QUILTOPT   = --quiltrc $(DEBQUILTRC)
QUILT      = quilt $(QUILTOPT)

patch: $(stamp)patch
$(stamp)patch:
	@if test -r debian/patches/series.$(DEB_HOST_ARCH); then \
	  pc=".pc.$(DEB_HOST_ARCH)"; \
	  mkdir -p "$$pc"; \
	  ln -sf ../debian/patches/series.$(DEB_HOST_ARCH) $$pc/series; \
	  if QUILT_PC="$$pc" $(QUILT) next >/dev/null 2>&1; then \
	    echo "Applying architecture specific patches... "; \
	    QUILT_PC="$$pc" $(QUILT) upgrade || true; \
	    QUILT_PC="$$pc" $(QUILT) push -a -v ; \
	  fi ; \
	fi ; \
	if $(QUILT) next >/dev/null 2>&1; then \
	  echo "Applying patches... "; \
	  $(QUILT) push -a -v ; \
	fi
	touch $@

unpatch:
	@if $(QUILT) previous >/dev/null 2>&1; then \
	  echo "Unapplying patches..." ; \
	  $(QUILT) pop -a -v ; \
	fi ; \
	rm -rf .pc ; \
	if test -r debian/patches/series.$(DEB_HOST_ARCH); then \
	  pc=".pc.$(DEB_HOST_ARCH)"; \
	  if QUILT_PC="$$pc" $(QUILT) previous >/dev/null 2>&1; then \
	    echo "Unapplying architecture specific patches..."; \
	    QUILT_PC="$$pc" $(QUILT) upgrade || true; \
	    QUILT_PC="$$pc" $(QUILT) pop -a -v ; \
	  fi ; \
	  rm -rf $$pc ; \
	fi
	rm -f $(stamp)patch

refresh: unpatch
	@while quilt next ; do \
	  $(QUILT) push ; \
	  $(QUILT) refresh -pab --no-timestamps --no-index --diffstat ; \
	done ; \
	$(QUILT) pop -a

