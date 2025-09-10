
# Ensure PSWindowsUpdate is installed
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
}

Import-Module PSWindowsUpdate

# Log file path
$logPath = "$env:ProgramData\UpdateScript\update.log"
New-Item -ItemType Directory -Path (Split-Path $logPath) -Force | Out-Null

# Function to schedule script after reboot
function Register-PostReboot {
    $taskName = "ContinueWindowsUpdate"
    $scriptPath = $MyInvocation.MyCommand.Path

    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force
}

# Function to remove scheduled task
function Unregister-PostRebootTask {
    Unregister-ScheduledTask -TaskName "ContinueWindowsUpdate" -Confirm:$false -ErrorAction SilentlyContinue
}

# Install all updates including optional
Write-Output "Checking for updates..." | Tee-Object -FilePath $logPath -Append
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot | Tee-Object -FilePath $logPath -Append


# Check if reboot is required
if ((Get-WURebootStatus).RebootRequired) {
    Write-Output "Reboot required. Scheduling script to continue after reboot..." | Tee-Object -FilePath $logPath -Append
    Register-PostReboot
    Restart-Computer -Force
} else {
    Write-Output "No reboot required. All updates installed." | Tee-Object -FilePath $logPath -Append
    Unregister-PostRebootTask

    # Uninstall PSWindowsUpdate module
    Write-Output "Removing PSWindowsUpdate module..." | Tee-Object -FilePath $logPath -Append
    Uninstall-Module -Name PSWindowsUpdate -Force -ErrorAction SilentlyContinue

    Write-Output "Update process complete and cleanup done." | Tee-Object -FilePath $logPath -Append
}
