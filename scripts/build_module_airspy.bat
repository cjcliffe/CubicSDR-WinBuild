@echo off

cd %CS_SOURCES%
if not exist airspyone_host (
    git clone https://github.com/airspy/airspyone_host
)

cd %CS_TARGET%
if not exist airspyone_host (
    mkdir airspyone_host
    cmake -B airspyone_host -G %CS_GENERATOR% -A x64 %CS_SOURCES%/airspyone_host^
        -DTHREADS_PTHREADS_WIN32_LIBRARY:PATH=%PTHREADS_LIBRARIES%^
        -DTHREADS_PTHREADS_INCLUDE_DIR:PATH=%PTHREADS_INCLUDE_DIR%^
        -DLIBUSB_INCLUDE_DIR:PATH=%LIBUSB_INCLUDE_DIR%^
        -DLIBUSB_LIBRARIES:PATH=%LIBUSB_LIBRARIES%^
        -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%/airspy
    cmake --build airspyone_host --config Release --target install
)

set "AIRSPY_INCLUDE_DIR=%CS_INSTALL%/airspy/include/"
set "AIRSPY_LIBRARIES=%CS_INSTALL%/airspy/bin/airspy.lib"

cd %CS_SOURCES%
if not exist SoapyAirspy (
    git clone https://github.com/pothosware/SoapyAirspy 
)

cd %CS_TARGET%
if not exist SoapyAirspy (
    mkdir SoapyAirspy
    cmake -B SoapyAirspy -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyAirspy^
        -DLIBAIRSPY_LIBRARIES:PATH=%AIRSPY_LIBRARIES%^
        -DLIBAIRSPY_INCLUDE_DIRS:PATH=%AIRSPY_INCLUDE_DIR%^
        -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR^
        -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapyAirspy --config Release --target install
)

cd %CS_ROOT%
