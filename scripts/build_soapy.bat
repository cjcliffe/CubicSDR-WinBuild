@echo off

cd %CS_SOURCES%

if not exist SoapySDR (
    git -c advice.detachedHead=false clone -b soapy-sdr-0.8.1 https://github.com/pothosware/SoapySDR 
)
cd SoapySDR
set "SOAPY_SDR_ROOT=%CS_INSTALL%/SoapySDR"

cd %CS_TARGET%
if not exist SoapySDR (
    mkdir SoapySDR
    cmake -B SoapySDR -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapySDR^
        -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%/SoapySDR
    cmake --build SoapySDR --config Release --target install
)

cd %CS_ROOT%