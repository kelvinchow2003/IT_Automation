# Requires: Run as Administrator

# Step 1: Enable 'Get the latest updates' setting
$registryPath = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
$propertyName = "IsContinuousInnovationOptedIn"
$propertyValue = 1

if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue
Write-Host "✅ 'Get the latest updates' setting has been enabled."

# Step 2: Install PSWindowsUpdate module if not present
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-PackageProvider -Name NuGet -Force
    Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
}
Import-Module PSWindowsUpdate

# Step 3: Create visual prompt script
$scriptPath = "C:\Scripts\ShowUpdateStatus.ps1"
$taskName = "ShowUpdateStatus"

if (-not (Test-Path "C:\Scripts")) {
    New-Item -Path "C:\Scripts" -ItemType Directory | Out-Null
}

@"
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show('🔄 Updates are still being installed. Please wait...', 'Update Status')
# Cleanup after showing
Unregister-ScheduledTask -TaskName '$taskName' -Confirm:$false
Remove-Item -Path '$scriptPath' -Force
"@ | Set-Content $scriptPath

# Step 4: Schedule the visual prompt to run after reboot
schtasks /Create /TN $taskName /TR "powershell.exe -ExecutionPolicy Bypass -File `"$scriptPath`"" /SC ONLOGON /RL HIGHEST /F

Write-Host "🕒 Visual prompt scheduled to show after reboot."

# Step 5: Start Windows Update and reboot if needed
Write-Host "🔄 Checking for and installing updates..."
Install-WindowsUpdate -AcceptAll -AutoReboot -Verbose
