I =  # set to '-i' for interactive

REPOS = musl netbsd-curses abduco dvtm vis dwm st ii plans simple-plan 

musl_repo = git://git.musl-libc.org/musl
musl_branch = master
musl_i_repo = git@github.com:caryatid/musl
musl_i_branch = master
musl_i_makefile = Makefile_

abduco_repo = git@github.com:martanne/abduco
abduco_branch = master
abduco_i_repo = git@github.com:caryatid/abduco
abduco_i_branch = master
abduco_i_makefile = Makefile

dvtm_repo = git@github.com:martanne/dvtm
dvtm_branch = master
dvtm_i_repo = git@github.com:caryatid/dvtm
dvtm_i_branch = master
dvtm_i_makefile = Makefile

netbsd-curses_repo = git@github.com:sabotage-linux/netbsd-curses
netbsd-curses_branch = master
netbsd-curses_i_repo = git@github.com:caryatid/netbsd-curses
netbsd-curses_i_branch = master
netbsd-curses_i_makefile = GNUmakefile

vis_repo = git@github.com:martanne/vis
vis_branch = master
vis_i_repo = git@github.com:caryatid/vis
vis_i_branch = master
vis_i_makefile = Makefile_

dwm_repo = git://git.suckless.org/dwm
dwm_branch = master
dwm_i_repo = git@github.com:caryatid/dwm
dwm_i_branch = master
dwm_i_makefile = Makefile

st_repo = git://git.suckless.org/st
st_branch = master
st_i_repo = git@github.com:caryatid/st
st_i_branch = master
st_i_makefile = Makefile

ii_repo = git://git.suckless.org/ii
ii_branch = master
ii_i_repo = git@github.com:caryatid/ii
ii_i_branch = master
ii_i_makefile = Makefile

plans_repo = git@github.com:caryatid/plans
plans_branch = master
plans_i_repo = git@github.com:caryatid/plans
plans_i_branch = master
plans_i_makefile = Makefile

simple-plan_repo = git@github.com:caryatid/simple-plan
simple-plan_branch = master
simple-plan_i_repo = git@github.com:caryatid/simple-plan
simple-plan_i_branch = master
simple-plan_i_makefile = Makefile

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
	((test -f $(${@}_i_makefile) && make -f $(${@}_i_makefile) PREFIX=$(PFIX) && \
	    make -f $(${@}_i_makefile) PREFIX=$(PFIX) install) || \
		(echo busted at $@; exit 1))

tarball: build
	cd $(IDIR) && tar -c . | gzip >$(OGDIR)/toolbox.tar.gz

