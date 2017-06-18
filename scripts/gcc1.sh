SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

  #  --with-gmp="$INS"                              \
  #  --with-mpfr="$INS"                             \
  #  --with-mpc="$INS"                              \
set -e 
"$SRC/configure"                                   \
    --target=$TGT                                  \
    --with-sysroot="$INS"                          \
    --enable-default-pie                           \
    --with-native-system-header-dir=/include       \
    --disable-multilib                             \
    --disable-libstdcxx                            \
    --enable-languages=c                           \
    --with-newlib                                  \
    --disable-libssp                               \
    --disable-nls                                  \
    --disable-libquadmath                          \
    --disable-threads                              \
    --disable-decimal-float                        \
    --disable-libmudflap                           \
    --disable-libgomp                              \
    --disable-libmpx                               \
    --disable-libatomic                            \
    "$@"

make && make install
