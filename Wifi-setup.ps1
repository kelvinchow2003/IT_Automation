param (
    [string]$SSID = "ZTE MF279T 09AA-5G",
    [string]$Password = "V26GP6LJM3"
)


# Create the XML profile content
$profileXml = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$SSID</name>
    <SSIDConfig>
        <SSID>
            <name>$SSID</name>
        </SSID>
        <nonBroadcast>false</nonBroadcast>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$Password</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
"@

# Save profile to temp file
$profilePath = "$env:TEMP\$SSID.xml"
$profileXml | Out-File -Encoding UTF8 -FilePath $profilePath

# Add profile
$addResult = netsh wlan add profile filename="$profilePath"
Write-Host "Profile Add Result:`n$addResult"

# Connect to the network
$connectResult = netsh wlan connect name="$SSID"
Write-Host "Connect Result:`n$connectResult"


# Optional: Prompt to disable location again
Write-Host "Wi-Fi connected. You can now disable Location Services if desired."
Start-Process "ms-settings:privacy-location"