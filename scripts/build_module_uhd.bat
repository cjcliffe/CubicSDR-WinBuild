@echo off

cd %CS_SOURCES%
if not exist uhd (
    git clone https://github.com/EttusResearch/uhd.git
)

cd %CS_TARGET%
if not exist uhd (
    mkdir uhd
    pip install mako
    cmake -B uhd -G %CS_GENERATOR% -A x64 %CS_SOURCES%/uhd/host^
        -DBoost_INCLUDE_DIR:PATH=%BOOST_INCLUDE_DIRS%^
        -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%/uhd^
        -DENABLE_PYTHON_API=OFF^
        -DENABLE_EXAMPLES=OFF^
        -DENABLE_UTILS=OFF^
        -DENABLE_TESTS=OFF^
        -DENABLE_TESTS=OFF
    cmake --build uhd --config Release --target install
)  
set "UHD_INCLUDE_DIR=%CS_INSTALL%/uhd/include"
set "UHD_LIBRARIES=%CS_INSTALL%/uhd/lib/uhd.lib"
xcopy /yf "%CS_INSTALL_BS%\uhd\bin\*.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"


cd %CS_SOURCES%
if not exist SoapyUHD (
    git clone https://github.com/pothosware/SoapyUHD 
)

cd %CS_TARGET%
if not exist SoapyUHD (
    mkdir SoapyUHD
    cmake -B SoapyUHD -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyUHD^
        -DUHD_LIBRARIES:PATH=%UHD_LIBRARIES%^
        -DUHD_INCLUDE_DIRS:PATH=%UHD_INCLUDE_DIR%^
        -DBoost_INCLUDE_DIR:PATH=%BOOST_INCLUDE_DIRS%^
        -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR^
        -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build SoapyUHD --config Release --target install
)
 
cd %CS_ROOT%
