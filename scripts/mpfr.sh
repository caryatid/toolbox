SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
"$SRC/configure" --enable-maintainer-mode \
    --host=$TGT                           \
    --with-gmp="$INS"                     \
    "$@"

# make && make check && make install
make && make install
