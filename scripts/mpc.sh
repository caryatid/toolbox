SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift
(cd "$SRC"; autoreconf -i)

set -e
"$SRC/configure" --enable-maintainer-mode \
    --target=$TGT                         \
    --with-gmp="$INS"                     \
    --with-mpfr="$INS"                    \
    "$@"

# make && make check && make install
make && make install
