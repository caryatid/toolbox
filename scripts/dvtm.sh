SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"
echo 'PREFIX = '"$INS" >config.mk
echo 'TARGET = '"$TGT" >>config.mk
cat <<'EOF' >>config.mk
MANPREFIX = ${PREFIX}/share/man
# specify your systems terminfo directory
# leave empty to install into your home folder
# TERMINFO := ${PREFIX}/share/terminfo

INCS = -I. -nostdinc -I${PREFIX}/include -I${PREFIX}/${TARGET}/include
LIBS = -lcurses -lterminfo -nodefaultlibs -lc -lutil  
LDFLAGS = -L${PREFIX}/lib -L${PREFIX}/${TARGET}/lib -static ${LIBS}
CPPFLAGS = -D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700 \
    -D_XOPEN_SOURCE_EXTENDED -DVERSION='"'0.15'"'
CFLAGS += -std=c99 ${INCS} -DDEBUG=debug ${CPPFLAGS}

CC = ${TARGET}-gcc
EOF

make | tee foo.log && make install

