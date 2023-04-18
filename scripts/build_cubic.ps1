
$CUBICSDR_SOURCES="$CS_SOURCES/CubicSDR"
if (-not ($CUBICSDR_SOURCES | Test-Path)) {
    git clone https://github.com/cjcliffe/CubicSDR $CUBICSDR_SOURCES
}

$CUBICSDR_TARGET="$CS_TARGET/CubicSDR"
$CUBICSDR_INSTALL="$CS_INSTALL/CubicSDR"
New-Item -ItemType Directory -Path $CUBICSDR_TARGET -Force | Out-Null


Write-Host "$SOAPY_SDR_INSTALL"
cmake -B $CUBICSDR_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $CUBICSDR_SOURCES `
    -DwxWidgets_ROOT_DIR:String="$WXWIDGETS_ROOT_DIR" `
    -DCMAKE_INSTALL_PREFIX:PATH="$CUBICSDR_INSTALL" `
    -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL" `
    -DBUNDLE_MSVC_REDIST:PATH="$BUNDLE_MSVC_REDIST" `
    -DHAMLIB_LIBRARY:PATH="$HAMLIB_LIBRARY" `
    -DHAMLIB_INCLUDE_DIR="$HAMLIB_INCLUDE_DIR" `
    -DBUILD_INSTALLER=ON -DBUNDLE_SOAPY_MODS=ON -DUSE_HAMLIB=ON
cmake --build $CUBICSDR_TARGET --config $CS_BUILD_TYPE --target install


Set-Location $CUBICSDR_TARGET
cpack CubicSDR
Set-Location $CS_ROOT