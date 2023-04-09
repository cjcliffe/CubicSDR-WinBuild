$AIRSPYHF_HOST_SOURCES="$CS_SOURCES/airspyhf"
if (-not ($AIRSPYHF_HOST_SOURCES | Test-Path)) {
    git clone https://github.com/airspy/airspyhf $AIRSPYHF_HOST_SOURCES
}

$AIRSPYHF_HOST_TARGET="$CS_TARGET/airspyhf"
$AIRSPYHF_HOST_INSTALL="$CS_INSTALL/airspyhf"
if (-not ($AIRSPYHF_HOST_TARGET | Test-Path)) {
    $null=New-Item $AIRSPYHF_HOST_TARGET -ItemType Directory
    cmake -B $AIRSPYHF_HOST_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $AIRSPYHF_HOST_SOURCES `
        -DTHREADS_PTHREADS_WIN32_LIBRARY:PATH="$PTHREADS_LIBRARIES" `
        -DTHREADS_PTHREADS_INCLUDE_DIR:PATH="$PTHREADS_INCLUDE_DIR" `
        -DLIBUSB_INCLUDE_DIR:PATH="$LIBUSB_INCLUDE_DIR" `
        -DLIBUSB_LIBRARIES:PATH="$LIBUSB_LIBRARIES" `
        -DCMAKE_INSTALL_PREFIX="$AIRSPYHF_HOST_INSTALL"
    cmake --build $AIRSPYHF_HOST_TARGET --config $CS_BUILD_TYPE --target install  
}
$AIRSPYHF_INCLUDE_DIR="$AIRSPYHF_HOST_INSTALL/include/"
$AIRSPYHF_LIBRARIES="$AIRSPYHF_HOST_INSTALL/bin/airspyhf.lib"
Copy-Item -Path "$AIRSPYHF_HOST_INSTALL/bin/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$SOAPY_AIRSPYHF_SOURCES="$CS_SOURCES/SoapyAirspyHF"
if (-not ($SOAPY_AIRSPYHF_SOURCES | Test-Path)) {
    git clone https://github.com/pothosware/SoapyAirspyHF $SOAPY_AIRSPYHF_SOURCES
}

$SOAPY_AIRSPYHF_TARGET="$CS_TARGET/SoapyAirspyHF"
if (-not ($SOAPY_AIRSPYHF_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_AIRSPYHF_TARGET -ItemType Directory
    cmake -B $SOAPY_AIRSPYHF_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $SOAPY_AIRSPYHF_SOURCES `
        -DLIBAIRSPYHF_LIBRARIES:PATH="$AIRSPYHF_LIBRARIES" `
        -DLIBAIRSPYHF_INCLUDE_DIRS:PATH="$AIRSPYHF_INCLUDE_DIR" `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL"
    cmake --build $AIRSPYHF_HOST_TARGET --config $CS_BUILD_TYPE --target install
}

