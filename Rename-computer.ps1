$NewName = Read-Host "Enter new computer name"

Rename-Computer -NewName $NewName -Force -Restart