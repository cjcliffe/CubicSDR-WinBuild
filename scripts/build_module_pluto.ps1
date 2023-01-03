$LIBIIO_SOURCES="$CS_SOURCES/libiio"
if (-not ($LIBIIO_SOURCES | Test-Path)) {
    git clone https://github.com/analogdevicesinc/libiio $LIBIIO_SOURCES
}

$LIBIIO_TARGET="$CS_TARGET/libiio"
$LIBIIO_INSTALL="$CS_INSTALL/libiio"
if (-not ($LIBIIO_TARGET | Test-Path)) {
    $null=New-Item $LIBIIO_TARGET -ItemType Directory
    cmake -B $LIBIIO_TARGET -G $CS_GENERATOR -A x64 $LIBIIO_SOURCES `
        -DCMAKE_INSTALL_PREFIX="$LIBIIO_INSTALL" `
        -DLIBUSB_INCLUDE_DIR:PATH="$LIBUSB_INCLUDE_DIR" `
        -DLIBUSB_LIBRARIES:PATH="$LIBUSB_LIBRARIES" `
        -DIconv_INCLUDE_DIR:PATH="$LIBICONV_INCLUDE_DIR" `
        -DIconv_LIBRARY:FILEPATH="$LIBICONV_LIBRARY" `
        -DLIBXML2_LIBRARY:FILEPATH="$LIBXML2_LIBRARY" `
        -DLIBXML2_INCLUDE_DIR:PATH="$LIBXML2_INCLUDE_DIR"
        
    cmake --build $LIBIIO_TARGET --config Release --target install
}
$LIBIIO_INCLUDE_DIR="$CS_INSTALL/libiio/include"
$LIBIIO_LIBRARY="$CS_INSTALL/libiio/lib/libiio.lib"
Copy-Item -Path "$LIBIIO_INSTALL/bin/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$LIBAD_SOURCES="$CS_SOURCES/libad9361-iio"
if (-not ($LIBAD_SOURCES | Test-Path)) {
    git clone https://github.com/analogdevicesinc/libad9361-iio $LIBAD_SOURCES
}

$LIBAD_TARGET="$CS_TARGET/libad9361-iio"
$LIBAD_INSTALL="$CS_INSTALL/libad9361-iio"
if (-not ($LIBAD_TARGET | Test-Path)) {
    $null=New-Item $LIBAD_TARGET -ItemType Directory
    cmake -B $LIBAD_TARGET -G $CS_GENERATOR -A x64 $LIBAD_SOURCES `
        -DCMAKE_INSTALL_PREFIX="$LIBAD_INSTALL" `
        -DLIBIIO_INCLUDEDIR="$LIBIIO_INCLUDE_DIR" `
        -DLIBIIO_LIBRARIES="$LIBIIO_LIBRARY"
    cmake --build $LIBAD_TARGET --config Release --target install
}
$LibAD9361_INCLUDE_DIR="$LIBAD_INSTALL/include"
$LibAD9361_LIBRARY="$LIBAD_INSTALL/lib/libad9361.lib"
Copy-Item -Path "$LIBAD_INSTALL/bin/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$SOAPY_PLUTOSDR_SOURCES="$CS_SOURCES/SoapyPlutoSDR"
if (-not ($SOAPY_PLUTOSDR_SOURCES | Test-Path)) {
    git clone https://github.com/pothosware/SoapyPlutoSDR $SOAPY_PLUTOSDR_SOURCES
}

$SOAPY_PLUTOSDR_TARGET="$CS_TARGET/SoapyPlutoSDR"
if (-not ($SOAPY_PLUTOSDR_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_PLUTOSDR_TARGET -ItemType Directory
    cmake -B $SOAPY_PLUTOSDR_TARGET -G $CS_GENERATOR -A x64 $SOAPY_PLUTOSDR_SOURCES `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL" `
        -DLibIIO_LIBRARY="$LIBIIO_LIBRARY" `
        -DLibIIO_INCLUDE_DIR="$LibIIO_INCLUDE_DIR" `
        -DLibAD9361_INCLUDE_DIR="$LibAD9361_INCLUDE_DIR" `
        -DLibAD9361_LIBRARY="$LibAD9361_LIBRARY" `
        -DLibUSB_INCLUDE_DIR:PATH="$LIBUSB_INCLUDE_DIR" `
        -DLibUSB_LIBRARY:PATH="$LIBUSB_LIBRARIES" 
    cmake --build $SOAPY_PLUTOSDR_TARGET --config Release --target install
}
