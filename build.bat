REM change this to the directory of where you built rustc for xtensa
set CUSTOM_RUSTC=E:\ext\rust-xtensa

set RUST_BACKTRACE=1
set XARGO_RUST_SRC=%CUSTOM_RUSTC%\library
set RUSTC=%CUSTOM_RUSTC%\build\x86_64-pc-windows-msvc\stage2\bin\rustc
set RUSTDOC=%CUSTOM_RUSTC%\build\x86_64-pc-windows-msvc\stage2\bin\rustdoc

set TARGET=%~dp0\target
set TARGET_ELF=%TARGET%\xtensa-esp8266-none-elf\release\examples
set TARGET_IMAGE=%TARGET%\xtensa-esp8266-none-image\release

set PORT=COM7
set ARTIFACT_NAME=serial

cd %~dp0

cargo xbuild --release --example serial

mkdir %TARGET_IMAGE%
copy /Y %TARGET_ELF%\%ARTIFACT_NAME% %TARGET_IMAGE%\%ARTIFACT_NAME%

esptool.py --chip esp8266 elf2image %TARGET_IMAGE%\%ARTIFACT_NAME%
esptool.py -p %PORT% -b 115200 write_flash ^
  0x00000 %TARGET_IMAGE%\%ARTIFACT_NAME%-0x00000.bin ^
  0x10000 %TARGET_IMAGE%\%ARTIFACT_NAME%-0x10000.bin
