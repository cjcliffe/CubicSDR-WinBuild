$LIMESUITE_SOURCES="$CS_SOURCES/limesuite"

if (-not ($LIMESUITE_SOURCES | Test-Path)) {
    git clone --depth 1 https://github.com/myriadrf/LimeSuite $LIMESUITE_SOURCES    
}

$LIMESUITE_TARGET="$CS_TARGET/limesuite"
$LIMESUITE_INSTALL="$CS_INSTALL/limesuite"
if (-not ($LIMESUITE_TARGET | Test-Path)) {
    $null=New-Item $LIMESUITE_TARGET -ItemType Directory
    cmake -B $LIMESUITE_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $LIMESUITE_SOURCES `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL"        
    cmake --build $LIMESUITE_TARGET --config $CS_BUILD_TYPE --target install
}
