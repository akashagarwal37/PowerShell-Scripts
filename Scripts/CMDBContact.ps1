#$cred= Get-Credential "Enter Credentials"
#Param($Server,$SUser)
$server=""
$Server = $Server.ToUpper()
$Urin ="API URL"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12
Invoke-RestMethod -Uri $Urin -UseDefaultCredentials | Convertfrom-Json