@echo off

cd %CS_SOURCES%
if not exist librtlsdr (
    git clone https://github.com/librtlsdr/librtlsdr
)

cd %CS_TARGET%
if not exist librtlsdr (
    mkdir librtlsdr
    cmake -B librtlsdr -G %CS_GENERATOR% -A x64 %CS_SOURCES%/librtlsdr^
        -DTHREADS_PTHREADS_WIN32_LIBRARY:PATH=%PTHREADS_LIBRARIES%^
        -DTHREADS_PTHREADS_INCLUDE_DIR:PATH=%PTHREADS_INCLUDE_DIR%^
        -DLIBUSB_INCLUDE_DIR:PATH=%LIBUSB_INCLUDE_DIR%^
        -DLIBUSB_LIBRARIES:PATH=%LIBUSB_LIBRARIES%^
        -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%
    cmake --build librtlsdr --config Release --target install
)
set "RTLSDR_INCLUDE_DIR=%CS_SOURCES%/librtlsdr/include/"
set "RTLSDR_LIBRARIES=%CS_TARGET%/librtlsdr/src/Release/rtlsdr.lib"

cd %CS_SOURCES%
if not exist SoapyRTLSDR (
    git clone https://github.com/pothosware/SoapyRTLSDR 
)

cd %CS_TARGET%
if not exist SoapyRTLSDR (
    mkdir SoapyRTLSDR
    cmake -B SoapyRTLSDR -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyRTLSDR^
        -DRTLSDR_LIBRARY:PATH=%RTLSDR_LIBRARIES%^
        -DRTLSDR_INCLUDE_DIR:PATH=%RTLSDR_INCLUDE_DIR%^
        -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR^
        -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapyRTLSDR --config Release --target install
)

cd %CS_ROOT%
