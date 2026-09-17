# MSYS2's documented CI-hang fix: kill the background processes it leaves
# (gpg-agent etc.) that the runner would wait on. Always exits 0; run it last.

$ErrorActionPreference = 'Continue'

taskkill /F /FI 'MODULES eq msys-2.0.dll'
Write-Host "reap-msys2-processes: taskkill exit code $LASTEXITCODE (128 = nothing to kill)"
exit 0
