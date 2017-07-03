SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"
make PREFIX="$INS" TARGET="$TGT"
cp lua "${INS}/bin"
cp *.h "${INS}/include"
cp liblua.a "${INS}/lib"
