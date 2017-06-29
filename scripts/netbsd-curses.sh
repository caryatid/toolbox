SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"


export CC=${TGT}-gcc
export CFLAGS="-O2 -I. -I$INS/$TGT/include -I./libcurses -nostdinc"
make PREFIX="$INS" all-static install-static

