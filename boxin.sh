#!/bin/sh

TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT

# toolchain build order
#   binutils
#   gcc-temp
#   musl
#   gcc

OG_D="$PWD"
PRE_D="$PWD"
CODE_D="$PWD"


SH_D="$CODE_D/scripts"
RDATA="$CODE_D/repodata.csv"

SRC_D="$PRE_D/src"
INS_D="$PRE_D/ins"
BLD_D="$PRE_D/bld"
PCH_D="$PRE_D/pch"
CONFFLAGS="--prefix=$INS_D --disable-shared"
TARGET=x86_64-alpine-linux-musl
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


_patch () {
    echo "patch not implemented, arg: $1"
}

_make () {
    local id="$1"
    local script="$SH_D/${id}.sh"
    if test -f "$script"
    then
        echo sh "$script" "$SRC_D/$id" $TARGET $CONFFLAGS
        sh "$script" "$SRC_D/$id" $TARGET $CONFFLAGS
    else
        local conf="$SRC_D/$id/configure"
        test -f "$conf" && "$conf" --target=$TARGET $CONFFLAGS
        make && make install
    fi
} 

_clean () {
    rm -rf "$SRC_D" "$INS_D" "$BLD_D" "$PCH_D"
}

fetch_repo () { 
    local id="$1"; cd "$SRC_D"
    local scm=$(_get_value "$id" scm)
    rm -rf "$id"
    case $scm in
    hg)
        $scm clone $(_get_value "$id" repo) "$id"
        cd "$id"
        $scm update $(_get_value "$id" branch)
        ;;
    git)
        $scm clone $(_get_value "$id" repo) "$id"
        cd "$id"
        $scm checkout $(_get_value "$id" branch)
        ;;
    tar-gz)
        mkdir -p "$id"
        curl $(_get_value "$id" repo) | tar --strip-components=1 -C "$id" -xz
        cd "$id"
    esac
}

build_repo () {
    local id="$1"
    local bld="$BLD_D/$id"; mkdir -p "$bld"
    fetch_repo "$id"
    _patch "$id"
    cd "$bld"
    _make "$id"
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
fetch_repo mpfr
# _list_fields
# _get_column "$@"
# _get_value st repo
# build_repo binutils
#build_repo gmp
