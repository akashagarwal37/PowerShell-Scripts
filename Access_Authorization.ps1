Param($Email,$Server,$SUser)
$ErrorActionPreference= 'stop'
$Filename = 'ErrorLog_'+(get-date -f yyyy-MM-dd)+'.txt'
$Filepath= 'C:\Users\unixbot\Documents\Scripts\ErrorLogs'
function Get-TimeStamp {return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)}
try{
$CreUse =
$pass= cat 'C:\Users\Documents\securepass.txt' | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $CreUse,$pass
$Access = 'False'
$Emp = Get-ADUser -Filter "EmailAddress -eq '$Email'" -Properties * -Credential $cred
$EmpId = $Emp.EmployeeID
$userAD= Get-ADUser -Filter "employeeid -eq '$EmpId'" -Properties * -Credential $cred |Where-Object {$_.'uht-IdentityManagement-AccountType' -eq 'S'}
$User = $userAD.Name
Foreach ($u in $User){
#Fetch User's Groups
    $UG= @(Get-ADPrincipalGroupMembership -Identity $U -Credential $cred)
    $UGroup = $UG | %{$_.Name -match "(.+)$" > $null
    $Matches[1].trim('"')}

#Fetch Server Admin and RDP groups
    $Groups = Get-WmiObject -Class win32_groupuser -ComputerName $Server -Credential $cred| ? {$_.groupcomponent –like '*"Administrators"' -or  $_.groupcomponent –like '*"Remote Desktop Users"' } 
    $SGroup= @($Groups |% {$_.partcomponent –match “,Name\=(.+)$” > $nul  
    $matches[1].trim('"')})
    
#Comprare Server Groups to User Groups
    Foreach($g in $SGroup)
    {
    if ($UGroup -contains $g)
    {$Access= 'True'
    Break}
    }
    If ($Access -eq 'true'){
    $AuthUser = $u
    Break}
    }
    
    Switch($Access)
    {
    'True' {Write-Host "True"}
    'False' {Write-Host "False"}
    }}
   catch{  $Scriptname=$PSItem.InvocationInfo.scriptname
        Write-Host "General System Error!!!! `nApologies for inconvenience caused, OsBot Team is looking into the issue."
        Write-Output "`n" " $(Get-TimeStamp) $Suser" | Out-File $Filepath/$Filename -Append
        Write-Output "Script Name:- $Scriptname"| Out-File $Filepath/$Filename -Append
        #$_.exception.message | Out-File $Filepath/$Filename -Append
        $_ | Out-File $Filepath/$Filename -Append
      }