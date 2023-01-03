$UHD_SOURCES="$CS_SOURCES/uhd"
if (-not ($UHD_SOURCES | Test-Path)) {
    git clone https://github.com/EttusResearch/uhd.git $UHD_SOURCES
}

$UHD_TARGET="$CS_TARGET/uhd"
$UHD_INSTALL="$CS_INSTALL/uhd"
if (-not ($UHD_TARGET | Test-Path)) {
    $null=New-Item $UHD_TARGET -ItemType Directory
    pip install mako
    cmake -B $UHD_TARGET -G $CS_GENERATOR -A x64 $UHD_SOURCES/host `
        -DBoost_INCLUDE_DIR:PATH="$BOOST_INCLUDE_DIRS" `
        -DCMAKE_INSTALL_PREFIX="$UHD_INSTALL" `
        -DENABLE_PYTHON_API=OFF `
        -DENABLE_EXAMPLES=OFF `
        -DENABLE_UTILS=OFF `
        -DENABLE_TESTS=OFF `
        -DENABLE_TESTS=OFF
    cmake --build $UHD_TARGET --config Release --target install
}
$UHD_INCLUDE_DIR="$UHD_INSTALL/include"
$UHD_LIBRARIES="$UHD_INSTALL/lib/uhd.lib"
Copy-Item -Path "$UHD_INSTALL/bin/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$SOAPY_UHD_SOURCES="$CS_SOURCES/SoapyUHD"
if (-not ($SOAPY_UHD_SOURCES | Test-Path)) {
    git clone https://github.com/pothosware/SoapyUHD $SOAPY_UHD_SOURCES
}

$SOAPY_UHD_TARGET="$CS_TARGET/SoapyUHD"
if (-not ($SOAPY_UHD_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_UHD_TARGET -ItemType Directory
    cmake -B $SOAPY_UHD_TARGET -G $CS_GENERATOR -A x64 $SOAPY_UHD_SOURCES `
        -DUHD_LIBRARIES:PATH="$UHD_LIBRARIES" `
        -DUHD_INCLUDE_DIRS:PATH="$UHD_INCLUDE_DIR" `
        -DBoost_INCLUDE_DIR:PATH="$BOOST_INCLUDE_DIRS" `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL" `
        -DSOAPY_SDR_ROOT="$SOAPY_SDR_INSTALL" 
    cmake --build $SOAPY_UHD_TARGET --config Release --target install
}
 