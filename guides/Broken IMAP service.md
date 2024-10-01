#exchange #windows-server #fix

- Due to a **Microsoft Bug**, that appears after installing Cumulative Update for **[[Exchange]] 2013/2016**, the IMAP will **immediately disconnect any connection**

- Reason for that is non-working IMAP.Proxy

- Restarting the IMAP4 services **doesn't resolve the problem** 

![[Pasted image 20240627101505.png]]

### Solution:

- open **Exchange Management Shell** on server
- check the health-state of your server
``` powershell
	Get-HealthReport server.domain.com  | where { $_.state -eq “Offline”}
```

- That will most likely return an offline IMAP.Proxy health-state

![[Pasted image 20240627101734.png]]


- By setting online the IMAP.Proxy, the IMAP service will come to life
``` powershell
Set-ServerComponentState -Identity server.domain.com -Component IMAPProxy -State Active -Requester HealthAPI
```


- finally run the first command again after a while to check whether or not the Offline appears again, if not, the IMAP should be workin' now