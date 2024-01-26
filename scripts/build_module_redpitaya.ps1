
$SOAPY_REDPITAYA_SOURCES="$CS_SOURCES/SoapyRedPitaya"
if (-not ($SOAPY_REDPITAYA_SOURCES | Test-Path)) {
    git clone --depth 1 https://github.com/pothosware/SoapyRedPitaya $SOAPY_REDPITAYA_SOURCES
}


$SOAPY_REDPITAYA_TARGET="$CS_TARGET/SoapyRedPitaya"
if (-not ($SOAPY_REDPITAYA_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_REDPITAYA_TARGET -ItemType Directory
    cmake -B $SOAPY_REDPITAYA_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $SOAPY_REDPITAYA_SOURCES `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL" 
    cmake --build $SOAPY_REDPITAYA_TARGET --config $CS_BUILD_TYPE --target install
}
