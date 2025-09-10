$source = "D:\Tpa_Software"
$destination = "C:\Tpa_Software"

# Skip copy if destination already exists
if (-not (Test-Path $destination)) {
    if (Test-Path $source) {
        # Create destination folder
        New-Item -ItemType Directory -Path $destination
        Write-Host "Destination folder created."

        # Copy the folder contents
        Copy-Item -Path "$source\*" -Destination $destination -Recurse -Force
        Write-Host "Folder copied successfully from $source to $destination."
    } else {
        Write-Host "Source folder not found. Please check the USB drive letter and folder name."
    }
} else {
    Write-Host "Destination folder already exists. Skipping copy."
}
# --- NetTime Setup ---
$nettimePath = "C:\Tpa_Software\BrandNew_PC\Nettime"
$nettimeInstaller = "$nettimePath\NetTimeSetup-314.exe"
$nettimeSettings = "$nettimePath\netTimeSettings.bat"
$nettimeLog = "C:\nettime_install.log"

# --- NetTime Setup ---
$nettimePath = "C:\Tpa_Software\BrandNew_PC\Nettime"
$nettimeInstaller = "$nettimePath\NetTimeSetup-314.exe"
$nettimeSettings = "$nettimePath\netTimeSettings.bat"
$nettimeLog = "C:\nettime_install.log"

# Launch NetTime installer without waiting
if (Test-Path $nettimeInstaller) {
    Write-Host "Launching NetTime installer silently..."
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$nettimeInstaller /VERYSILENT /NORESTART /LOG=`"$nettimeLog`"`"" -Verb RunAs
    Start-Sleep -Seconds 10
    Write-Host "NetTime installer launched. Log saved to $nettimeLog."

    # Optional: Kill lingering NetTime processes to prevent blocking
    Get-Process | Where-Object { $_.Name -like "NetTime*" } | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "Any lingering NetTime processes terminated."
} else {
    Write-Host "NetTime installer not found at $nettimeInstaller."
}

# Apply NetTime settings with elevation
if (Test-Path $nettimeSettings) {
    Write-Host "Applying NetTime settings..."
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$nettimeSettings`"" -Verb RunAs -Wait
    Write-Host "NetTime settings applied from $nettimeSettings."
} else {
    Write-Host "NetTime settings script not found at $nettimeSettings."
}
# --- Qualys Setup ---
$qualysPath = "C:\Tpa_Software\BrandNew_PC\Qualys\Qualys Agent"
$qualysMSI = "$qualysPath\WIN.msi"
$installBat = "$qualysPath\Install.bat"
$certBat = "$qualysPath\Add_Qualys_GW_Cert\QGWCert.bat"

# Install Qualys MSI silently
if (Test-Path $qualysMSI) {
    Write-Host "Installing Qualys Gateway App..."
    Start-Process "msiexec.exe" -ArgumentList "/i `"$qualysMSI`" /quiet /norestart" -Wait
    Write-Host "Qualys Gateway App installed silently from $qualysMSI."
} else {
    Write-Host "WIN.msi not found at $qualysMSI."
}

# Short delay to ensure MSI finishes cleanly
Start-Sleep -Seconds 10

# Run Install.bat through elevated Command Prompt
if (Test-Path $installBat) {
    Write-Host "Running Install.bat with elevated Command Prompt..."
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$installBat`"" -Verb RunAs -Wait
    Write-Host "Install.bat executed from $installBat."
} else {
    Write-Host "Install.bat not found at $installBat."
}

# Run QGWCert.bat through elevated Command Prompt
if (Test-Path $certBat) {
    Write-Host "Running QGWCert.bat with elevated Command Prompt..."
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$certBat`"" -Verb RunAs -Wait
    Write-Host "QGWCert.bat executed from $certBat."
} else {
    Write-Host "QGWCert.bat not found at $certBat."
}

# --- LRSystemMonitor Setup ---

$lrMonitorInstaller = "C:\Tpa_Software\BrandNew_PC\LRSystemMonitor_64Core_7.17.0.1028.exe"

if (Test-Path $lrMonitorInstaller) {
    Write-Host "Launching LRSystemMonitor installer silently..."
    $arguments = '/s /v"/qn"'  # Properly quoted for InstallShield
    Start-Process -FilePath $lrMonitorInstaller -ArgumentList $arguments -Wait
    Write-Host "LRSystemMonitor installed silently from $lrMonitorInstaller."
} else {
    Write-Host "LRSystemMonitor installer not found at $lrMonitorInstaller."
}
# --- Sysmon Setup ---
$sysmonSource = "C:\Tpa_Software\BrandNew_PC\Sysmon15.15\Sysmon64.exe"
$sysmonDestination = "C:\Windows\System32\Sysmon64.exe"

if (Test-Path $sysmonSource) {
    Copy-Item -Path $sysmonSource -Destination $sysmonDestination -Force
    Write-Host "Sysmon64.exe copied to System32 from $sysmonSource."

    Start-Process -FilePath "cmd.exe" -ArgumentList "/c Sysmon64.exe -i -accepteula" -Verb RunAs -Wait
    Write-Host "Sysmon64.exe initialized silently."
} else {
    Write-Host "Sysmon64.exe not found."
}