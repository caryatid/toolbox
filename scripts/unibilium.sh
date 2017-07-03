SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

cd "$SRC"
set -e
CC=${TGT}-gcc
AR=${TGT}-ar

T_D='"/etc/terminfo:/lib/terminfo:/usr/share/terminfo:/usr/lib/terminfo:/usr/local/share/terminfo:/usr/local/lib/terminfo"'

$CC -Os -std=c99 -I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include \
    -L${INS}/lib -L${INS}/${TGT}/lib -nodefaultlibs \
    -static -o unibilium.o -c unibilium.c -lc
$CC -Os -std=c99 -I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include \
    -L${INS}/lib -L${INS}/${TGT}/lib -nodefaultlibs \
    -static  -o uninames.o uninames.c -c -lc
$CC -Os -std=c99 -DTERMINFO_DIRS="$T_D" -I. -nostdinc -I${INS}/include \
    -I${INS}/${TGT}/include -L${INS}/lib -L${INS}/${TGT}/lib -nodefaultlibs \
    -static -o uniutil.o uniutil.c -c -lc 
$AR -r libunibilium.a unibilium.o uninames.o uniutil.o

cp unibilium.h "${INS}/include"
cp libunibilium.a "${INS}/lib"




