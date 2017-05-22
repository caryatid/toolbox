I =  # set to '-i' for interactive
REPOS = musl lua lpeg netbsd-curses unibilium libtermkey abduco dvtm vis dwm st ii plans simple-plan
include repodata.mk

OGDIR = $(PWD)
IDIR = dependency/install
SDIR = dependency/repos
PFIX = $(OGDIR)/$(IDIR)

MDIRS = $(IDIR) $(SDIR)

build: $(REPOS)

$(MDIRS):
	mkdir -p $@

fake-libs: $(MDIRS)
	mkdir -p $(IDIR)/lib
	x86_64-alpine-linux-musl-gcc-ar rcs $(IDIR)/lib/libssp_nonshared.a
	x86_64-alpine-linux-musl-gcc-ar rcs $(IDIR)/lib/libssp.a

$(REPOS): fake-libs
	@cd $(SDIR) && (test -d $@ || git clone $(${@}_i_repo)) && cd $@ && \
	git checkout $(${@}_i_branch) && git pull && (git remote show og || \
		git remote add -f og $(${@}_repo)) && git rebase $(I) og/$(${@}_branch) && \
	echo '-- ABOUT TO MAKE $(@) --' && \
	((test -f $(${@}_i_makefile) && make -f $(${@}_i_makefile) PREFIX=$(PFIX) && \
	    make -f $(${@}_i_makefile) PREFIX=$(PFIX) install) || \
		(echo busted at $@; exit 1)) && \
	echo '-- MADE $(@) --'

tarball: build
	cd $(IDIR) && tar -c . | gzip >$(OGDIR)/toolbox.tar.gz

