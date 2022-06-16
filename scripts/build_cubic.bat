@echo off

cd %CS_SOURCES%
if not exist CubicSDR (
    git clone -b winbuild-updates https://github.com/cjcliffe/CubicSDR 
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
    -DBUNDLE_MSVC_REDIST:PATH=%BUNDLE_MSVC_REDIST%^
    -DHAMLIB_LIBRARY:PATH=%HAMLIB_LIBRARY% -DHAMLIB_INCLUDE_DIR=%HAMLIB_INCLUDE_DIR%^
    -DBUILD_INSTALLER=ON -DBUNDLE_SOAPY_MODS=ON -DUSE_HAMLIB=ON
cmake --build CubicSDR --config Release --target install

cd CubicSDR
cpack CubicSDR

cd %CS_ROOT%
