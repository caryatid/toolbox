SRC="$1"; shift
INS="$1"; shift
TGT="$1"; shift

set -e
cd "$SRC"
export PATH="$PWD/../musl-cross-make-init/output/bin:$PATH" 
make && make install

cp -Rp output_final/* "$INS"


