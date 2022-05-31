@echo off

cd %CS_DEPS%

if not exist wxWidgets-3.1.6 (
    echo Downloading wxWidgets..
    powershell -Command "Invoke-WebRequest https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.6/wxWidgets-3.1.6.zip -OutFile wxWidgets-3.1.6.zip"
    powershell Expand-Archive wxWidgets-3.1.6.zip -DestinationPath wxWidgets-3.1.6
    cd wxWidgets-3.1.6/build/msw
    msbuild wx_vc17.sln /property:Configuration=Release /property:Platform=x64
)

set WXWIDGETS_ROOT_DIR=%CS_DEPS%/wxWidgets-3.1.6

cd %CS_SOURCES%
if not exist CubicSDR (
    git clone https://github.com/cjcliffe/CubicSDR 
)

cd %CS_TARGET%
if not exist CubicSDR (
    mkdir CubicSDR
    cd CubicSDR
    cmake -G %CS_GENERATOR% -A x64 %BUILD_ROOT%\sources\CubicSDR -DwxWidgets_ROOT_DIR:String=%WXWIDGETS_ROOT_DIR% -DCMAKE_INSTALL_PREFIX:PATH=%CS_INSTALL%/SoapySDR -DSoapySDR_DIR:PATH=%CS_INSTALL%/SoapySDR
    cmake --build . --config Release
    @REM cmake --build . --config Release --target install
)

cd %CS_ROOT%
