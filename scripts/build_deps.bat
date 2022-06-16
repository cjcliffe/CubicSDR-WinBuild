@echo off

cd %CS_DEPS%
if not exist libusb (
    git clone https://github.com/libusb/libusb
    cd libusb/msvc/
    devenv /Upgrade libusb_2019.sln 
    msbuild libusb_2019.sln /property:Configuration=Release /property:Platform=x64
)
set "LIBUSB_LIBRARIES=%CS_DEPS%/libusb/x64/Release/dll/libusb-1.0.lib"
set "LIBUSB_INCLUDE_DIR=%CS_DEPS%/libusb/libusb"
xcopy /yfi "%CS_DEPS_BS%\libusb\x64\Release\dll\*.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"

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
xcopy /yfi "%CS_DEPS_BS%\pthread-win32-3.0.3.1\windows\VS2019\bin\Release-Unicode-64bit-x64\*.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"


cd %CS_DEPS%
if not exist fftw-3.3.5-dll64 (
    echo Downloading fftw..
    powershell -Command "Invoke-WebRequest https://fftw.org/pub/fftw/fftw-3.3.5-dll64.zip -OutFile fftw-3.3.5-dll64.zip"
    @REM powershell Expand-Archive fftw-3.3.5-dll64.zip fftw-3.3.5-dll64
    mkdir fftw-3.3.5-dll64
    7z x fftw-3.3.5-dll64.zip -offtw-3.3.5-dll64
    cd fftw-3.3.5-dll64/
    lib /def:libfftw3f-3.def /MACHINE:x64
)
set "FFTW3_LIBRARIES=%CS_DEPS%/fftw-3.3.5-dll64/libfftw3f-3.lib"
set "FFTW3_INCLUDE_DIR=%CS_DEPS%/fftw-3.3.5-dll64/"
xcopy /yf "%CS_DEPS_BS%\fftw-3.3.5-dll64\libfftw3f-3.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"


cd %CS_DEPS%
if not exist libiconv-win-build (
    git clone https://github.com/kiyolee/libiconv-win-build.git
    cd libiconv-win-build/build-VS2022
    msbuild libiconv.sln /property:Configuration=Release /property:Platform=x64
)
set "LIBICONV_INCLUDE_DIR=%CS_DEPS%/libiconv-win-build/include"
set "LIBICONV_LIBRARY=%CS_DEPS%/libiconv-win-build/build-VS2022/x64/Release/libiconv.lib"
xcopy /yf "%CS_DEPS_BS%\libiconv-win-build\build-VS2022\x64\Release\*.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"


cd %CS_DEPS%
if not exist xz (
    git clone -c advice.detachedHead=false -b v5.2.5 https://git.tukaani.org/xz.git 
    cd xz/windows/VS2019/
    devenv /Upgrade xz_win.sln
    msbuild xz_win.sln /property:Configuration=Release /property:Platform=x64
)
set "LIBLZMA_LIBRARIES=%CS_DEPS%/xz/windows/vs2019/Release/x64/liblzma_dll/liblzma.lib"
set "LIBLZMA_INCLUDE_DIR=%CS_DEPS%/xz/src/liblzma/api"
xcopy /yf "%CS_DEPS_BS%\xz\windows\vs2019\Release\x64\liblzma_dll\*.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"


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
xcopy /yf "%CS_INSTALL_BS%\zlib\bin\*.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"


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
xcopy /yf "%CS_INSTALL_BS%\libxml2\bin\*.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"


cd %CS_DEPS%
if not exist boost_1_79_0 (
    powershell -Command "Invoke-WebRequest https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.zip -OutFile boost_1_79_0.zip"
    7z x boost_1_79_0.zip boost_1_79_0
    cd boost_1_79_0
    call bootstrap
    b2 --build-type=complete --with-filesystem --with-thread --with-serialization --with-system msvc stage
)

set "BOOST_INCLUDE_DIRS=%CS_DEPS%/boost_1_79_0"
xcopy /yf "%CS_DEPS%\boost_1_79_0\stage\lib\boost_filesystem*mt-x64-1_79.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"
xcopy /yf "%CS_DEPS%\boost_1_79_0\stage\lib\boost_thread*mt-x64-1_79.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"
xcopy /yf "%CS_DEPS%\boost_1_79_0\stage\lib\boost_serialization*mt-x64-1_79.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"
xcopy /yf "%CS_DEPS%\boost_1_79_0\stage\lib\boost_system*mt-x64-1_79.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"



cd %CS_DEPS%
if not exist wxWidgets-3.1.6 (
    echo Downloading wxWidgets..
    powershell -Command "Invoke-WebRequest https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.6/wxWidgets-3.1.6.zip -OutFile wxWidgets-3.1.6.zip"
    @REM powershell Expand-Archive wxWidgets-3.1.6.zip -DestinationPath wxWidgets-3.1.6
    mkdir wxWidgets-3.1.6
    7z x wxWidgets-3.1.6.zip -owxWidgets-3.1.6
    cd wxWidgets-3.1.6/build/msw
    msbuild wx_vc17.sln /property:Configuration=Release /property:Platform=x64
)
set WXWIDGETS_ROOT_DIR=%CS_DEPS%/wxWidgets-3.1.6

cd %CS_DEPS%
if not exist vc_redist.x64.exe (
    echo Downloading MSVC X64 redistributable..
    powershell -Command "Invoke-WebRequest https://aka.ms/vs/17/release/vc_redist.x64.exe -OutFile vc_redist.x64.exe"
)
SET BUNDLE_MSVC_REDIST=%CS_DEPS%/vc_redist.x64.exe



cd %CS_DEPS%
if not exist hamlib-w64-4.4 (
    powershell -Command "Invoke-WebRequest https://github.com/Hamlib/Hamlib/releases/download/4.4/hamlib-w64-4.4.zip -OutFile hamlib-w64-4.4.zip"
    7z x hamlib-w64-4.4.zip
    cd hamlib-w64-4.4\lib\msvc
    lib /def:libhamlib-4.def /MACHINE:x64
    cd %CS_DEPS%\hamlib-w64-4.4\include\hamlib
    @REM Not sure why this isn't protected by an ifdef?
    powershell -Command "(gc rig.h) -replace '#include <sys/time.h>', '// # include <sys/time.h>' | Out-File -encoding ASCII rig_upd.h"
    del rig.h
    move rig_upd.h rig.h
)
cd %CS_DEPS%
set "HAMLIB_LIBRARY=%CS_DEPS%/hamlib-w64-4.4/lib/msvc/libhamlib-4.lib"
set "HAMLIB_INCLUDE_DIR=%CS_DEPS%/hamlib-w64-4.4/include/"
xcopy /yf "%CS_DEPS_BS%\hamlib-w64-4.4\bin\*.dll" "%CS_INSTALL_BS%\SoapySDR\bin\"

cd %CS_ROOT%