
I =  # set to '-i' for interactive
REPOS = plans simple-plan abduco dvtm vis dwm st ii

plans_repo = git@github.com:caryatid/plans
plans_branch = master
plans_i_repo = git@github.com:caryatid/plans
plans_i_branch = master

simple-plan_repo = git@github.com:caryatid/simple-plan
simple-plan_branch = master
simple-plan_i_repo = git@github.com:caryatid/simple-plan
simple-plan_i_branch = master

abduco_repo = git@github.com:martanne/abduco
abduco_branch = master
abduco_i_repo = git@github.com:caryatid/abduco
abduco_i_branch = master

dvtm_repo = git@github.com:martanne/dvtm
dvtm_branch = master
dvtm_i_repo = git@github.com:caryatid/dvtm
dvtm_i_branch = master

vis_repo = git@github.com:martanne/vis
vis_branch = master
vis_i_repo = git@github.com:caryatid/vis
vis_i_branch = master

dwm_repo = git://git.suckless.org/dwm
dwm_branch = master
dwm_i_repo = git@github.com:caryatid/dwm
dwm_i_branch = master

st_repo = git://git.suckless.org/st
st_branch = master
st_i_repo = git@github.com:caryatid/st
st_i_branch = master

ii_repo = git://git.suckless.org/ii
ii_branch = master
ii_i_repo = git@github.com:caryatid/ii
ii_i_branch = master

IDIR = $(PWD)/dependency/install
SDIR = dependency/repos

MDIRS = $(IDIR) $(SDIR)

all: $(REPOS)

$(MDIRS):
	mkdir -p $@

$(REPOS): $(MDIRS)
	cd $(SDIR) && (test -d $@ || git clone $(${@}_i_repo)) && cd $@ && \
	git checkout $(${@}_i_branch) && (git remote show og || \
									  git remote add -f og $(${@}_repo)) && \
	git rebase $(I) og/$(${@}_branch) && ((test -f Makefile && make && \
    	     	         			      make PREFIX=$(IDIR) install) || \
				    						(echo busted at $@; exit 1))


