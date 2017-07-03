SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"
export LIBS="-lncursesw -lterminfo -ltermkey -lunibilium -llpeg -llua -lutil -lc"
export LDFLAGS="-L${INS}/lib -L${INS}/${TGT}/lib -static -nodefaultlibs"
export INCS="-I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include"
export CFLAGS="-std=c99 ${INCS}"
export CC=${TGT}-gcc

./configure --prefix="$INS" --enable-curses
make && make install
