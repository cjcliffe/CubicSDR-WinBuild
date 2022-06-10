@echo off

if not exist build (
    mkdir build
)
set "CS_ROOT=%CD%" 
call set CS_ROOT=%%CS_ROOT:\=/%%
set "BUILD_ROOT=%CS_ROOT%/build"
call set BUILD_ROOT_BS=%%BUILD_ROOT:/=\%%

cd %BUILD_ROOT%
if not exist sources (
    mkdir sources
)
set "CS_SOURCES=%BUILD_ROOT%/sources"
call set CS_SOURCES_BS=%%CS_SOURCES:/=\%%

if not exist target (
    mkdir target
)
set "CS_TARGET=%BUILD_ROOT%/target"
call set CS_TARGET_BS=%%CS_TARGET:/=\%%

if not exist install (
    mkdir install
)
set "CS_INSTALL=%BUILD_ROOT%/install"
call set CS_INSTALL_BS=%%CS_INSTALL:/=\%%

if not exist dependencies (
    mkdir dependencies
)
set "CS_DEPS=%BUILD_ROOT%/dependencies"
call set CS_DEPS_BS=%%CS_DEPS:/=\%%

set "path=%path%;C:\Program Files\7-Zip;C:\Program Files (x86)\7-Zip"

cd %CS_ROOT%