@echo off

cd %CS_SOURCES%
if not exist SoapyNetSDR (
    git clone https://github.com/pothosware/SoapyNetSDR 
)

cd %CS_TARGET%
if not exist SoapyNetSDR (
    mkdir SoapyNetSDR
    cmake -B SoapyNetSDR -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyNetSDR^
        -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR^
        -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapyNetSDR --config Release --target install
)

cd %CS_ROOT%
