$HostsIP = "192.168.0.1", "192.168.0.199", "192.168.1.254"

foreach ($host_ip in $HostsIP) {
    if (Test-Connection -ComputerName $host_ip -Count 1 -Quiet) {
        Write-Host "$host_ip `t`t [OK]" -ForegroundColor Green
    }
    else {
        Write-Host "$host_ip `t`t [FAIL]" -ForegroundColor Red
    }
}
