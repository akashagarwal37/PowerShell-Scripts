Param($Server,$Suser)
$ErrorActionPreference= 'stop'
$Filename = 'ErrorLog_'+(get-date -f yyyy-MM-dd)+'.txt'
$Filepath= 'C:\Users\unixbot\Documents\Scripts\errorlogs'
function Get-TimeStamp {return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)}
try{
$user =
$pass= cat securepass.txt' | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$pass
$Session = New-CimSession -ComputerName $Server -Credential $cred
$OSDetails = Get-CimInstance -ClassName win32_operatingsystem -CimSession $Session
$LastReboot= $OSDetails.lastbootuptime
Write-Host "`nServer last reboot date/Time is" $LastReboot
}
catch{  $Scriptname=$PSItem.InvocationInfo.scriptname
        Write-Host "General System Error!!!! `nApologies for inconvenience caused, OsBot Team is looking into the issue."
        Write-Output "`n" " $(Get-TimeStamp) $Suser" | Out-File $Filepath/$Filename -Append
        Write-Output "Script Name:- $Scriptname"| Out-File $Filepath/$Filename -Append
        $_.exception.message | Out-File $Filepath/$Filename -Append
      }