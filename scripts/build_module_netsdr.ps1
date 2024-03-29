$SOAPY_NETSDR_SOURCES="$CS_SOURCES/SoapyNetSDR"
if (-not ($SOAPY_NETSDR_SOURCES | Test-Path)) {
    git clone --depth 1 https://github.com/pothosware/SoapyNetSDR $SOAPY_NETSDR_SOURCES
}

$SOAPY_NETSDR_TARGET="$CS_TARGET/SoapyNetSDR"
$SOAPY_NETSDR_INSTALL="$CS_INSTALL/SoapyNetSDR"
if (-not ($SOAPY_NETSDR_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_NETSDR_TARGET -ItemType Directory
    cmake -B $SOAPY_NETSDR_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $SOAPY_NETSDR_SOURCES `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL"
    cmake --build $SOAPY_NETSDR_TARGET --config $CS_BUILD_TYPE --target install
}
