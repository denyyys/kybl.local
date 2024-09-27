#Windows Update script

param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

Clear-Host
'running with full privileges'
Write-Output "------------------------------------------------------------"
Write-Output " "

Write-Output "Searching available updates:"
Get-WindowsUpdate

Write-Output " "
read-host “Press any key to install these updates”

Install-WindowsUpdate -NotCategory "Drivers" -NotTitle OneDrive -AcceptAll -IgnoreReboot | Out-File "c:\updateLogs\$(get-date -f yyyy-MM-dd)-WindowsUpdate.log" -force

Write-Output " "
Write-Output "------------------------------------------------------------"
Write-Output "Log of update is located at C:\updateLogs"
Write-Output " "
Get-WURebootStatus
Write-Output "Automatic restart is disabled, restart to apply updates if needed"
Write-Output " "
read-host “Press any key to exit”
Write-Output " "
