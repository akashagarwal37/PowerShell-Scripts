Param($Email,$SUser,$Server)
$ErrorActionPreference= 'stop'
$Filename = 'ErrorLog_'+(get-date -f yyyy-MM-dd)+'.txt'
$Filepath= 'C:\Users\unixbot\Documents\Scripts\errorlogs'
function Get-TimeStamp {return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)}
try{
########################### Email Details ##############################
$From = 
$Cc = 
$Subject = "$Server Health Check Detailed Report"
$Body = "Hi $SUser,"
$Body += "`n PFA detailed health check report for $Server"
$SMTPServer = 
$SMTPPort = "587"
$File = ${SUser}_HC.xlsx
###########################################################################
Send-MailMessage -From $From -to $Email -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $File -WarningAction Ignore
Write-Host "I have emailed Health Check Report to $Email"
}
catch{  $Scriptname=$PSItem.InvocationInfo.scriptname
        Write-Host "General System Error!!!! `nApologies for inconvenience caused, OsBot Team is looking into the issue."
        Write-Output "`n" " $(Get-TimeStamp) $Suser" | Out-File $Filepath/$Filename -Append
        Write-Output "Script Name:- $Scriptname"| Out-File $Filepath/$Filename -Append
        $_.exception.message | Out-File $Filepath/$Filename -Append
      }