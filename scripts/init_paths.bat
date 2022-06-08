@echo off

if not exist build (
    mkdir build
)
set "CS_ROOT=%CD%" 
call set CS_ROOT=%%CS_ROOT:\=/%%
set "BUILD_ROOT=%CS_ROOT%/build"

cd %BUILD_ROOT%
if not exist sources (
    mkdir sources
)
set "CS_SOURCES=%BUILD_ROOT%/sources"

if not exist target (
    mkdir target
)
set "CS_TARGET=%BUILD_ROOT%/target"

if not exist install (
    mkdir install
)
set "CS_INSTALL=%BUILD_ROOT%/install"

if not exist dependencies (
    mkdir dependencies
)
set "CS_DEPS=%BUILD_ROOT%/dependencies"

set "path=%path%;C:\Program Files\7-Zip;C:\Program Files (x86)\7-Zip"

cd %CS_ROOT%