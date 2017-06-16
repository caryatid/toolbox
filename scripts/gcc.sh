SRC="$1"
INS="$2"

"$SRC/configure" --prefix="$INS" --disable-shared \
    --with-sysroot="$INS"                          \
    --with-newlib                                  \
    --without-headers                              \
    --with-local-prefix="$INS"                     \
    --with-native-system-header-dir="$INS/include" \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libmpx                               \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c

make
