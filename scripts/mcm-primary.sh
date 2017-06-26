SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"

cat <<'EOF' >config.mak
# TARGET = i486-linux-musl
TARGET = x86_64-linux-musl
# TARGET = arm-linux-musleabi
# TARGET = arm-linux-musleabihf
# TARGET = sh2eb-linux-muslfdpic

# OUTPUT = "${CURDIR}/output_init"

# BINUTILS_VER = 2.25.1
# GCC_VER = 5.2.0
# MUSL_VER = git-master
# GMP_VER =
# MPC_VER =
# MPFR_VER =
# ISL_VER =
# LINUX_VER =

# DL_CMD = wget -c -O
# DL_CMD = curl -C - -L -o

 
COMMON_CONFIG += CC="x86_64-linux-musl-gcc -static --static" CXX="x86_64-linux-musl-g++ -static --static"

# Recommended options for smaller build for deploying binaries:

COMMON_CONFIG += CFLAGS="-g0 -Os" CXXFLAGS="-g0 -Os" LDFLAGS="-s"

# Recommended options for faster/simpler build:

# COMMON_CONFIG += --disable-nls
# GCC_CONFIG += --enable-languages=c,c++
# GCC_CONFIG += --disable-libquadmath --disable-decimal-float
GCC_CONFIG += --disable-multilib

# You can keep the local build path out of your toolchain binaries and
# target libraries with the following, but then gdb needs to be told
# where to look for source files.

# COMMON_CONFIG += --with-debug-prefix-map=$(CURDIR)=
EOF

export PATH="$PWD/../mcm-init/output_init/bin:$PATH" 
make && make install

cp -Rp output_final/* "$INS"
