@echo off

cd %CS_DEPS%
if not exist libusb (
    git clone https://github.com/libusb/libusb
    cd libusb/msvc/
    devenv /Upgrade libusb_2019.sln 
    msbuild libusb_2019.sln /property:Configuration=Release /property:Platform=x64
)
set "LIBUSB_LIBRARIES=%CS_DEPS%/libusb/x64/Release/lib/libusb-1.0.lib"
set "LIBUSB_INCLUDE_DIR=%CS_DEPS%/libusb/libusb"


cd %CS_DEPS%
if not exist pthread-win32-3.0.3.1 (
    echo Downloading pthreads..
    powershell -Command "Invoke-WebRequest https://github.com/GerHobbelt/pthread-win32/archive/refs/tags/v3.0.3.1.zip -OutFile pthread_win.zip"
    @REM powershell Expand-Archive pthread_win.zip .
    7z x pthread_win.zip
    cd pthread-win32-3.0.3.1/windows/VS2019/
    devenv /Upgrade pthread.2019.sln
    msbuild pthread.2019.sln /property:Configuration=Release /property:Platform=x64
)
set "PTHREADS_LIBRARIES=%CS_DEPS%/pthread-win32-3.0.3.1/windows/VS2019/bin/Release-Unicode-64bit-x64/pthread.lib"
set "PTHREADS_INCLUDE_DIR=%CS_DEPS%/pthread-win32-3.0.3.1"


cd %CS_DEPS%
if not exist fftw-3.3.5-dll64 (
    echo Downloading fftw..
    powershell -Command "Invoke-WebRequest https://fftw.org/pub/fftw/fftw-3.3.5-dll64.zip -OutFile fftw-3.3.5-dll64.zip"
    @REM powershell Expand-Archive fftw-3.3.5-dll64.zip fftw-3.3.5-dll64
    7z x fftw-3.3.5-dll64.zip fftw-3.3.5-dll64
    cd fftw-3.3.5-dll64/
    lib /def:libfftw3f-3.def /MACHINE:x64
)
set "FFTW3_LIBRARIES=%CS_DEPS%/fftw-3.3.5-dll64/libfftw3f-3.lib"
set "FFTW3_INCLUDE_DIR=%CS_DEPS%/fftw-3.3.5-dll64/"


cd %CS_DEPS%
if not exist libiconv-win-build (
    git clone https://github.com/kiyolee/libiconv-win-build.git
    cd libiconv-win-build/build-VS2022
    msbuild libiconv.sln /property:Configuration=Release /property:Platform=x64
)
set "LIBICONV_INCLUDE_DIR=%CS_DEPS%/libiconv-win-build/include"
set "LIBICONV_LIBRARY=%CS_DEPS%/libiconv-win-build/build-VS2022/x64/Release/libiconv.lib"


cd %CS_DEPS%
if not exist xz (
    git clone -c advice.detachedHead=false -b v5.2.5 https://git.tukaani.org/xz.git 
    cd xz/windows/VS2019/
    devenv /Upgrade xz_win.sln
    msbuild xz_win.sln /property:Configuration=Release /property:Platform=x64
)
set "LIBLZMA_LIBRARIES=%CS_DEPS%/xz/windows/vs2019/Release/x64/liblzma_dll/liblzma.lib"
set "LIBLZMA_INCLUDE_DIR=%CS_DEPS%/xz/src/liblzma/api"


cd %CS_SOURCES%
if not exist zlib (
    git clone https://github.com/madler/zlib
)

cd %CS_TARGET%
if not exist zlib (
    mkdir zlib
    cmake -B zlib -G %CS_GENERATOR% -A x64 %CS_SOURCES%/zlib^
        -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%/zlib

    cmake --build zlib --config Release --target install
)
set "ZLIB_LIBRARY=%CS_INSTALL%/zlib/lib/zlib.lib"
set "ZLIB_INCLUDE_DIR=%CS_INSTALL%/zlib/include"


cd %CS_SOURCES%
if not exist libxml2 (
    git clone https://gitlab.gnome.org/GNOME/libxml2.git
)

cd %CS_TARGET%
if not exist libxml2 (
    mkdir libxml2
    cmake -B libxml2 -G %CS_GENERATOR% -A x64 %CS_SOURCES%/libxml2^
        -DCMAKE_INSTALL_PREFIX=%CS_INSTALL%/libxml2^
        -DIconv_INCLUDE_DIR:PATH="%LIBICONV_INCLUDE_DIR%"^
        -DIconv_LIBRARY:FILEPATH="%LIBICONV_LIBRARY%"^
        -DLIBLZMA_LIBRARY=%LIBLZMA_LIBRARIES%^
        -DLIBLZMA_INCLUDE_DIR=%LIBLZMA_INCLUDE_DIR%^
        -DLIBXML2_WITH_PYTHON=OFF^
        -DZLIB_INCLUDE_DIR=%ZLIB_INCLUDE_DIR%^
        -DZLIB_LIBRARY=%ZLIB_LIBRARY%

    cmake --build libxml2 --config Release --target install
)

set "LIBXML2_LIBRARY=%CS_INSTALL%/libxml2/lib/libxml2.lib"
set "LIBXML2_INCLUDE_DIR=%CS_INSTALL%/libxml2/include/libxml2;%LIBICONV_INCLUDE_DIR%"


cd %CS_DEPS%
if not exist boost_1_79_0 (
    powershell -Command "Invoke-WebRequest https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.zip -OutFile boost_1_79_0.zip"
    7z x boost_1_79_0.zip boost_1_79_0
    mkdir boost-build
    cd boost_1_79_0
    call bootstrap
    b2 --build-type=complete --with-filesystem --with-thread --with-serialization --with-system msvc stage
)

set "BOOST_INCLUDE_DIRS=%CS_DEPS%/boost_1_79_0"

cd %CS_ROOT%