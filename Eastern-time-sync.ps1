# Run as Administrator

# Set time zone to Eastern Standard Time (auto-adjusts for DST)
tzutil /s "Eastern Standard Time"

# Restart Windows Time service
Restart-Service w32time

# Force time sync with default time server
w32tm /resync /force

# Optional: Display current time zone and sync status
Write-Host "Time zone set to:" (tzutil /g)
Write-Host "`nTime sync status:"
w32tm /query /status
