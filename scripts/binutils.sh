SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
LDFLAGS="--all-static $LDFLAGS"
"$SRC/configure"  --target=$TGT "$@"
# make && make check && make install
make && make install
