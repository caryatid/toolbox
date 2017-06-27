#!/bin/sh

TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT

OG_D="$PWD"
PRE_D="$PWD"
CODE_D="$PWD"
FRESH=no

SH_D="$CODE_D/scripts"
RDATA="$CODE_D/repodata.csv"

SRC_D="$PRE_D/src"
INS_D="$PRE_D/ins"
BLD_D="$PRE_D/bld"
PCH_D="$PRE_D/pch"
CONFFLAGS="--prefix=$INS_D --disable-shared --enable-static"
TARGET=x86_64-alpine-linux-musl

export PATH="$INS_D/bin:$PATH"
export LDFLAGS="-static"
export CFLAGS="-Bstatic"

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

_loop_repos () {
    local func=$1
    local file="$2"
    for r in $(cat "$file")
    do
        $func $r
    done
}

_patch () {
    local id="$1"
    local _d="$PWD"
    cd "$SRC_D/$id"
    for p in $PCH_D/*${id}.patch
    do
        git apply "$p"
    done    
    cd "$_d"
}

_make () {
    local id="$1"
    local script="$SH_D/${id}.sh"
    if test -f "$script"
    then
        sh "$script" "$SRC_D/$id" "$INS_D" $TARGET $CONFFLAGS
    else
        local conf="$SRC_D/$id/configure"
        test -f "$conf" && "$conf" --target=$TARGET $CONFFLAGS
        make && make install
    fi
} 

clean () {
    rm -rf "$SRC_D" "$INS_D" "$BLD_D"
}

fetch_repo () { 
    local id="$1"; cd "$SRC_D"
    local scm=$(_get_value "$id" scm)
    test -d "$id" && test $FRESH == "yes" && rm -rf "$id" 
    test -d "$id" && return
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
        ;;
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

shell_repo () {
    local id="$1"
    local src="$SRC_D/$id"
    test -d "$src" || return
    echo '--| entering' "$id" 'directory in a subshell |--'
    cd "$src"; PS1_SUB="[$id]" $SHELL
}

install () {
    echo not implemented
}

remote () {
    echo not implemented
}

while test -n "$1" && test "$1" != "${1#-*}"
do
    # TODO split up multiple flags, one dash
    case "$1" in
    --) echo end of args; shift ;;
    -f|--fresh) FRESH=yes; shift ;;
    *) break; ;;
    esac
done

cmd="$1"
test -z "$cmd" && cmd=help || shift

### repo sets
case "$1" in
""|all)
    _get_column >$TMP/rset
    ;;
toolchain)
    echo binutils,gmp,mpfr,mpc,gcc1,musl,gcc2 \
        | tr ',' '\n' >$TMP/rset
    ;;
*)
    echo "$1" | tr ',' '\n' >$TMP/rset
    ;;
esac
_get_column name | grep -f $TMP/rset >$TMP/repos

case "$cmd" in 
fetch)
    _loop_repos fetch_repo $TMP/repos
    ;;
build)
    _loop_repos build_repo $TMP/repos
    ;;
shell)
    _loop_repos shell_repo $TMP/repos
    ;;
list)
    echo build order
    echo -----------
    _get_column
    ;;
clean)
    clean
    ;;
esac
