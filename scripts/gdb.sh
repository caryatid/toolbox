SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
export CC=${TGT}-gcc
export CXX=${TGT}-g++
#_d="$PWD"
#cd "$SRC"
#./configure --enable-static  --prefix="$INS" --with-sysroot=${INS}
#cd "$_d"
# export LIBRARY_PATH="${INS}/lib/gcc/${TGT}/6.3.0:${LIBRARY_PATH}"
#export LDFLAGS="-L${INS}/lib -L${INS}/${TGT}/lib -static -nodefaultlibs"

# export GCC_EXEC_PREFIX=${INS}/libexec/gcc/
# export CFLAGS="-I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include"
# export CXXFLAGS="-I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include"
export LDFLAGS="-static"
$SRC/gdb/configure --enable-static  --prefix="$INS" --with-sysroot=${INS} --host=$TGT --target=${TGT} --build=${TGT}
make
