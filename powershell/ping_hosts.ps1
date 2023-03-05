$HostsIP = "0.0.0.0", "0.0.0.0", "0.0.0.0" #change these ip addresses to own choice

foreach ($host_ip in $HostsIP) {
    if (Test-Connection -ComputerName $host_ip -Count 1 -Quiet) {
        Write-Host "$host_ip `t`t [OK]" -ForegroundColor Green
    }
    else {
        Write-Host "$host_ip `t`t [FAIL]" -ForegroundColor Red
    }
}
