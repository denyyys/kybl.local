$ipAddressesFilePath = "X:\data.txt"

$addressListName = "tor-blacklist"

$ipAddresses = Get-Content -Path $ipAddressesFilePath

$scriptContent = "/ip firewall address-list`n"
$scriptContent += foreach ($ip in $ipAddresses) {
    "add list=$addressListName address=$ip`n"
}

$scriptContent | Out-File -FilePath "D:\tmp\blacklist_script.rsc" -Encoding UTF8
