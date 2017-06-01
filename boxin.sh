#!/bin/sh

TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT

OGDIR=$(pwd)
SDIR=dependency/repos
IDIR=dependency/install
RDATA=./repodata.csv

mkdir -p "$SDIR"; mkdir -p "$IDIR"
cat <<'EOF' >$TMP/select_fmt
BEGIN { FS="," }
NR == 1 { for (i=1; i<=NF;i++) { if ($i == "%s") fnum = i }}
NR > 1 { printf("%%-23s: %%s\\n", $1, $fnum) }
EOF

_list_fields () {
    head -n1 "$RDATA" | sed 's/,/ /g'
}

_get_by_field () {
    local field="${1:-name}"
    printf "$(cat $TMP/select_fmt)" "$field" >$TMP/select
    awk -f $TMP/select "$RDATA"
}
    
get () {
    local repo=${1:-
    git clone $(_get_by_field "$repo")
}

update_local () {
    echo not implemented
}

reset_local () {
    echo not implemented
}

build_env () {
    echo not implemented
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

_get_by_field "$1"
