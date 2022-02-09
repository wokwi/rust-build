# Helper script to perform repackaging of Windows release
[CmdletBinding()]
param (
    [Parameter()]
    [String]
    [ValidateSet("x86_64-pc-windows-msvc", "x86_64-pc-windows-gnu")]
    $HostTripple="x86_64-pc-windows-msvc",
    [String]
    $ReleaseVersion="1.58.0.0"
,    [String]
    $RustVersion="1.58.0-dev"
)

# Stop on error
$ErrorActionPreference = "Stop"

"Processing configuration:"
"-HostTriple    = ${HostTriple}"
"-ReleaseVersion = ${ReleaseVersion}"
"-RustVersion    = ${RustVersion}"

if (Test-Path -Path esp -PathType Container) {
    Remove-Item -Recurse -Force -Path esp
    rm *.tar
}

mkdir esp
7z e rust-${RustVersion}-${HostTriple}.tar.xz
7z x rust-${RustVersion}-${HostTriple}.tar
pushd rust-${RustVersion}-${HostTriple}
cp -Recurse .\rustc\bin ..\esp\
cp -Recurse .\rustc\lib ..\esp\
cp -Recurse .\rustc\share ..\esp\
cp -ErrorAction SilentlyContinue -Recurse .\rust-std-${HostTriple}\lib\* ..\esp\lib\
popd
7z e rust-src-${RustVersion}.tar.xz
7z x rust-src-${RustVersion}.tar
pushd rust-src-${RustVersion}
cp -ErrorAction SilentlyContinue -Recurse .\rust-src\lib\* ..\esp\lib\
popd

# Clean up debug files
Get-ChildItem -Path .\ -Filter *.pdb -Recurse -File -Name| ForEach-Object {
    "Removing: $_"
    Remove-Item -Path $_
}

7z a rust-${ReleaseVersion}-${HostTriple}.zip esp/
