param($Server,$Suser)
$ErrorActionPreference= 'stop'
$Filename = 'ErrorLog_'+(get-date -f yyyy-MM-dd)+'.txt'
$Filepath= 'C:\Users\unixbot\Documents\Scripts\errorlogs'
function Get-TimeStamp {return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)}
try{
$user =
$pass= cat securepass.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$pass
$Session = New-CimSession -ComputerName $Server -Credential $cred

$NetAd= Get-CimInstance Win32_NetworkAdapterConfiguration -CimSession $Session |Where-Object {$_.IPEnabled -eq 'True'}
$Connection= Test-Connection -ComputerName $Server -Quiet
If ($Connection){$Connection="Successful"}
else {$Connection="Failed"}

Write-host "IP Address `t::" $NetAd.IPAddress "`nIP Subnet `t::" $netad.IPSubnet "`nGateway `t::" $NetAd.DefaultIPGateway "`nMAC Address `t::" $NetAd.MACAddress "`nPing Check `t::" $Connection
}
catch{  $Scriptname=$PSItem.InvocationInfo.scriptname
        Write-Host "General System Error!!!! `nApologies for inconvenience caused, OsBot Team is looking into the issue."
        Write-Output "`n" " $(Get-TimeStamp) $Suser" | Out-File $Filepath/$Filename -Append
        Write-Output "Script Name:- $Scriptname"| Out-File $Filepath/$Filename -Append
        $_.exception.message | Out-File $Filepath/$Filename -Append
      }