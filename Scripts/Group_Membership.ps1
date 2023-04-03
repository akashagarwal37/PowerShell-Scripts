Param($Server,$Group,$SUser)
$ErrorActionPreference= 'stop'
$Filename = 'ErrorLog_'+(get-date -f yyyy-MM-dd)+'.txt'
$Filepath= 'C:\Users\unixbot\Documents\Scripts\errorlogs'
function Get-TimeStamp {return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)}
try{
$user =
$pass= cat \securepass.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$pass
Switch($Group)
{
    "Admin"
           {
           $out= Invoke-Command -ComputerName $Server -Credential $cred -ScriptBlock {net localgroup Administrators} |select -SkipLast 2 |select -Skip 6
           If ($out -ne $null) {$out}
           else {Write-Host "No Members Available in group 'Administrators'"} 
           }
    "RDP" 
           {
           $out= Invoke-Command -ComputerName $Server -Credential $cred -ScriptBlock {net localgroup "Remote Desktop Users"} |select -SkipLast 2 |select -Skip 6
           If ($out -ne $null) {$out}
           else {Write-Host "No Members Available in Group 'Remote Desktop Users' "} 
           }
     default
           { 
           Write-Host "INVALID INPUT GROUP, Only Supported groups are Administrators or RDP"
           }
}
}
catch{  $Scriptname=$PSItem.InvocationInfo.scriptname
        Write-Host "General System Error!!!! `nApologies for inconvenience caused, OsBot Team is looking into the issue."
        Write-Output "`n" " $(Get-TimeStamp) $Suser" | Out-File $Filepath/$Filename -Append
        Write-Output "Script Name:- $Scriptname"| Out-File $Filepath/$Filename -Append
        $_.exception.message | Out-File $Filepath/$Filename -Append
      }