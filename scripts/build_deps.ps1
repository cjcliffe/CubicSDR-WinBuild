
$LIBUSB_SOURCES="$CS_DEPS/libusb"
$LIBUSB_PROJECT="$LIBUSB_SOURCES/msvc/libusb.sln"
if (-not ($LIBUSB_SOURCES | Test-Path)) {
    git clone https://github.com/libusb/libusb $LIBUSB_SOURCES
    msbuild $LIBUSB_PROJECT /property:Configuration=Release /property:Platform=x64
}
$LIBUSB_LIBRARIES="$CS_DEPS/libusb/build/v143/x64/Release/dll/libusb-1.0.lib"
$LIBUSB_INCLUDE_DIR="$CS_DEPS/libusb/libusb"
Copy-Item -Path "$CS_DEPS/libusb/build/v143/x64/Release/dll/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$PTHREADS_ZIP="$CS_DEPS/pthread_win.zip"
$PTHREADS_SOURCES="$CS_DEPS/pthread-win32-3.0.3.1"
$PTHREADS_PROJECT="$PTHREADS_SOURCES/windows/VS2019/pthread.2019.sln"
if (-not ($PTHREADS_SOURCES | Test-Path)) {
    Invoke-WebRequest https://github.com/GerHobbelt/pthread-win32/archive/refs/tags/v3.0.3.1.zip -OutFile $PTHREADS_ZIP
    # Expand-Archive $PTHREADS_ZIP $CS_DEPS
    7z x $PTHREADS_ZIP -o"$CS_DEPS"
    devenv /Upgrade $PTHREADS_PROJECT
    msbuild $PTHREADS_PROJECT /property:Configuration=Release /property:Platform=x64
}
$PTHREADS_LIBRARIES="$CS_DEPS/pthread-win32-3.0.3.1/windows/VS2019/bin/Release-Unicode-64bit-x64/pthread.lib"
$PTHREADS_INCLUDE_DIR="$CS_DEPS/pthread-win32-3.0.3.1"
Copy-Item -Path "$CS_DEPS/pthread-win32-3.0.3.1/windows/VS2019/bin/Release-Unicode-64bit-x64/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$FFTW_ZIP="$CS_DEPS/fftw-3.3.5-dll64.zip"
$FFTW_BINS="$CS_DEPS/fftw-3.3.5-dll64"
if (-not ($FFTW_BINS | Test-Path)) {
    Invoke-WebRequest https://fftw.org/pub/fftw/fftw-3.3.5-dll64.zip -OutFile $FFTW_ZIP
    # Expand-Archive $FFTW_ZIP $FFTW_BINS
    7z x $FFTW_ZIP -o"$FFTW_BINS"
    Set-Location $FFTW_BINS
    lib /def:libfftw3f-3.def /MACHINE:x64
    Set-Location $CS_ROOT
}
$FFTW3_LIBRARIES="$CS_DEPS/fftw-3.3.5-dll64/libfftw3f-3.lib"
$FFTW3_INCLUDE_DIR="$CS_DEPS/fftw-3.3.5-dll64/"
Copy-Item -Path "$CS_DEPS/fftw-3.3.5-dll64/libfftw3f-3.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$ICONV_SOURCES="$CS_DEPS/libiconv-win-build"
$ICONV_PROJECT="$ICONV_SOURCES/build-VS2022/libiconv.sln"
if (-not ($ICONV_SOURCES | Test-Path)) {
    git clone https://github.com/kiyolee/libiconv-win-build.git $ICONV_SOURCES
    msbuild $ICONV_PROJECT /property:Configuration=Release /property:Platform=x64   
}
$LIBICONV_INCLUDE_DIR="$ICONV_SOURCES/include"
$LIBICONV_LIBRARY="$ICONV_SOURCES/build-VS2022/x64/Release/libiconv.lib"
Copy-Item -Path "$CS_DEPS/libiconv-win-build/build-VS2022/x64/Release/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$XZ_SOURCES="$CS_DEPS/xz"
$XZ_PROJECT="$XZ_SOURCES/windows/VS2019/xz_win.sln"
if (-not ($XZ_SOURCES | Test-Path)) {
    git clone -c advice.detachedHead=false -b v5.2.5 https://git.tukaani.org/xz.git $XZ_SOURCES
    devenv /Upgrade $XZ_PROJECT
    msbuild $XZ_PROJECT /property:Configuration=Release /property:Platform=x64
}
$LIBLZMA_LIBRARIES="$XZ_SOURCES/windows/vs2019/Release/x64/liblzma_dll/liblzma.lib"
$LIBLZMA_INCLUDE_DIR="$XZ_SOURCES/src/liblzma/api"
Copy-Item -Path "$CS_DEPS/xz/windows/vs2019/Release/x64/liblzma_dll/*.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"


$ZLIB_SOURCES="$CS_SOURCES/zlib"
if (-not ($ZLIB_SOURCES | Test-Path)) {
    git clone https://github.com/madler/zlib $ZLIB_SOURCES
}
$ZLIB_TARGET="$CS_TARGET/zlib"
$ZLIB_INSTALL="$CS_INSTALL/zlib"
if (-not ($ZLIB_TARGET | Test-Path)) {
    $null=New-Item $ZLIB_TARGET -ItemType Directory
    cmake -B $ZLIB_TARGET -G $CS_GENERATOR -A x64 $ZLIB_SOURCES -DCMAKE_INSTALL_PREFIX="$ZLIB_INSTALL"
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
    cmake -B $LIBXML_TARGET -G $CS_GENERATOR -A x64 $LIBXML_SOURCES `
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


$BOOST_ZIP="$CS_DEPS/boost_1_79_0.zip"
$BOOST_SOURCES="$CS_DEPS/boost_1_79_0"
if (-not ($BOOST_SOURCES | Test-Path)) {
    Invoke-WebRequest https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.zip -OutFile $BOOST_ZIP
    # Expand-Archive $BOOST_ZIP $BOOST_SOURCES
    7z x $BOOST_ZIP -o"$CS_DEPS"
    Set-Location $BOOST_SOURCES
    ./bootstrap
    ./b2 --build-type=complete --with-filesystem --with-thread --with-serialization --with-system msvc stage
    Set-Location $CS_ROOT
}

$BOOST_INCLUDE_DIRS="$CS_DEPS/boost_1_79_0"
Copy-Item -Path "$BOOST_SOURCES\stage\lib\boost_filesystem*mt-x64-1_79.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"
Copy-Item -Path "$BOOST_SOURCES\stage\lib\boost_thread*mt-x64-1_79.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"
Copy-Item -Path "$BOOST_SOURCES\stage\lib\boost_serialization*mt-x64-1_79.dll"-Destination "$CS_INSTALL/SoapySDR/bin/"
Copy-Item -Path "$BOOST_SOURCES\stage\lib\boost_system*mt-x64-1_79.dll" -Destination "$CS_INSTALL/SoapySDR/bin/"



$WXWIDGETS_ZIP="$CS_DEPS/wxWidgets-3.1.6.zip"
$WXWIDGETS_SOURCES="$CS_DEPS/wxWidgets-3.1.6"
$WXWIDGETS_PROJECT="$WXWIDGETS_SOURCES/build/msw/wx_vc17.sln"
if (-not ($WXWIDGETS_SOURCES | Test-Path)) {
    Invoke-WebRequest https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.6/wxWidgets-3.1.6.zip -OutFile $WXWIDGETS_ZIP
    # Expand-Archive $WXWIDGETS_ZIP -DestinationPath wxWidgets-3.1.6
    7z x $WXWIDGETS_ZIP -o"$WXWIDGETS_SOURCES"
    msbuild $WXWIDGETS_PROJECT /property:Configuration=Release /property:Platform=x64
}
$WXWIDGETS_ROOT_DIR="$CS_DEPS/wxWidgets-3.1.6"


$BUNDLE_MSVC_REDIST="$CS_DEPS/vc_redist.x64.exe"
if (-not ($BUNDLE_MSVC_REDIST | Test-Path)) {
    Invoke-WebRequest https://aka.ms/vs/17/release/vc_redist.x64.exe -OutFile "$BUNDLE_MSVC_REDIST"
}


$HAMLIB_ZIP="$CS_DEPS/hamlib-w64-4.4.zip"
$HAMLIB_SOURCES="$CS_DEPS/hamlib-w64-4.4"
$HAMLIB_PROJECT="$HAMLIB_SOURCES/hamlib-w64-4.4/lib/msvc"
if (-not ($HAMLIB_SOURCES | Test-Path)) {
    Invoke-WebRequest https://github.com/Hamlib/Hamlib/releases/download/4.4/hamlib-w64-4.4.zip -OutFile $HAMLIB_ZIP
    7z x $HAMLIB_ZIP -o"$CS_DEPS"
    Set-Location $HAMLIB_SOURCES/lib/msvc
    lib /def:libhamlib-4.def /MACHINE:x64
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
