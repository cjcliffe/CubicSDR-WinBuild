@echo off

setlocal

set CS_GENERATOR="Visual Studio 17 2022"

call scripts\init_paths

call scripts\build_soapy
call scripts\build_deps
call scripts\build_module_airspy
call scripts\build_module_airspyhf
call scripts\build_module_audio
call scripts\build_module_hackrf
call scripts\build_module_rtlsdr

call scripts\build_cubic

endlocal