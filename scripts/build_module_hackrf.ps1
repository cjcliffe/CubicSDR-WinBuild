$HACKRF_SOURCES="$CS_SOURCES/hackrf"

if (-not ($HACKRF_SOURCES | Test-Path)) {
    git clone https://github.com/greatscottgadgets/hackrf $HACKRF_SOURCES    
}

$HACKRF_TARGET="$CS_TARGET/hackrf"
$HACKRF_INSTALL="$CS_INSTALL/hackrf"
if (-not ($HACKRF_TARGET | Test-Path)) {
    $null=New-Item $HACKRF_TARGET -ItemType Directory
    cmake -B $HACKRF_TARGET -G $CS_GENERATOR -A x64 $HACKRF_SOURCES/host `
        -DFFTW_LIBRARIES="$FFTW3_LIBRARIES" `
        -DFFTW_INCLUDES="$FFTW3_INCLUDE_DIR" `
        -DTHREADS_PTHREADS_WIN32_LIBRARY:PATH="$PTHREADS_LIBRARIES" `
        -DTHREADS_PTHREADS_INCLUDE_DIR:PATH="$PTHREADS_INCLUDE_DIR" `
        -DLIBUSB_INCLUDE_DIR:PATH="$LIBUSB_INCLUDE_DIR" `
        -DLIBUSB_LIBRARIES:PATH="$LIBUSB_LIBRARIES" `
        -DCMAKE_INSTALL_PREFIX="$HACKRF_INSTALL"
    cmake --build $HACKRF_TARGET --config Release --target install
}

$HACKRF_INCLUDE_DIR="$CS_INSTALL/hackrf/include/libhackrf"
$HACKRF_LIBRARIES="$HACKRF_INSTALL/bin/hackrf.lib"
Copy-Item -Path "$HACKRF_INSTALL/bin/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$SOAPY_HACKRF_SOURCES="$CS_SOURCES/SoapyHackRF"
if (-not ($SOAPY_HACKRF_SOURCES | Test-Path)) {
    git clone https://github.com/pothosware/SoapyHackRF $SOAPY_HACKRF_SOURCES
}

$SOAPY_HACKRF_TARGET="$CS_TARGET/SoapyHackRF"
if (-not ($SOAPY_HACKRF_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_HACKRF_TARGET -ItemType Directory
    cmake -B $SOAPY_HACKRF_TARGET -G $CS_GENERATOR -A x64 $SOAPY_HACKRF_SOURCES `
        -DLIBHACKRF_LIBRARY:PATH="$HACKRF_LIBRARIES" `
        -DLIBHACKRF_INCLUDE_DIR:PATH="$HACKRF_INCLUDE_DIR" `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL" `
        -DSOAPY_SDR_ROOT="$SOAPY_SDR_INSTALL" 
    cmake --build $SOAPY_HACKRF_TARGET --config Release --target install
}
