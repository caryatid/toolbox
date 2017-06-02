#!/bin/sh

TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT

OGDIR=$(pwd)
SDIR="$OGDIR/dependency/repos"
IDIR="$OGDIR/dependency/install"
RDATA="$OGDIR/repodata.csv"
I="" # can become "-i" to git 

mkdir -p "$SDIR"; mkdir -p "$IDIR"
cat <<'EOF' >$TMP/column_fmt
BEGIN { FS="," }
NR == 1 { for (i=1; i<=NF;i++) { if ($i == "%s") fnum = i }}
NR > 1 { print  $fnum }
EOF

cat <<'EOF' >$TMP/value_fmt
BEGIN { FS="," }
NR == 1 { for (i=1; i<=NF;i++) { if ($i == "%s") fnum = i }}
$1 == "%s" { print $fnum }
EOF

_list_fields () {
    head -n1 "$RDATA" | sed 's/,/ /g'
}

_get_column () { # column
    local field="${1:-name}"
    printf "$(cat $TMP/column_fmt)" "$field" >$TMP/column
    awk -f $TMP/column "$RDATA"
}
    
_get_value () { # name (id), column
    test -z "$1" && return 1
    local id="$1"; local column="${2:-internal-repo}"
    printf "$(cat $TMP/value_fmt)" "$column" "$id" >$TMP/value
    awk -f $TMP/value "$RDATA"
}

clone_repo () { 
    test -z "$1" && return 1
    local id="$1"; cd "$SDIR"
    test -e "$id" && rm -Rf "$id"
    git clone $(_get_value "$id" internal-repo) "$id"
    cd "$id"
    git checkout $(_get_value "$id" internal-branch)
    git remote add -f og $(_get_value "$id" og-repo)
    cd "$OGDIR"
}

update_internal () {
    test -z "$1" && return 1
    local id="$1"; clone_repo "$id"; cd "$SDIR/$id"
    git rebase $I og/$(_get_value "$id" og-branch) \
        || { echo rebase fail; return 1 ;}
    cd "$OGDIR"
}

reset_internal () {
    test -z "$1" && return 1
    local id="$1"; clone_repo "$id"; cd "$SDIR/$id"
    git branch "$(date -I)-reset"; git fetch --all
    git reset --hard og/$(_get_value "$id" og-branch)
    git push --force
    cd "$OGDIR"
}

build_env () {
    clone_repo musl
    cd "$SDIR/musl"
    ./configure --prefix="$IDIR" --disable-shared
    make && make install   
}

build () {
    echo not implemented
}

install () {
    echo not implemented
}

remote () {
    echo not implemented
}

# _get_column "$2"
# _get_value "$1" "$2"
#clone_repo "$1"
# reset_internal "$1"
build_env
