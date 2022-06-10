@echo off

cd %CS_SOURCES%
if not exist airspyhf (
    git clone https://github.com/airspy/airspyhf
)

cd %CS_TARGET%
if not exist airspyhf (
    mkdir airspyhf
    cmake -B airspyhf -G %CS_GENERATOR% -A x64 %CS_SOURCES%/airspyhf^
        -DTHREADS_PTHREADS_WIN32_LIBRARY:PATH=%PTHREADS_LIBRARIES%^
        -DTHREADS_PTHREADS_INCLUDE_DIR:PATH=%PTHREADS_INCLUDE_DIR%^
        -DLIBUSB_INCLUDE_DIR:PATH=%LIBUSB_INCLUDE_DIR%^
        -DLIBUSB_LIBRARIES:PATH=%LIBUSB_LIBRARIES%^
        -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%/airspyhf
    cmake --build airspyhf --config Release --target install
)

set "AIRSPYHF_INCLUDE_DIR=%CS_INSTALL%/airspyhf/include/"
set "AIRSPYHF_LIBRARIES=%CS_INSTALL%/airspyhf/bin/airspyhf.lib"
xcopy /yf "%CS_INSTALL_BS%\airspyhf\bin\*.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"

cd %CS_SOURCES%
if not exist SoapyAirspyHF (
    git clone https://github.com/pothosware/SoapyAirspyHF 
)

cd %CS_TARGET%
if not exist SoapyAirspyHF (
    mkdir SoapyAirspyHF
    cmake -B SoapyAirspyHF -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyAirspyHF^
        -DLIBAIRSPYHF_LIBRARIES:PATH=%AIRSPYHF_LIBRARIES%^
        -DLIBAIRSPYHF_INCLUDE_DIRS:PATH=%AIRSPYHF_INCLUDE_DIR%^
        -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR^
        -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapyAirspyHF --config Release --target install
)

cd %CS_ROOT%
