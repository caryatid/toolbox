SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
export CC=${TGT}-gcc
export CXX=${TGT}-g++
export LIBRARY_PATH="${INS}/lib/gcc/${TGT}/6.3.0:${LIBRARY_PATH}"
export LDFLAGS="-L${INS}/lib -L${INS}/${TGT}/lib -static -nodefaultlibs -L${INS}/lib/gcc/${TGT}/6.3.0"
export INCS="-I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include"
export LIBS="-lc -lgcc"

export GCC_EXEC_PREFIX=${INS}/libexec/gcc/
$SRC/gdb/configure --enable-static  --prefix="$INS" \
    --host=$TGT --with-sysroot=$INS --target=$TGT
