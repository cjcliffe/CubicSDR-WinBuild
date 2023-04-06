$SOAPY_SDR_SOURCE="$CS_SOURCES/SoapySDR"
if (-not ($SOAPY_SDR_SOURCE | Test-Path)) {
    git -c advice.detachedHead=false clone -b soapy-sdr-0.8.1 https://github.com/pothosware/SoapySDR $SOAPY_SDR_SOURCE
}


$SOAPY_SDR_TARGET="$CS_TARGET/SoapySDR"
$SOAPY_SDR_INSTALL="$CS_INSTALL/SoapySDR"
if (-not ($SOAPY_SDR_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_SDR_TARGET -ItemType Directory
    cmake -B "$SOAPY_SDR_TARGET" -G "$CS_GENERATOR" -A $CS_BUILD_ARCH "$SOAPY_SDR_SOURCE" -DCMAKE_INSTALL_PREFIX="$SOAPY_SDR_INSTALL"
    cmake --build "$SOAPY_SDR_TARGET" --config $CS_BUILD_TYPE --target install
}


$SOAPY_SDR_DLL="$SOAPY_SDR_INSTALL/bin/SoapySDR.dll"
if (-not ($SOAPY_SDR_DLL | Test-Path)) {
    Write-Host "Error: $SOAPY_SDR_DLL was not built." -ForegroundColor Red
    Break
}

$SOAPY_SDR_LIBRARY="$SOAPY_SDR_INSTALL/lib/SoapySDR.lib"
$SOAPY_SDR_INCLUDE_DIR="$SOAPY_SDR_INSTALL/include"
$SoapySDR_DIR="$SOAPY_SDR_INSTALL"