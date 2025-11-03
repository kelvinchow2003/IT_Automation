#Requires -RunAsAdministrator
Import-Module PSWindowsUpdate

# Log folder
$LogDir = "$env:ProgramData\WindowsUpdate\Logs"
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
$LogFile = Join-Path $LogDir ("WU-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".log")

# Make sure core services are up
'wuauserv','bits','UsoSvc' | ForEach-Object {
    try {
        Set-Service -Name $_ -StartupType Automatic -ErrorAction Stop
        Start-Service -Name $_ -ErrorAction Stop
    } catch {}
}

# Include Microsoft Update catalog (Office/Edge/etc.) if available
Add-WUServiceManager -MicrosoftUpdate -Confirm:$false | Out-Null

# Install all available updates and reboot automatically if required
# -AcceptAll   : accept EULAs
# -Install     : actually install them
# -MicrosoftUpdate : include MS products
# -AutoReboot  : reboot if needed (respects Windows Update’s rules)
Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -AutoReboot -Verbose 2>&1 |
    Tee-Object -FilePath $LogFile | Out-Null
``