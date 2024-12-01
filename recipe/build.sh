#!/bin/bash -euo

set -ex
set -o xtrace -o nounset -o pipefail -o errexit

# https://github.com/rust-lang/cargo/issues/10583#issuecomment-1129997984
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# Bundle all downstream library licenses
pushd src
cargo-bundle-licenses \
    --format yaml \
    --output ${SRC_DIR}/THIRDPARTY.yml
popd

maturin build --features python -v --jobs 1 --release  --strip --interpreter=$PYTHON
$PYTHON -m pip install . -vv --no-deps --no-build-isolation || exit 1
