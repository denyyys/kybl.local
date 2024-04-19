## RDS SSL Let's Encrypt Certificate

#windows-server #setup 

to make RDS fully working on [[Windows Server]]

Tools needed:
- win-acme
- IIS / RDS role installed
- open port **443 / 80**

it is a good practice to export the downloaded zip file into folder C:/inetpub/letsencrypt (not necessary)
### How to create SSL certificate for RDS with Auto-renewal:

**IIS settings:**
- make sure you have running e.g. Default Web Site

- in *Bindings* make sure there's *https* bind for port *443* and hostname *rds.example.cz*


**win-acme:**
- before creating the certificate, edit the *settings.json* file, located in the same folder as the win-acme
- there edit the *PrivateKeyExportable* from false to true and save it

- run the *wacs.exe*
- 1. - '*M: Create certificate (full option)*'
- 2. - '*2: Manual Input*'
- 3. - '*Host: rds.example.cz*'
- 4. - '*4. Single Certificate*'
- 5. - '*2: Serve verification files from memory*'
- 6. - '*2: RSA key*'
- 7. - '*4: Windows Certificate Store (Local Computer)*'
 you can store the certificate also elsewhere if you want to

the certificate renewal process **SHOULD** be automatic....

now check the MMC console, if the certificate is showing up correctly


**import the certificate to RDS (Gateway, Licensing, Broker):**
- open Powershell as admin
- cd into the *letsencrypt* folder

- run the script 
- the script will prompt you to enter *NewCertThumbprint*, you can get this from MMC console
   double-click on the certificate -> Details
   
```powershell

PS C:\inetpub\letsencrypt\Scripts> .\ImportRDSFull.ps1

cmdlet ImportRDSFull.ps1 at command pipeline position 1
Supply values for the following parameters:
NewCertThumbprint: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Cert thumbprint set to RD Gateway listener and service restarted
Updating property(s) of '\\exampleSRV\root\cimv2\TerminalServices:Win32_TSGeneralSetting.TerminalName="RDP-Tcp"'
Property(s) update successful.
Cert thumbprint set to RDP listener
RDPublishing Certificate for RDS was set
RDWebAccess Certificate for RDS was set
RDRedirector Certificate for RDS was set
RDGateway Certificate for RDS was set
RDWebClient not installed, skipping
Cleaning up

```


- for automatic RDS import you have to make a copy of *ImportRDSFull.ps1* to for example *ImportRDSFull_edited.ps1* and add there two lines of code:



```powershell
....
....
.the rest of the code (DONT CHANGE!!!).
....
....

param(
    [Parameter(Position=1,Mandatory=$false)]
    [string]$RDCB,
    [Parameter(Position=3,Mandatory=$false)]
    [string]$OldCertThumbprint

)
(dont change code above)


--------------------------------add this and edit domain--------------------------------------

$cert = Get-ChildItem -Path 'Cert:\LocalMachine\My' | Where-Object { $_.Subject -like "*rds.example.cz*" }
$NewCertThumbprint = $cert.Thumbprint

--------------------------------add this and edit domain--------------------------------------



....
....
....
.the rest of the code (DONT CHANGE!!!).
....
....
....

```

- after that you can create a **Scheduled Task** for this script to run every week / month ....
- i think maybe win-acme does the RDS import and the renewal script automatically by itself but i didn't test it and didn't want to risk it


- finally check if it was successfully imported into the RDS
