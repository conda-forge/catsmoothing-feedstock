set "PYO3_PYTHON=%PYTHON%"
set "LIBCLANG_PATH"=%LIBRARY_BIN%

maturin build -v --jobs 1 --bindings pyo3 --release --manylinux off --interpreter=%PYTHON%
if errorlevel 1 exit 1

FOR /F "delims=" %%i IN ('dir /s /b target\wheels\*.whl') DO set wheel=%%i
%PYTHON% -m pip install --ignore-installed --no-deps %wheel% -vv
if errorlevel 1 exit 1

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
