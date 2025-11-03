# Prevent sleep and lock when plugged in (AC power)

# Set sleep timeout to 0 (Never) for AC power
powercfg /change standby-timeout-ac 0

# Set display timeout to 0 (Never) for AC power
powercfg /change monitor-timeout-ac 0

# Disable lock screen timeout on AC power
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE AC 0

# Apply the changes
powercfg /S SCHEME_CURRENT

Write-Output "Sleep, display timeout, and lock screen have been disabled for AC power."
