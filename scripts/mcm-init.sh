SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

cd "$SRC"
make && make install

