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
    powershell Expand-Archive pthread_win.zip .
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
    powershell Expand-Archive fftw-3.3.5-dll64.zip fftw-3.3.5-dll64
    cd fftw-3.3.5-dll64/
    lib /def:libfftw3f-3.def /MACHINE:x64
)
set "FFTW3_LIBRARIES=%CS_DEPS%/fftw-3.3.5-dll64/libfftw3f-3.lib"

cd %CS_ROOT%