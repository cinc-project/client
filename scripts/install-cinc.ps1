$msi = Get-ChildItem -Path *.msi $env:CI_PROJECT_DIR/data/windows/
Start-Process -FilePath "msiexec.exe" -ArgumentList "/qn /i $msi" -Wait -NoNewWindow
