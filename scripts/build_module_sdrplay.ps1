$SOAPY_SDRPLAY_SOURCES="$CS_SOURCES/SoapySDRPlay3"
if (-not ($SOAPY_SDRPLAY_SOURCES | Test-Path)) {
    git clone --depth 1 https://github.com/pothosware/SoapySDRPlay3 $SOAPY_SDRPLAY_SOURCES
}

$SOAPY_SDRPLAY_TARGET="$CS_TARGET/SoapySDRPlay3"
if (-not ($SOAPY_SDRPLAY_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_SDRPLAY_TARGET -ItemType Directory
    cmake -B $SOAPY_SDRPLAY_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $SOAPY_SDRPLAY_SOURCES `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL"
    cmake --build $SOAPY_SDRPLAY_TARGET --config $CS_BUILD_TYPE --target install
}
