$RTLSDR_SOURCES="$CS_SOURCES/librtlsdr"
if (-not ($RTLSDR_SOURCES | Test-Path)) {
    # git clone https://github.com/librtlsdr/librtlsdr $RTLSDR_SOURCES    
    git clone https://github.com/steve-m/librtlsdr $RTLSDR_SOURCES    
}

$RTLSDR_TARGET="$CS_TARGET/librtlsdr"
$RTLSDR_INSTALL="$CS_INSTALL/librtlsdr"
if (-not ($RTLSDR_TARGET | Test-Path)) {
    $null=New-Item $RTLSDR_TARGET -ItemType Directory
    cmake -B $RTLSDR_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $RTLSDR_SOURCES `
        -DTHREADS_PTHREADS_LIBRARY:PATH="$PTHREADS_LIBRARIES" `
        -DTHREADS_PTHREADS_INCLUDE_DIR:PATH="$PTHREADS_INCLUDE_DIR" `
        -DLIBUSB_INCLUDE_DIRS:PATH="$LIBUSB_INCLUDE_DIR" `
        -DLIBUSB_LIBRARIES:PATH="$LIBUSB_LIBRARIES" `
        -DCMAKE_INSTALL_PREFIX="$RTLSDR_INSTALL"
    cmake --build $RTLSDR_TARGET --config Release --target install
}

$RTLSDR_INCLUDE_DIR="$RTLSDR_INSTALL/include/"
$RTLSDR_LIBRARIES="$RTLSDR_INSTALL/lib/rtlsdr.lib"
Copy-Item -Path "$RTLSDR_INSTALL/bin/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"



$SOAPY_RTLSDR_SOURCES="$CS_SOURCES/SoapyRTLSDR"
if (-not ($SOAPY_RTLSDR_SOURCES | Test-Path)) {
    git clone https://github.com/pothosware/SoapyRTLSDR $SOAPY_RTLSDR_SOURCES
}


$SOAPY_RTLSDR_TARGET="$CS_TARGET/SoapyRTLSDR"
if (-not ($SOAPY_RTLSDR_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_RTLSDR_TARGET -ItemType Directory
    cmake -B $SOAPY_RTLSDR_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $SOAPY_RTLSDR_SOURCES `
        -DRTLSDR_LIBRARY:PATH="$RTLSDR_LIBRARIES" `
        -DRTLSDR_INCLUDE_DIR:PATH="$RTLSDR_INCLUDE_DIR" `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL" `
        -DSOAPY_SDR_ROOT="$SOAPY_SDR_INSTALL" 
    cmake --build $SOAPY_RTLSDR_TARGET --config $CS_BUILD_TYPE --target install
}
