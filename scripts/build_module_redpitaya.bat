@echo off

cd %CS_SOURCES%
if not exist SoapyRedPitaya (
    git clone https://github.com/pothosware/SoapyRedPitaya 
)

cd %CS_TARGET%
if not exist SoapyRedPitaya (
    mkdir SoapyRedPitaya
    cmake -B SoapyRedPitaya -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyRedPitaya^
        -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR^
        -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapyRedPitaya --config Release --target install
)

cd %CS_ROOT%
