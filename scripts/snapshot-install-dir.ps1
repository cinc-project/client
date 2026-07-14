# Capture the omnibus install directory as a CI artifact when the job has
# failed, so we can inspect the partial build state after the fact.
#
# This script is intended to be called as the FIRST step of an `after_script`
# on Windows GitLab CI jobs, before any cleanup that would remove
# `C:\cinc-project`.
#
# Behavior:
#   - No-op unless $env:CI_JOB_STATUS = 'failed'.
#   - Writes a 7z archive to ${CI_PROJECT_DIR}\data\debug\install-dir-<platform>.7z
#     (falls back to .zip via Compress-Archive if 7z.exe is unavailable).
#   - Best-effort: never throws.

$ErrorActionPreference = "Continue"

$installDir  = if ($env:INSTALL_DIR) { $env:INSTALL_DIR } else { 'C:\cinc-project\cinc' }
$projectDir  = if ($env:CI_PROJECT_DIR) { $env:CI_PROJECT_DIR } else { (Get-Location).Path }
$jobStatus   = if ($env:CI_JOB_STATUS) { $env:CI_JOB_STATUS } else { 'unknown' }
$platformTag = if ($env:PLATFORM_VER) { $env:PLATFORM_VER } elseif ($env:CI_JOB_NAME) { $env:CI_JOB_NAME } else { 'unknown' }
$platformTag = ($platformTag -replace '[^A-Za-z0-9._-]', '_')

if ($jobStatus -ne 'failed') {
  Write-Host "snapshot-install-dir: job status is '$jobStatus', skipping snapshot"
  exit 0
}

if (-not (Test-Path -LiteralPath $installDir)) {
  Write-Host "snapshot-install-dir: install dir '$installDir' does not exist, nothing to capture"
  exit 0
}

$debugDir = Join-Path $projectDir 'data\debug'
try {
  New-Item -ItemType Directory -Force -Path $debugDir | Out-Null
} catch {
  Write-Host "snapshot-install-dir: failed to create $debugDir, aborting: $_"
  exit 0
}

$archiveBase = "install-dir-$platformTag"
$sevenZip    = Get-Command 7z.exe -ErrorAction SilentlyContinue

try {
  if ($sevenZip) {
    $archivePath = Join-Path $debugDir "$archiveBase.7z"
    Write-Host "snapshot-install-dir: capturing $installDir -> $archivePath"
    & $sevenZip.Source a -t7z -mx=3 -mmt=on -- "$archivePath" "$installDir" | Out-Null
  } else {
    $archivePath = Join-Path $debugDir "$archiveBase.zip"
    Write-Host "snapshot-install-dir: 7z.exe not found, falling back to Compress-Archive -> $archivePath"
    Compress-Archive -Path (Join-Path $installDir '*') -DestinationPath $archivePath -CompressionLevel Fastest -Force
  }
} catch {
  Write-Host "snapshot-install-dir: archive step failed (continuing): $_"
}

Get-ChildItem -LiteralPath $debugDir -ErrorAction SilentlyContinue | Format-Table -AutoSize | Out-String | Write-Host
exit 0
