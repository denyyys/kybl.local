#getting data from excel file
$data = Import-Excel -Path 'C:\Users\data.xlsx'

$confirmationPreference = $false

#for cycle for every row in that excel file
foreach($row in $data){

#getting username and surname
$name = $row.Jmeno
$surname = $row.Prijmeni

#creating login credentials
$mail = $name.ToLower()+"."+$surname.ToLower()+"@kybl.local"

#creating a random 8 characters long password
$password = -join ((48..57 + 97..122 | Get-Random -Count 8) | % {[char]$_})

#creating user
New-ADUser -Name $name -GivenName $name -Surname $surname -SamAccountName $mail -UserPrincipalName $mail -Path "OU=uzivatele,DC=kybl,DC=local" -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force)

#saving password of each user into external file
$credentials = New-Object System.Management.Automation.PSCredential($mail, (ConvertTo-SecureString -AsPlainText $password -Force))
$credentials | Export-Clixml -Path "C:\Users\passwords.txt"

}