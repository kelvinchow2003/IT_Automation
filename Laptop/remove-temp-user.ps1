# Define the username and profile path
$UserName = "temp"
$ProfilePath = "C:\Users\$UserName"

# Check if the user exists
if (Get-LocalUser -Name $UserName -ErrorAction SilentlyContinue) {
    # Remove the user
    Remove-LocalUser -Name $UserName
    Write-Host "User '$UserName' has been deleted successfully."

    # Check if the profile folder exists
    if (Test-Path $ProfilePath) {
        # Remove the profile folder
        Remove-Item -Path $ProfilePath -Recurse -Force
        Write-Host "Profile folder '$ProfilePath' has been removed."
    } else {
        Write-Host "Profile folder '$ProfilePath' does not exist."
    }
} else {
    Write-Host "User '$UserName' does not exist."
}
