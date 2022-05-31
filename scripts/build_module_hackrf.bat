@echo off

cd %CS_SOURCES%
if not exist hackrf (
    git clone https://github.com/greatscottgadgets/hackrf
)

cd %CS_TARGET%
if not exist hackrf (
    mkdir hackrf
    cmake -B hackrf_host -G %CS_GENERATOR% -A x64 %CS_SOURCES%/hackrf/host -DFFTW_LIBRARIES=%FFTW3_LIBRARIES% -DFFTW_INCLUDES=%FFTW3_INCLUDE_DIR% -DTHREADS_PTHREADS_WIN32_LIBRARY:PATH=%PTHREADS_LIBRARIES% -DTHREADS_PTHREADS_INCLUDE_DIR:PATH=%PTHREADS_INCLUDE_DIR% -DLIBUSB_INCLUDE_DIR:PATH=%LIBUSB_INCLUDE_DIR% -DLIBUSB_LIBRARIES:PATH=%LIBUSB_LIBRARIES% -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%/hackrf
    cmake --build hackrf_host --config Release --target install
)
set "HACKRF_INCLUDE_DIR=%CS_INSTALL%/hackrf/include/libhackrf"
set "HACKRF_LIBRARIES=%CS_INSTALL%/hackrf/bin/hackrf.lib"

cd %CS_SOURCES%
if not exist SoapyHackRF (
    git clone https://github.com/pothosware/SoapyHackRF 
)

cd %CS_TARGET%
if not exist SoapyHackRF (
    mkdir SoapyHackRF
    cmake -B SoapyHackRF -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyHackRF -DLIBHACKRF_LIBRARY:PATH=%HACKRF_LIBRARIES% -DLIBHACKRF_INCLUDE_DIR:PATH=%HACKRF_INCLUDE_DIR% -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapyHackRF --config Release --target install
)

cd %CS_ROOT%
