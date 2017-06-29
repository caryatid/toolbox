SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"
echo "PREFIX = $INS" >config.mak
echo "TARGET = ${TGT}" >>config.mak
cat <<'EOF' >>config.mak
CFLAGS=-static -O2 -I. -I${PREFIX}/${TARGET}/include -I./libcurses -I${PREFIX}/include -nostdinc
LDFLAGS=-static -L${PREFIX}/lib -L${PREFIX}/${TARGET}/lib -nodefaultlibs
CC=${TARGET}-gcc
HOSTCC=gcc
EOF

make all-static install-static

