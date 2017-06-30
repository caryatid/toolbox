SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

export CC=${TGT}-gcc
CPPFLAGS="-DMKSH_BINSHPOSIX"
INCS="-I. -nostdinc -I${INS}/include -I${INS}/${TGT}/include"
CFLAGS="-std=c99 ${INCS} -DNDEBUG" 
LDFLAGS="-nodefaultlibs -L${INS}/lib -L${INS}/${TGT}/lib -lc"
LDSTATIC=-static

sh ../../src/mksh/Build.sh -L -r -c lto 2>&1 | tee log
sh ../../src/mksh/Build.sh -r -c lto 2>&1 | tee log
cp mksh lksh "$INS/bin"


