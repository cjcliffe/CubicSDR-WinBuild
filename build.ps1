$CS_GENERATOR="Visual Studio 17 2022"

# Initialize build paths
. .\scripts\init_paths.ps1

# Build SoapySDR
. .\scripts\build_soapy.ps1
# Build Common Dependencies
. .\scripts\build_deps.ps1

# Build Device-Specific Modules
. .\scripts\build_module_airspy.ps1
. .\scripts\build_module_airspyhf.ps1
. .\scripts\build_module_audio.ps1
. .\scripts\build_module_hackrf.ps1
. .\scripts\build_module_pluto.ps1
. .\scripts\build_module_netsdr.ps1
. .\scripts\build_module_remote.ps1
. .\scripts\build_module_redpitaya.ps1
. .\scripts\build_module_rtlsdr.ps1
. .\scripts\build_module_sdrplay.ps1
. .\scripts\build_module_uhd.ps1

# @REM call scripts\build_module_bladerf

# Build Application Installer
. .\scripts\build_cubic.ps1

Write-Host "Done"