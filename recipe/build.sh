#!/bin/bash -euo

set -ex

unset PYO3_CROSS_LIB_DIR
unset PYO3_CROSS_PYTHON_VERSION
unset PYO3_CROSS_PYTHON_IMPLEMENTATION
export LIBCLANG_PATH=$BUILD_PREFIX/lib

if [[ "${PY_VER}" == "3.14" ]]; then
  export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1
fi
maturin build --features python -vv -j 1 --release --strip --manylinux off --interpreter=${PYTHON}
${PYTHON} -m pip install $SRC_DIR/target/wheels/*.whl --no-index --no-deps -vv

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
