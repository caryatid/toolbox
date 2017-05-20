I =  # set to '-i' for interactive
REPOS = musl netbsd-curses abduco dvtm vis dwm st ii plans simple-plan
include repodata.mk

OGDIR = $(PWD)
IDIR = dependency/install
SDIR = dependency/repos
PFIX = $(OGDIR)/$(IDIR)

MDIRS = $(IDIR) $(SDIR)

build: $(REPOS)

$(MDIRS):
	mkdir -p $@

$(REPOS): $(MDIRS)
	cd $(SDIR) && (test -d $@ || git clone $(${@}_i_repo)) && cd $@ && \
	git checkout $(${@}_i_branch) && git pull && (git remote show og || \
		git remote add -f og $(${@}_repo)) && git rebase $(I) og/$(${@}_branch) && \
	echo '-- ABOUT TO MAKE $(@) --' && \
	((test -f $(${@}_i_makefile) && make -f $(${@}_i_makefile) PREFIX=$(PFIX) && \
	    make -f $(${@}_i_makefile) PREFIX=$(PFIX) install) || \
		(echo busted at $@; exit 1)) && \
	echo '-- MADE $(@) --'

tarball: build
	cd $(IDIR) && tar -c . | gzip >$(OGDIR)/toolbox.tar.gz

