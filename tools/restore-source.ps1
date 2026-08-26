$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$bundleDir = Join-Path $repoRoot 'source\bundle'
$parts = Get-ChildItem -Path (Join-Path $bundleDir 'part-*.b64') | Sort-Object Name

if (-not $parts -or $parts.Count -eq 0) {
    throw 'Trade Journal source bundle was not found.'
}

$b64 = ($parts | ForEach-Object { (Get-Content $_.FullName -Raw).Trim() }) -join ''
$bytes = [Convert]::FromBase64String($b64)
$tmpZip = Join-Path $repoRoot '.source-bootstrap.zip'

[IO.File]::WriteAllBytes($tmpZip, $bytes)
try {
    & tar.exe -xf $tmpZip -C $repoRoot
    if ($LASTEXITCODE -ne 0) {
        throw "tar.exe failed to restore the source bundle (exit $LASTEXITCODE)."
    }
}
finally {
    if (Test-Path $tmpZip) { Remove-Item $tmpZip -Force }
}

$required = @(
    'main.go',
    'sqlite_windows.go',
    'go.mod',
    'web\index.html',
    'web\app.js',
    'web\styles.css'
)
foreach ($file in $required) {
    if (-not (Test-Path (Join-Path $repoRoot $file))) {
        throw "Restored source is missing required file: $file"
    }
}

Write-Host 'Trade Journal source restored successfully.'
