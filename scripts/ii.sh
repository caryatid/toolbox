SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"
echo 'PREFIX = '"$INS" >config.mk
echo 'TARGET = '"$TGT" >>config.mk
cat <<'EOF' >>config.mk
VERSION = 1.7
BINDIR      = ${PREFIX}/bin
MANDIR      = ${PREFIX}/share/man
MAN1DIR     = ${MANDIR}/man1
DOCDIR      = ${PREFIX}/share/doc/ii
INCDIR      = ${PREFIX}/include
LIBDIR      = ${PREFIX}/lib


INCLUDES = -I. -nostdinc -I${PREFIX}/include -I${PREFIX}/${TARGET}/include
LIBS = -lncursesw -lterminfo -nodefaultlibs -lc -lutil  
LDFLAGS = -L${PREFIX}/lib -L${PREFIX}/${TARGET}/lib -static ${LIBS}
CFLAGS     = -Os ${INCLUDES} -DVERSION='"'${VERSION}'"' -std=c99 -D_DEFAULT_SOURCE
CC = ${TARGET}-gcc
EOF

make | tee foo.log && make install

