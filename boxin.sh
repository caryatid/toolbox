#!/bin/sh

TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT

# toolchain build order
#   binutils
#   gcc-temp
#   musl
#   gcc

PRE_D="$PWD"
SRC_D="$PRE_D/src"
INS_D="$PRE_D/ins"
BLD_D="$PRE_D/bld"
PCH_D="$PRE_D/pch"
RDATA="$PRE_D/repodata.csv"
mkdir -p "$SRC_D" "$INS_D" "$BLD_D" "$PCH_D"

cat <<'EOF' >$TMP/column
BEGIN { FS=","; COL=ARGV[2]; ARGV[2]=""}
NR == 1 { for (i=1; i<=NF;i++) { if ($i == COL) fnum = i }}
NR > 1 { print  $fnum }
EOF

cat <<'EOF' >$TMP/value
BEGIN { FS=","; COL=ARGV[3]; ROW=ARGV[2]; ARGV[3]=""; ARGV[2]="" }
NR == 1 { for (i=1; i<=NF;i++) { if ($i == COL) fnum = i }}
$1 == ROW { print $fnum }
EOF

_list_fields () {
    head -n1 "$RDATA" | sed 's/,/ /g'
}

_get_column () { # column
    local field="${1:-name}"
    awk -f $TMP/column "$RDATA" "$field"
}
    
_get_value () {
    test -z "$1" && return 1
    local id="$1"; local column="${2:-internal-repo}"
    awk -f $TMP/value "$RDATA" "$id" "$column"
}

clone_repo () { 
    test -z "$1" && return 1
    local id="$1"; cd "$SRC_D"
    test -e "$id" && rm -Rf "$id"
    git clone $(_get_value "$id" repo) "$id"
    cd "$id"
    git checkout $(_get_value "$id" branch)
}

build_env () {
    clone_repo musl
    cd "$SDIR/musl"
    ./configure --prefix="$IDIR" --disable-shared
    make && make install   
    cd "$OGDIR"
    clone_repo gcc
    cd "$SDIR/gcc"
    ./configure --prefix="$IDIR" --disable-shared --disable-multilib
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
_list_fields
_get_column "$@"
_get_value st repo
clone_repo binutils
