SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"
make PREFIX="$INS" TARGET="$TGT"
cp *.h "${INS}/include"
cp *.a "${INS}/lib"
