@echo off

cd %CS_SOURCES%
if not exist SoapyRemote (
    git clone https://github.com/pothosware/SoapyRemote 
)

cd %CS_TARGET%
if not exist SoapyRemote (
    mkdir SoapyRemote
    cmake -B SoapyRemote -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyRemote^
        -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR^
        -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapyRemote --config Release --target install
)

cd %CS_ROOT%
