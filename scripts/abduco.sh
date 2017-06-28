SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"

echo 'PREFIX ?=' "$INS" >config.mk
echo 'TARGET ?=' "$TGT" >>config.mk
cat <<'EOF' >>config.mk
VERSION = 0.6

MANPREFIX = ${PREFIX}/share/man

INCS = -I. -I${PREFIX}/include -I${PREFIX}/${TARGET}/include
LIBS = -lc -lutil -lgcc

CPPFLAGS = -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700
CFLAGS +=  -std=c99 -pedantic -Wall ${INCS} -DVERSION=\"${VERSION}\" -DNDEBUG ${CPPFLAGS}  -nostdinc 
LDFLAGS += ${LIBS} -L${PREFIX}/lib -L${PREFIX}/${TARGET}/lib -nostdlib -static

DEBUG_CFLAGS = ${CFLAGS} -UNDEBUG -O0 -g -ggdb

CC = ${TARGET}-gcc 
STRIP ?= strip
EOF

make | tee foo.log && make install


