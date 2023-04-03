Param($Server,$Type,$SName,$SStatus,$SUser,$Email)
Remove-Item "C:\Users\\Documents\Final\CSVReports\$SUser.xlsx" -ErrorAction SilentlyContinue
$Filename = 'ErrorLog_'+(get-date -f yyyy-MM-dd)+'.txt'
$Filepath= 'C:\Users\unixbot\Documents\Scripts\errorlogs'
function Get-TimeStamp {return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)}
$ErrorActionPreference= 'Stop'
try{
########################### SMTP Parameters ##############################
$From = 
$To = $Email
$Cc = 
$Attachment = 
$Body = "Hi $SUser,"
$SMTPServer =
$SMTPPort = "587"
###########################################################################
$user ='ms\aagarw45'
$pass= Get-Content 'C:\Users\aagarw45\Documents\securepass.txt' | convertto-securestring
$cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $user,$pass
$Session = New-CimSession -ComputerName $Server -Credential $cred
Switch ($Type)
{
     "Name"{$SDetails= Get-CimInstance -CimSession $Session -ClassName win32_service -Filter "Name LIKE '$SName%'"
        if(!$SDetails) {Write-Host "Service $SName not found, Please check service name and try again";exit}
        Write-Host "PFB Details of Service $SName"
        $SDetails|select name,State,StartMode,DisplayName 
        }
    
    "Status"
        {
        $Subject = "$Server $SStatus Service(s) Information"
        $Body += "PFA $SStatus Service(s) report for $Server"
        $SDetails= Get-CimInstance -CimSession $Session -ClassName win32_service|Where-Object {$_.state -eq $SStatus}
        if(!$SDetails) {Write-Host "Service Status is invalid, Please check service status provided and try again";exit}
        $SDetails |select name,State,StartMode,DisplayName | Export-Excel "C:\Users\aagarw45\Documents\Final\CSVReports\$SUser.xlsx" -AutoSize -BoldTopRow
        Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $Attachment -WarningAction SilentlyContinue
        $msg= "I have emailed details to $Email"
        $msg
        }
        
    "All"
     {  
        $Subject = "$Server All Service(s) Information"
        $Body += "PFA All Service(s) Status report for $Server"
        Get-CimInstance -CimSession $Session -ClassName win32_service|Sort-Object state| select name,State,StartMode,DisplayName| Export-Excel "C:\Users\aagarw45\Documents\Final\CSVReports\$SUser.xlsx" -AutoSize -BoldTopRow
        Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $Attachment -WarningAction SilentlyContinue
        Write-Host "`n`nI have emailed details to $Email"
     }
 }}
catch{  $Scriptname=$PSItem.InvocationInfo.scriptname
        Write-Host "General System Error!!!! `nApologies for inconvenience caused, OsBot Team is looking into the issue."
        Write-Output "`n" " $(Get-TimeStamp) $Suser" | Out-File $Filepath/$Filename -Append
        Write-Output "Script Name:- $Scriptname"| Out-File $Filepath/$Filename -Append
        $_.exception.message | Out-File $Filepath/$Filename -Append
      }