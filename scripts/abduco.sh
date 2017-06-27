SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"

echo 'PREFIX ?=' "$INS" >config.mk
cat <<'EOF' >>config.mk
VERSION = 0.6

MANPREFIX = ${PREFIX}/share/man

INCS = -I. -I${PREFIX}/include
LIBS = -lc -lutil

CPPFLAGS = -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700
CFLAGS += -std=c99 -pedantic -Wall ${INCS} -DVERSION=\"${VERSION}\" -DNDEBUG ${CPPFLAGS} -nostdlib -nostdinc
LDFLAGS += ${LIBS} -L${PREFIX}/lib 

DEBUG_CFLAGS = ${CFLAGS} -UNDEBUG -O0 -g -ggdb

CC ?= cc
STRIP ?= strip
EOF

make | tee foo.log && make install


