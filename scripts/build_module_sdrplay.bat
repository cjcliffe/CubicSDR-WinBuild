@echo off

cd %CS_SOURCES%
if not exist SoapySDRPlay3 (
    git clone https://github.com/pothosware/SoapySDRPlay3 
)

cd %CS_TARGET%
if not exist SoapySDRPlay3 (
    mkdir SoapySDRPlay3
    cmake -B SoapySDRPlay3 -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapySDRPlay3^
        -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR^
        -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapySDRPlay3 --config Release --target install
)

cd %CS_ROOT%
