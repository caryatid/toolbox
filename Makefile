I =  # set to '-i' for interactive
REPOS = musl lua lpeg netbsd-curses unibilium libtermkey abduco dvtm vis ii plans simple-plan
include repodata.mk

OGDIR = $(PWD)
IDIR = dependency/install
SDIR = dependency/repos
PFIX = $(OGDIR)/$(IDIR)
LD_LIBRARY_PATH=$(PFIX)/lib
MAKEDEFS = PREFIX=$(PFIX) CC="$(PFIX)/bin/musl-gcc -static"

MDIRS = $(IDIR) $(SDIR)

build: $(REPOS) tarball

$(MDIRS):
	mkdir -p $@

fake-libs: $(MDIRS)
	mkdir -p $(IDIR)/lib
	ar rcs $(IDIR)/lib/libssp_nonshared.a
	ar rcs $(IDIR)/lib/libssp.a

$(REPOS): fake-libs
	@cd $(SDIR) && (test -d $@ || git clone $(${@}_i_repo)) && cd $@ && \
	git checkout $(${@}_i_branch) && git pull && (git remote show og || \
		git remote add -f og $(${@}_repo)) && git rebase $(I) og/$(${@}_branch) && \
	echo '-- ABOUT TO MAKE $(@) --' && \
	((test -f $(${@}_i_makefile) && make -f $(${@}_i_makefile) $(MAKEDEFS) && \
	    make -f $(${@}_i_makefile) $(MAKEDEFS) install) || \
		(echo busted at $@; exit 1)) && \
	echo '-- MADE $(@) --'

tarball:
	cd $(IDIR) && tar -c . | gzip >$(OGDIR)/toolbox.tar.gz

