$ErrorActionPreference = "Stop"
if (Test-Path C:\cinc-project) {
    Write-Host "Found existing directory C:\cinc-project, removing.."
    Remove-Item -Recurse -Force C:\cinc-project
}
Write-Host "Finding MSI..."
$msi = gci -recurse -filter '*.msi' $env:CI_PROJECT_DIR/data/windows/ | select -expand FullName
Write-Host "Found MSI at $msi, installing..."
$p = Start-Process -FilePath "msiexec.exe" -ArgumentList "/qn /i $msi" -Passthru -Wait -NoNewWindow
$p.WaitForExit()
if ($p.ExitCode -ne 0) {
    throw "msiexec was not successful. Received exit code $($p.ExitCode)"
}
if (Test-Path C:\cinc-project) {
    Write-Host "MSI Installed successfully!"
} else {
    throw "MSI was installed however C:\cinc-project does not exist"
}
