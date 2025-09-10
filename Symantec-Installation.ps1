# Define source and destination paths
$sourceFolder = "D:\Scripts\Symantec Endpoint Protection version 14.3.11232.9000 - English"
$destinationFolder = "C:\Symantec Endpoint Protection version 14.3.11232.9000 - English"
$setupExe = Join-Path $destinationFolder "setup.exe"

# Copy the folder
Write-Host "Copying folder..."
Copy-Item -Path $sourceFolder -Destination $destinationFolder -Recurse -Force

# Run the setup executable
if (Test-Path $setupExe) {
    Write-Host "Running setup..."
    Start-Process -FilePath $setupExe -Wait
    Start-Sleep -Seconds 130

    # Restart the computer
    Write-Host "Installation complete. Restarting computer..."
    Restart-Computer -Force
} else {
    Write-Host "Setup executable not found at: $setupExe"
}
