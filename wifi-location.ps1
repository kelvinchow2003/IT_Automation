param (
    [string]$SSID = "ZTE MF279T 09AA-5G",
    [string]$Password = "V26GP6LJM3"
)

# Open Location Settings
Start-Process "ms-settings:privacy-location"
Write-Host "Please enable Location Services in the Settings window that just opened."
Read-Host "Press Enter once Location Services are enabled..."

# Proceed with Wi-Fi setup
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

$profilePath = "$env:TEMP\$SSID.xml"
$profileXml | Out-File -Encoding UTF8 -FilePath $profilePath

net profile filename="$profilePath"
netsh wlan connect name="$SSID"

# Optional: Prompt to disable location again
Write-Host "Wi-Fi connected. You can now disable Location Services if desired."
Start-Process "ms-settings:privacy-location"
