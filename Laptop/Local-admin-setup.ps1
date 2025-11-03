param(
    [Parameter(Mandatory)][string]     $NewName,
    [Parameter(Mandatory)][SecureString]        $Password
)

function Get-LocalAdminAdsi {
    [ADSI]"WinNT://$env:COMPUTERNAME/Administrator,user"
}

try {
    # 1) Bind to the built-in Administrator
    $admin = Get-LocalAdminAdsi

    # 2) Rename the account
    Write-Host "Renaming Administrator to '$NewName'..."
    $admin.psbase.Rename($NewName)

    # 3) Rebind to the new name
    $path  = "WinNT://$env:COMPUTERNAME/$NewName,user"
    $admin = [ADSI]$path

    # 4) Enable the account
    Write-Host "Enabling '$NewName'..."
    $admin.AccountDisabled = $false

    # 5) Set password never expires (UF_DONT_EXPIRE_PASSWD = 0x10000)
    Write-Host "Setting password to never expire..."
    $UF_DONT_EXPIRE_PASSWD = 0x10000

    # Extract current flags, OR in the “never expire” bit, then assign back
    $currentFlags = $admin.Properties["UserFlags"].Value
    $newFlags     = $currentFlags -bor $UF_DONT_EXPIRE_PASSWD
    $admin.Properties["UserFlags"].Value = $newFlags

    # 6) Optionally set a new password
    if ($PSBoundParameters.ContainsKey('Password')) {
        Write-Host "Updating password for '$NewName'..."
        $plainTextPwd = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        )
        $admin.SetPassword($plainTextPwd)
    }

    # 7) Commit all changes
    $admin.SetInfo()

    Write-Host "`n✔ '$NewName' renamed, enabled, and configured." -ForegroundColor Green
}
catch {
    Write-Error "❌ Failed: $_"
    exit 1
}
