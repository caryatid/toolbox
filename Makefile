

REPOS = plans simple-plan abduco dvtm vis dwm st ii

plans_repo = git@github.com:caryatid/plans
plans_branch = master
simple-plan_repo = git@github.com:caryatid/simple-plan
simple-plan_branch = master
abduco_repo = git@github.com:martanne/abduco
abduco_branch = master
dvtm_repo = git@github.com:martanne/dvtm
dvtm_branch = master
vis_repo = git@github.com:martanne/vis
vis_branch = master
dwm_repo = git://git.suckless.org/dwm
dwm_branch = master
st_repo = git://git.suckless.org/st
st_branch = master
ii_repo = git://git.suckless.org/ii
ii_branch = master

IDIR = $(PWD)/dependency/install
SDIR = dependency/repos


MDIRS = $(IDIR) $(SDIR)

all: $(REPOS)

$(MDIRS):
	mkdir -p $@

$(REPOS): $(MDIRS)
	cd $(SDIR) && (test -d $@ || git clone $(${@}_repo)) && cd $@ && \
	git checkout $(${@}_branch) && ((test -f Makefile && make && \
									 make PREFIX=$(IDIR) install) || echo foo) 

