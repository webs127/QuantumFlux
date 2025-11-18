<#
This script clones the PQClean repository and copies the Kyber768
implementation source files into the plugin directories for Android and iOS.

Usage (run from plugin root):
  powershell -ExecutionPolicy Bypass -File .\scripts\fetch_pqclean.ps1

Note: Requires git and network access.
#>

param(
    [string]$Repo = 'https://github.com/PQClean/PQClean.git',
    [string]$Tmp = "$env:TEMP\pqclean_tmp"
)

Write-Host "Cloning PQClean into $Tmp ..."
if (Test-Path $Tmp) { Remove-Item -Recurse -Force $Tmp }
git clone --depth 1 $Repo $Tmp
if ($LASTEXITCODE -ne 0) { throw "git clone failed" }

Write-Host "Copying the portable 'clean' Kyber768 implementation (if present)..."
$cleanPath = Join-Path $Tmp 'crypto_kem\ml-kem-768\clean'
if (-not (Test-Path $cleanPath)) { throw "Expected clean implementation not found at $cleanPath" }

$destAndroidRoot = Join-Path $PSScriptRoot '..\android\src\main\cpp\pqclean\ml-kem-768\clean' | Resolve-Path -Relative
$destIosRoot = Join-Path $PSScriptRoot '..\..\ios\Classes\pqclean\ml-kem-768\clean' | Resolve-Path -Relative

Get-ChildItem -Path $cleanPath -Include *.c,*.h -Recurse | ForEach-Object {
    $rel = $_.FullName.Substring($cleanPath.Length).TrimStart('\')
    $destA = Join-Path (Convert-Path "$PSScriptRoot\..\android\src\main\cpp\pqclean\ml-kem-768\clean") $rel
    $destI = Join-Path (Convert-Path "$PSScriptRoot\..\..\ios\Classes\pqclean\ml-kem-768\clean") $rel
    New-Item -ItemType Directory -Force -Path (Split-Path $destA) | Out-Null
    Copy-Item -Force -Path $_.FullName -Destination $destA
    New-Item -ItemType Directory -Force -Path (Split-Path $destI) | Out-Null
    Copy-Item -Force -Path $_.FullName -Destination $destI
}

Write-Host "PQClean Kyber768 sources copied. Cleaning up..."
Remove-Item -Recurse -Force $Tmp
Write-Host "Done. Please run a platform build (Android/iOS) to compile the native library."
