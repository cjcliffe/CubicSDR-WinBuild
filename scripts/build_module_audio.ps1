$SOAPY_AUDIO_SOURCES="$CS_SOURCES/SoapyAudio"
if (-not ($SOAPY_AUDIO_SOURCES | Test-Path)) {
    git clone https://github.com/pothosware/SoapyAudio $SOAPY_AUDIO_SOURCES
}

$SOAPY_AUDIO_TARGET="$CS_TARGET/SoapyAudio"
if (-not ($SOAPY_AUDIO_TARGET | Test-Path)) {
    $null=New-Item $SOAPY_AUDIO_TARGET -ItemType Directory
    cmake -B $SOAPY_AUDIO_TARGET -G $CS_GENERATOR -A x64 $SOAPY_AUDIO_SOURCES `
        -DCMAKE_INSTALL_PREFIX:PATH="$SOAPY_SDR_INSTALL" `
        -DCMAKE_PREFIX_PATH:PATH="$SOAPY_SDR_INSTALL" `
        -DSOAPY_SDR_ROOT="$SOAPY_SDR_INSTALL" 
    cmake --build $SOAPY_AUDIO_TARGET --config Release --target install
}
