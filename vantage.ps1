# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Install LSUClient module if not already installed
if (-not (Get-Module -ListAvailable -Name LSUClient)) {
    Install-Module -Name LSUClient -Force -Confirm:$false
}

# Import the module
Import-Module LSUClient

# Function to install updates
function Install-LenovoUpdates {
    $updates = Get-LSUpdate
    if ($updates.Count -gt 0) {
        Write-Host "Installing $($updates.Count) update(s)..."
        $updates | Install-LSUpdate -Verbose
        return $true
    } else {
        Write-Host "No updates available."
        return $false
    }
}

# First update pass
$firstPass = Install-LenovoUpdates

# If updates were installed, schedule second run after reboot
if ($firstPass) {
    $taskName = "LenovoUpdatePostReboot"
    $scriptPath = $MyInvocation.MyCommand.Path

    Write-Host "Scheduling second update pass after reboot..."

    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -Force

    Write-Host "Rebooting system to complete update process..."
    Restart-Computer
    exit
}

# If this is the second run, remove scheduled task and LSUClient module
if (Get-ScheduledTask -TaskName "LenovoUpdatePostReboot" -ErrorAction SilentlyContinue) {
    Write-Host "Second update pass complete. Cleaning up..."
    Unregister-ScheduledTask -TaskName "LenovoUpdatePostReboot" -Confirm:$false
}

# Remove LSUClient module
Uninstall-Module -Name LSUClient -Force
Write-Host "LSUClient module removed after update."
