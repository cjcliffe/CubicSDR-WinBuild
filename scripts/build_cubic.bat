@echo off

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


cd %CS_SOURCES%
if not exist CubicSDR (
    git clone https://github.com/cjcliffe/CubicSDR 
)

cd %CS_TARGET%
if not exist CubicSDR (
    mkdir CubicSDR
)
cmake -B CubicSDR -G %CS_GENERATOR% -A x64 %BUILD_ROOT%\sources\CubicSDR^
    -DwxWidgets_ROOT_DIR:String=%WXWIDGETS_ROOT_DIR%^
    -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/CubicSDR^
    -DSoapySDR_DIR:PATH=%SOAPY_SDR_ROOT%/cmake^
    -DSOAPY_SDR_ROOT:PATH=%SOAPY_SDR_ROOT%^
    -DBUNDLE_MSVC_REDIST:PAtH=%BUNDLE_MSVC_REDIST%^
    -DBUILD_INSTALLER=ON -DBUNDLE_SOAPY_MODS=ON
cmake --build CubicSDR --config Release --target install

cd CubicSDR
cpack CubicSDR

cd %CS_ROOT%
