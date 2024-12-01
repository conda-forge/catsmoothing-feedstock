@echo on
setlocal enabledelayedexpansion

REM Bundle all downstream library licenses
cargo-bundle-licenses ^
    --format yaml ^
    --output %SRC_DIR%\THIRDPARTY_LICENSES.yaml ^
    || goto :error

REM Build the wheel
set "RUSTFLAGS=-C codegen-units=4"
maturin build --features python -v --jobs 1 --release --strip --manylinux off --interpreter=%PYTHON%
if %ERRORLEVEL% neq 0 exit 1

REM Install the wheel
FOR /F "delims=" %%i IN ('dir /s /b target\wheels\*.whl') DO set wheel=%%i
%PYTHON% -m pip install --ignore-installed --no-deps %wheel% -vv
if %ERRORLEVEL% neq 0 exit 1
