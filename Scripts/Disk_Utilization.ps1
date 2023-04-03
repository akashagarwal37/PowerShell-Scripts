Param($Server,$Suser,$Email,$Type)
$ErrorActionPreference ='stop'
$Filename = 'ErrorLog_'+(get-date -f yyyy-MM-dd)+'.txt'
$Filepath= 'C:\Users\unixbot\Documents\Scripts\ErrorLogs'
function Get-TimeStamp {return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)}
$File = "C:\Users\unixbot\Documents\Scripts\CSVReports\${SUser}_DiskReport.xlsx"
########################### SMTP Parameters ##############################
$From = 
$To = $Email
$Cc = 
$Body = "Hi $SUser, `nPFA detailed disk utilization report for $Server"
$Subject = "Disk Details for Server $Server"
$SMTPServer = 
$SMTPPort = "587"
###########################################################################

Try{

$user =
$pass= cat securepass.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$pass
$Session = New-CimSession -ComputerName $Server -Credential $cred

Switch($Type){
         "1"  {$hash = @{2 = "Removable disk"
		                 3= "Fixed local disk"
		                 4= "Network disk"
		                 5 = "Compact disk"}
                $DU= Get-CimInstance -ClassName win32_logicaldisk -CimSession $Session
	            foreach ($disk in $DU){
			                            $Disk_Free = (($disk.freespace/$disk.size)*100).tostring("#.##") 
			                            if ($Disk_Free -lt '10'){Write-host "`n" $disk.deviceid "is only $Disk_Free% Free, Please check for files consuming Disk and run cleanup if possible"}
			                            else {Write-host $disk.deviceid "is $disk_Free% Free"}}	
                $DU_Check = $DU | select @{n="Drive";e={$_.deviceid}},@{n="Free%" ; e={[math]::round(($_.freespace/$_.size)*100,2)}} |ft -AutoSize
	
                $DU_Full= $DU|select @{n="Drive";e={$_.deviceid}},volumename, @{n='DriveType' ; e={$hash.item([int]$_.DriveType)}}, @{n="Size(GB)" ; e={[math]::Round($_.size/1GB,2)}}, @{n="Free Space(GB)" ; e={[math]::Round($_.freespace/1GB,2)}}, @{n="Free%" ; e={[math]::round(($_.freespace/$_.size)*100,2)}}
		        $DU_Full|Export-Excel $File -ClearSheet -WorksheetName "Disk_Details" -AutoSize -BoldTopRow
                Write-Host "`nFull Details: Y/N"
	           }
	      "2" { 
                Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $File -WarningAction SilentlyContinue
                write-host "I have emailed details to $Email"}
               }
}
catch{  $Scriptname=$PSItem.InvocationInfo.scriptname
        Write-Host "General System Error!!!! `nApologies for inconvenience caused, OsBot Team is looking into the issue."
        Write-Output "`n" " $(Get-TimeStamp) $Suser" | Out-File $Filepath/$Filename -Append
        Write-Output "Script Name:- $Scriptname"| Out-File $Filepath/$Filename -Append
        $_.exception.message | Out-File $Filepath/$Filename -Append
      }
	
