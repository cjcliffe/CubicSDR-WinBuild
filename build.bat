@echo off
cls 

setlocal

set CS_GENERATOR="Visual Studio 17 2022"

call scripts\init_paths

call scripts\build_soapy
call scripts\build_deps
call scripts\build_module_airspy
call scripts\build_module_airspyhf
call scripts\build_module_audio
@REM call scripts\build_module_bladerf
call scripts\build_module_hackrf
@REM call scripts\build_module_netsdr
call scripts\build_module_pluto
call scripts\build_module_remote
call scripts\build_module_rtlsdr
call scripts\build_module_redpitaya
call scripts\build_module_sdrplay
call scripts\build_module_uhd

call scripts\build_cubic

endlocal