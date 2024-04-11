# CubicSDR-WinBuild
CubicSDR Windows Install Builder


## Requirements:
 - [Visual Studio Community 2022](https://visualstudio.microsoft.com/vs/community/) 
 - [Nullsoft Scriptable Install System](https://nsis.sourceforge.io/Download)
 - [7-zip](https://www.7-zip.org/)
 - [Python](https://www.python.org/downloads/release/python-3105/)
 - [SDRPlay RSP API](https://www.sdrplay.com/software/SDRplay_RSP_API-Windows-3.14.exe)
 - [CMake](https://cmake.org/install/)

Notes:
 - Install Python with option 'Add to PATH' or add manually


## Building via Developer PowerShell for VS2022
 - Clone this repository to the location you want to build and run build script:
     - `. .\build.ps1`
 - By default it will build type Release, architecture x64, options are:
     - `. \build.ps1 Release x64`
     - `. \build.ps1 Debug x64`
     - `. \build.ps1 Release Win32`
     - `. \build.ps1 Debug Win32`
 
