SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift
CC="${TGT}-gcc"

set -e 
"$SRC/configure"                                   \
    --target=$TGT                                  \
    --with-sysroot="$INS"                          \
    --enable-default-pie                           \
    --with-native-system-header-dir=/include       \
    --disable-multilib                             \
    --disable-libstdcxx                            \
    --enable-languages=c                           \
    --disable-nls                                  \
    --disable-libmudflap                           \
    "$@"

make && make install
