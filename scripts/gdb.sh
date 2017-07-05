SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
export CC=${TGT}-gcc
export CXX=${TGT}-g++
export LDFLAGS=-static
# TODO fix version in prefix
export GCC_EXEC_PREFIX=${INS}/libexec/gcc/${TGT}/6.3.0/
# export GCC_EXEC_PREFIX=${INS}/libexec/gcc/
$SRC/gdb/configure --enable-static  --prefix="$INS" --with-sysroot="$INS"
