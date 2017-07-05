SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
echo "$INS"; exit
export CC=${TGT}-gcc
export CXX=${TGT}-g++
export GCC_EXEC_PREFIX=${INS}/libexec/gcc/
$SRC/gdb/configure --enable-static  --prefix="$INS" --with-sysroot="$INS" LDFLAGS="-static -L${INS}/lib/gcc/${TGT}/6.3.0"
