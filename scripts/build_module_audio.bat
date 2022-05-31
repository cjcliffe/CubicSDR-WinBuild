@echo off

cd %CS_SOURCES%
if not exist SoapyAudio (
    git clone https://github.com/pothosware/SoapyAudio 
)

cd %CS_TARGET%
if not exist SoapyAudio (
    mkdir SoapyAudio
    cmake -B SoapyAudio -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyAudio -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapyAudio --config Release --target install
)

cd %CS_ROOT%
