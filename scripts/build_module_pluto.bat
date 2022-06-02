@echo off

cd %CS_DEPS%
if not exist libiconv-win-build (
    git clone https://github.com/kiyolee/libiconv-win-build.git
    cd libiconv-win-build/build-VS2022
    msbuild libiconv.sln /property:Configuration=Release /property:Platform=x64
)
set "LIBICONV_INCLUDE_DIR=%CS_DEPS%/libiconv-win-build/include"
set "LIBICONV_LIBRARY=%CS_DEPS%/libiconv-win-build/build-VS2022/x64/Release/libiconv.lib"


cd %CS_SOURCES%
if not exist libiio (
    git clone https://github.com/analogdevicesinc/libiio
)

cd %CS_TARGET%
if not exist libiio (
    mkdir libiio
    cmake -B libiio -G %CS_GENERATOR% -A x64 %CS_SOURCES%/libiio^
        -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%/libiio^
        -DLIBUSB_INCLUDE_DIR:PATH=%LIBUSB_INCLUDE_DIR%^
        -DLIBUSB_LIBRARIES:PATH=%LIBUSB_LIBRARIES%^
        -DIconv_INCLUDE_DIR:PATH="%LIBICONV_INCLUDE_DIR%"^
        -DIconv_LIBRARY:FILEPATH="%LIBICONV_LIBRARY%"
    cmake --build libiio --config Release --target install
)
set "LibIIO_INCLUDE_DIR=%CS_INSTALL%/libiio/include"
set "LibIIO_LIBRARY=%CS_INSTALL%/libiio/lib/libiio.lib"


cd %CS_SOURCES%
if not exist libad9361-iio (
    git clone https://github.com/analogdevicesinc/libad9361-iio
)

cd %CS_TARGET%
if not exist libad9361-iio (
    mkdir libad9361-iio
    cmake -B libad9361-iio -G %CS_GENERATOR% -A x64 %CS_SOURCES%/libad9361-iio^
        -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%/libad9361-iio^
        -DLIBIIO_INCLUDEDIR=%LibIIO_INCLUDE_DIR%^
        -DLIBIIO_LIBRARIES=%LibIIO_LIBRARY%
    cmake --build libad9361-iio --config Release --target install
)
set "LibAD9361_INCLUDE_DIR=%CS_INSTALL%/libad9361-iio/include"
set "LibAD9361_LIBRARY=%CS_INSTALL%/libad9361-iio/lib/libad9361.lib"


cd %CS_SOURCES%
if not exist SoapyPlutoSDR (
    git clone https://github.com/pothosware/SoapyPlutoSDR 
)

cd %CS_TARGET%
if not exist SoapyPlutoSDR (
    mkdir SoapyPlutoSDR
    cmake -B SoapyPlutoSDR -G %CS_GENERATOR% -A x64 %CS_SOURCES%\SoapyPlutoSDR^
        -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR^
        -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR^
        -DLibIIO_LIBRARY=%LibIIO_LIBRARY%^
        -DLibIIO_INCLUDE_DIR=%LibIIO_INCLUDE_DIR%^
        -DLibAD9361_INCLUDE_DIR=%LibAD9361_INCLUDE_DIR%^
        -DLibAD9361_LIBRARY=%LibAD9361_LIBRARY%
    cmake --build SoapyPlutoSDR --config Release --target install
)

cd %CS_ROOT%
