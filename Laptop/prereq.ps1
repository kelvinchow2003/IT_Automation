#one time run as prereq

# Make sure services are running
'wuauserv','bits','UsoSvc' | ForEach-Object {
    Set-Service -Name $_ -StartupType Automatic
    Start-Service -Name $_ -ErrorAction SilentlyContinue
}

# Run in an elevated PowerShell
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

# Trust PSGallery (to avoid prompts in scheduled runs)
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Install the module
Install-Module -Name PSWindowsUpdate -Force