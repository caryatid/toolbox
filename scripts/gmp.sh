SRC="$1"; shift
TGT="$1"; shift
(cd "$SRC"; ./.bootstrap)

"$SRC/configure" --enable-maintainer-mode --host=$TGT "$@"
make && make check && make install
