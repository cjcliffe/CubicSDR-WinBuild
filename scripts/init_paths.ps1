
$CS_ROOT=(get-location).path -replace '\\', '/'
Write-Host "Initializing Paths under $CS_ROOT.."

$BUILD_ROOT="$CS_ROOT/build"
if (-not ($BUILD_ROOT | Test-Path)) {
     $null=New-Item $BUILD_ROOT -ItemType Directory
}
Write-Host "`tBuild Path: $BUILD_ROOT"

$CS_SOURCES="$BUILD_ROOT/sources"
if (-not ($CS_SOURCES | Test-Path)) {
    $null=New-Item $CS_SOURCES -ItemType Directory
}
Write-Host "`tSources Path: $CS_SOURCES"

$CS_TARGET="$BUILD_ROOT/target"
if (-not ($CS_TARGET | Test-Path)) {
    $null=New-Item $CS_TARGET -ItemType Directory
}
Write-Host "`tTarget Path: $CS_TARGET"

$CS_INSTALL="$BUILD_ROOT/install"
if (-not ($CS_INSTALL | Test-Path)) {
    $null=New-Item $CS_INSTALL -ItemType Directory
}

$CS_DEPS="$BUILD_ROOT\dependencies"
if (-not ($CS_DEPS | Test-Path)) {
    $null=New-Item $CS_DEPS -ItemType Directory
}
Write-Host "`tDependencies Path: $CS_TARGET"

if (-not $env:Path -contains "7-Zip") {
    $SZ64_PATH="C:\Program Files\7-Zip"
    if ($SZ64_PATH | Test-Path) {
        Write-Host "`7-Zip Found: $SZ64_PATH"
        $env:Path="$env:Path;$SZ64_PATH;"
    }
    $SZX86_PATH="C:\Program Files (x86)\7-Zip"
    if ($SZX86_PATH | Test-Path) {
        Write-Host "`7-Zip Found: $SZX86_PATH"
        $env:Path="$env:Path;$SZX86_PATH;"
    }
}
