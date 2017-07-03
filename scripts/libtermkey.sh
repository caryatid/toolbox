SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

cd "$SRC"
set -e
CC=${TGT}-gcc
AR=${TGT}-ar


sed -e 's/@@VERSION_MAJOR@@/0/g' \
    -e 's/@@VERSION_MINOR@@/20/g' <termkey.h.in >termkey.h

$CC -Os -std=c99 -I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include \
    -L${INS}/lib -L${INS}/${TGT}/lib -nodefaultlibs \
    -static -o termkey.o -c termkey.c -lc -lncursesw 
$CC -Os -std=c99 -I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include \
    -L${INS}/lib -L${INS}/${TGT}/lib -nodefaultlibs \
    -static  -o driver-csi.o driver-csi.c -c -lc -lncursesw
$CC -Os -std=c99 -I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include \
    -DHAVE_UNIBILIUM -L${INS}/lib -L${INS}/${TGT}/lib -nodefaultlibs \
    -static -o driver-ti.o driver-ti.c -c -lc -lunibilium -lterminfo -lncursesw 
$AR -r libtermkey.a termkey.o driver-csi.o driver-ti.o
cp termkey.h "${INS}/include"
cp libtermkey.a "${INS}/lib"




