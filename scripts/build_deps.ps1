
$LIBUSB_SOURCES="$CS_DEPS/libusb"
$LIBUSB_PROJECT="$LIBUSB_SOURCES/msvc/libusb.sln"
if (-not ($LIBUSB_SOURCES | Test-Path)) {
    git clone https://github.com/libusb/libusb $LIBUSB_SOURCES
    msbuild $LIBUSB_PROJECT /property:Configuration=Release /property:Platform=$CS_BUILD_ARCH
}
$LIBUSB_LIBRARIES="$CS_DEPS/libusb/build/v143/$CS_BUILD_ARCH/Release/dll/libusb-1.0.lib"
$LIBUSB_INCLUDE_DIR="$CS_DEPS/libusb/libusb"
Copy-Item -Path "$CS_DEPS/libusb/build/v143/$CS_BUILD_ARCH/Release/dll/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$PTHREADS_URL="https://github.com/GerHobbelt/pthread-win32/archive/refs/tags/v3.0.3.1.zip"
$PTHREADS_SOURCES="$CS_DEPS/pthread-win32-3.0.3.1"
switch ($CS_BUILD_ARCH) {
    "x64" { $PTHREADS_BUILD_DIR="$PTHREADS_SOURCES/windows/VS2019/bin/Release-Unicode-64bit-x64" }
    "Win32" { $PTHREADS_BUILD_DIR="$PTHREADS_SOURCES/windows/VS2019/bin/Release-Unicode-32bit-x86" }
}
$PTHREADS_ZIP="$CS_DEPS/pthread_win.zip"
$PTHREADS_PROJECT="$PTHREADS_SOURCES/windows/VS2019/pthread.2019.sln"
if (-not ($PTHREADS_SOURCES | Test-Path)) {
    Invoke-WebRequest $PTHREADS_URL -OutFile $PTHREADS_ZIP
    # Expand-Archive $PTHREADS_ZIP $CS_DEPS
    & $SZ_CMD x $PTHREADS_ZIP -o"$CS_DEPS"
    devenv /Upgrade $PTHREADS_PROJECT
    msbuild $PTHREADS_PROJECT /property:Configuration=Release /property:Platform=$CS_BUILD_ARCH
}
$PTHREADS_LIBRARIES="$PTHREADS_BUILD_DIR/pthread.lib"
$PTHREADS_INCLUDE_DIR="$PTHREADS_SOURCES"
Copy-Item -Path "$PTHREADS_BUILD_DIR/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


switch ($CS_BUILD_ARCH) {
    "x64" { 
        $FFTW_ZIP="$CS_DEPS/fftw-3.3.5-dll64.zip"
        $FFTW_BINS="$CS_DEPS/fftw-3.3.5-dll64"
        $FFTW_URL="https://fftw.org/pub/fftw/fftw-3.3.5-dll64.zip"
        $LIBTOOL_ARCH="X64"
    }
    "Win32" { 
        $FFTW_ZIP="$CS_DEPS/fftw-3.3.5-dll32.zip"
        $FFTW_BINS="$CS_DEPS/fftw-3.3.5-dll32"
        $FFTW_URL="https://fftw.org/pub/fftw/fftw-3.3.5-dll32.zip"
        $LIBTOOL_ARCH="X86"
    }
}
if (-not ($FFTW_BINS | Test-Path)) {
    Invoke-WebRequest $FFTW_URL -OutFile $FFTW_ZIP
    # Expand-Archive $FFTW_ZIP $FFTW_BINS
    & $SZ_CMD x $FFTW_ZIP -o"$FFTW_BINS"
    Set-Location $FFTW_BINS
    lib /def:libfftw3f-3.def /MACHINE:$LIBTOOL_ARCH
    Set-Location $CS_ROOT
}
$FFTW3_LIBRARIES="$FFTW_BINS/libfftw3f-3.lib"
$FFTW3_INCLUDE_DIR="$FFTW_BINS/"
Copy-Item -Path "$FFTW_BINS/libfftw3f-3.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$ICONV_SOURCES="$CS_DEPS/libiconv-win-build"
$ICONV_PROJECT="$ICONV_SOURCES/build-VS2022/libiconv.sln"


switch ($CS_BUILD_ARCH) {
    "x64" { $ICONV_BUILD_PATH="$CS_BUILD_ARCH/" }
    "Win32" { $ICONV_BUILD_PATH="" }
}
if (-not ($ICONV_SOURCES | Test-Path)) {
    git clone https://github.com/kiyolee/libiconv-win-build.git $ICONV_SOURCES
    msbuild $ICONV_PROJECT /property:Configuration=Release /property:Platform=$CS_BUILD_ARCH   
}
$LIBICONV_INCLUDE_DIR="$ICONV_SOURCES/include"
$LIBICONV_LIBRARY="$ICONV_SOURCES/build-VS2022/$ICONV_BUILD_PATH/Release/libiconv.lib"
Copy-Item -Path "$CS_DEPS/libiconv-win-build/build-VS2022/$ICONV_BUILD_PATH/Release/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$XZ_SOURCES="$CS_DEPS/xz"
$XZ_PROJECT="$XZ_SOURCES/windows/VS2019/xz_win.sln"
if (-not ($XZ_SOURCES | Test-Path)) {
    git clone -c advice.detachedHead=false -b v5.2.5 https://git.tukaani.org/xz.git $XZ_SOURCES
    devenv /Upgrade $XZ_PROJECT
    msbuild $XZ_PROJECT /property:Configuration=Release /property:Platform=$CS_BUILD_ARCH
}
$LIBLZMA_LIBRARIES="$XZ_SOURCES/windows/vs2019/Release/$CS_BUILD_ARCH/liblzma_dll/liblzma.lib"
$LIBLZMA_INCLUDE_DIR="$XZ_SOURCES/src/liblzma/api"
Copy-Item -Path "$CS_DEPS/xz/windows/vs2019/Release/$CS_BUILD_ARCH/liblzma_dll/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$ZLIB_SOURCES="$CS_SOURCES/zlib"
if (-not ($ZLIB_SOURCES | Test-Path)) {
    git clone https://github.com/madler/zlib $ZLIB_SOURCES
}
$ZLIB_TARGET="$CS_TARGET/zlib"
$ZLIB_INSTALL="$CS_INSTALL/zlib"
if (-not ($ZLIB_TARGET | Test-Path)) {
    $null=New-Item $ZLIB_TARGET -ItemType Directory
    cmake -B $ZLIB_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $ZLIB_SOURCES -DCMAKE_INSTALL_PREFIX="$ZLIB_INSTALL"
    cmake --build $ZLIB_TARGET --config Release --target install
}
$ZLIB_LIBRARY="$ZLIB_INSTALL/lib/zlib.lib"
$ZLIB_INCLUDE_DIR="$ZLIB_INSTALL/include"
Copy-Item -Path "$CS_INSTALL/zlib/bin/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$LIBXML_SOURCES="$CS_SOURCES/libxml2"
if (-not ($LIBXML_SOURCES | Test-Path)) {
    git clone https://gitlab.gnome.org/GNOME/libxml2.git $LIBXML_SOURCES
}

$LIBXML_TARGET="$CS_TARGET/libxml2"
$LIBXML_INSTALL="$CS_INSTALL/libxml2"
if (-not ($LIBXML_TARGET | Test-Path)) {
    $null=New-Item $LIBXML_TARGET -ItemType Directory
    cmake -B $LIBXML_TARGET -G $CS_GENERATOR -A $CS_BUILD_ARCH $LIBXML_SOURCES `
        -DCMAKE_INSTALL_PREFIX="$LIBXML_INSTALL" `
        -DIconv_INCLUDE_DIR:PATH="$LIBICONV_INCLUDE_DIR" `
        -DIconv_LIBRARY:FILEPATH="$LIBICONV_LIBRARY" `
        -DLIBLZMA_LIBRARY="$LIBLZMA_LIBRARIES" `
        -DLIBLZMA_INCLUDE_DIR="$LIBLZMA_INCLUDE_DIR" `
        -DLIBXML2_WITH_PYTHON=OFF `
        -DZLIB_INCLUDE_DIR="$ZLIB_INCLUDE_DIR" `
        -DZLIB_LIBRARY="$ZLIB_LIBRARY"
    cmake --build $LIBXML_TARGET --config Release --target install
}
$LIBXML2_LIBRARY="$CS_INSTALL/libxml2/lib/libxml2.lib"
$LIBXML2_INCLUDE_DIR="$CS_INSTALL/libxml2/include/libxml2;$LIBICONV_INCLUDE_DIR"
Copy-Item -Path "$CS_INSTALL/libxml2/bin/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


switch ($CS_BUILD_ARCH) {
    "x64" { $B2_ARCH = "address-model=64" }
    "Win32" { $B2_ARCH = "address-model=32" }
}
$BOOST_URL="https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.zip"
$BOOST_ZIP="$CS_DEPS/boost_1_79_0.zip"
$BOOST_SOURCES="$CS_DEPS/boost_1_79_0"
$BOOST_INCLUDE_DIRS="$BOOST_SOURCES"
if (-not ($BOOST_ZIP | Test-Path)) {
    Invoke-WebRequest $BOOST_URL -OutFile $BOOST_ZIP
}
if (-not ($BOOST_SOURCES | Test-Path)) {
    # Expand-Archive $BOOST_ZIP $BOOST_SOURCES
    & $SZ_CMD x $BOOST_ZIP -o"$CS_DEPS"
    Set-Location $BOOST_SOURCES
    ./bootstrap
    ./b2 --build-type=complete --with-filesystem --with-thread --with-serialization --with-system msvc stage $B2_ARCH
    Set-Location $CS_ROOT
}
Copy-Item -Path "$BOOST_SOURCES\stage\lib\boost_filesystem*mt-*-1_79.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"
Copy-Item -Path "$BOOST_SOURCES\stage\lib\boost_thread*mt-*-1_79.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"
Copy-Item -Path "$BOOST_SOURCES\stage\lib\boost_serialization*mt-*-1_79.dll"-Destination "$CS_INSTALL/SoapySDR/bin/"
Copy-Item -Path "$BOOST_SOURCES\stage\lib\boost_system*mt-*-1_79.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$WXWIDGETS_ZIP="$CS_DEPS/wxWidgets-3.2.1.zip"
$WXWIDGETS_SOURCES="$CS_DEPS/wxWidgets-3.2.1"
$WXWIDGETS_PROJECT="$WXWIDGETS_SOURCES/build/msw/wx_vc17.sln"
if (-not ($WXWIDGETS_SOURCES | Test-Path)) {
    Invoke-WebRequest https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.1/wxWidgets-3.2.1.zip -OutFile $WXWIDGETS_ZIP
    # Expand-Archive $WXWIDGETS_ZIP -DestinationPath wxWidgets-3.2.1
    & $SZ_CMD x $WXWIDGETS_ZIP -o"$WXWIDGETS_SOURCES"
    msbuild $WXWIDGETS_PROJECT /property:Configuration=$CS_BUILD_TYPE /property:Platform=$CS_BUILD_ARCH
}
$WXWIDGETS_ROOT_DIR="$CS_DEPS/wxWidgets-3.2.1"

switch ($CS_BUILD_ARCH) {
    "x64" { 
        $BUNDLE_MSVC_DEDIST_URL="https://aka.ms/vs/17/release/vc_redist.x64.exe"
        $BUNDLE_MSVC_REDIST="$CS_DEPS/vc_redist.x64.exe"        
    }
    "Win32" { 
        $BUNDLE_MSVC_DEDIST_URL="https://aka.ms/vs/17/release/vc_redist.x86.exe"        
        $BUNDLE_MSVC_REDIST="$CS_DEPS/vc_redist.x86.exe"
    }
}
if (-not ($BUNDLE_MSVC_REDIST | Test-Path)) {
    Invoke-WebRequest $BUNDLE_MSVC_DEDIST_URL -OutFile "$BUNDLE_MSVC_REDIST"
}

switch ($CS_BUILD_ARCH) {
    "x64" { 
        $HAMLIB_URL="https://github.com/Hamlib/Hamlib/releases/download/4.4/hamlib-w64-4.4.zip"
        $HAMLIB_ZIP="$CS_DEPS/hamlib-w64-4.4.zip"
        $HAMLIB_SOURCES="$CS_DEPS/hamlib-w64-4.4"
        $HAMLIB_PROJECT="$HAMLIB_SOURCES/hamlib-w64-4.4/lib/msvc"
    }
    "Win32" { 
        $HAMLIB_URL="https://github.com/Hamlib/Hamlib/releases/download/4.4/hamlib-w32-4.4.zip"
        $HAMLIB_ZIP="$CS_DEPS/hamlib-w32-4.4.zip"
        $HAMLIB_SOURCES="$CS_DEPS/hamlib-w32-4.4"
        $HAMLIB_PROJECT="$HAMLIB_SOURCES/hamlib-w32-4.4/lib/msvc"
    }
}

if (-not ($HAMLIB_SOURCES | Test-Path)) {
    Invoke-WebRequest $HAMLIB_URL -OutFile $HAMLIB_ZIP
    & $SZ_CMD x $HAMLIB_ZIP -o"$CS_DEPS"
    Set-Location $HAMLIB_SOURCES/lib/msvc
    lib /def:libhamlib-4.def /MACHINE:$CS_BUILD_ARCH
    Set-Location $HAMLIB_SOURCES/include/hamlib
    # Not sure why this isn't protected by an ifdef?
    (Get-Content rig.h) -replace '#include <sys/time.h>', '// # include <sys/time.h>' | Out-File -encoding ASCII rig_upd.h
    Remove-Item rig.h
    Move-Item rig_upd.h rig.h
    Set-Location $CS_ROOT
}
$HAMLIB_LIBRARY="$HAMLIB_SOURCES/lib/msvc/libhamlib-4.lib"
$HAMLIB_INCLUDE_DIR="$HAMLIB_SOURCES/include/"
Copy-Item -Path "$HAMLIB_SOURCES/bin/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"
