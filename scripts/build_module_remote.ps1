
$SOAPY_REMOTE_SOURCES="$CS_SOURCES/SoapyRemote"
if (-not ($SOAPY_REMOTE_SOURCES | Test-Path)) {
    git clone https://github.com/pothosware/SoapyRemote $SOAPY_REMOTE_SOURCES
}

$SOAPY_REMOTE_TARGET="$CS_TARGET/SoapyRemote"
$SOAPY_REMOTE_INSTALL="$CS_INSTALL/SoapyRemote"

if (-not ($SOAPY_REMOTE_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_REMOTE_TARGET -ItemType Directory
    cmake -B $SOAPY_REMOTE_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $SOAPY_REMOTE_SOURCES `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL"
    cmake --build $SOAPY_REMOTE_TARGET --config $CS_BUILD_TYPE --target install
}
