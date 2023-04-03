$WarningPreference= 'Continue'
$ErrorActionPreference = 'Stop'
Try{
$path= "C:\Users\Documents\jobquery"
Remove-Item -Path "C:\Users\Documents\jobquery\Workflow_Job*" -Exclude "*.ps1"
[array] $a=(Get-Content $path\backup.txt | ForEach-Object {$_.trim() -replace ";" })
$first,$data=$a | Where-Object {$_}
$timestamp=Get-Date -Format dd-MM-yyyy
$File = "\Backup_Job_"+ $timestamp + ".xlsx"
$filename=$path+ $File

################## Create Excel File###################
$excel = New-Object -ComObject excel.application
$excel.visible = $true
$workbook = $excel.Workbooks.Add()
$Sheet= $workbook.Worksheets.Item(1)
$Sheet.name= "Backup_Job_Report"
$Sheet.activate()
$Cells=$Sheet.Cells
$row=1
$col=1
$Cells.Item($row,$col)= 'Data Protection Policy Name'
$Cells.Item($row,$col).Interior.ColorIndex =48
$Cells.Item($row,$col).Font.Bold=$True
$col++
$Cells.Item($row,$col)= 'Job Id'
$Cells.Item($row,$col).Interior.ColorIndex =48
$Cells.Item($row,$col).Font.Bold=$True
$col++
$Cells.Item($row,$col)= 'Job State'
$Cells.Item($row,$col).Interior.ColorIndex =48
$Cells.Item($row,$col).Font.Bold=$True
$col++
$Cells.Item($row,$col)= 'Start Time'
$Cells.Item($row,$col).Interior.ColorIndex =48
$Cells.Item($row,$col).Font.Bold=$True
$col++
$Cells.Item($row,$col)= 'Workflow Name'
$Cells.Item($row,$col).Interior.ColorIndex =48
$Cells.Item($row,$col).Font.Bold=$True
$row++
$col=1
foreach ($d in $data){
switch -Regex ($d) {
"data" {$Cells.item($row,$col)=($d -split ":")[1]}
"job id" {$Cells.item($row,$col)=($d -split ":")[1]}
"job state" {$Cells.item($row,$col)=($d -split ":")[1]}

"start" {$sec=($d -split ":")[1]
$Curr_date=$date.AddSeconds($sec)
$Cells.item($row,$col)=$Curr_date}

"workflow name" {$Cells.item($row,$col)=($d -split ":")[1]}
}
$col++
if ($col -eq 6) {$row++;$col=1}
}
$usedRange = $Sheet.UsedRange	
$usedRange.EntireColumn.AutoFit() | Out-Null
$excel.DisplayAlerts = 'False'
$workbook.saveas($filename)

#Quit the excel application
$excel.Quit()

#Release COM Object
[System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$excel) | Out-Null
###################################################

################### Send Email ####################
#$PSEmailServer
$To =""
$From=""
$Subject="Daily Job Query Report"
$Attachment=$filename
$Body=""
#Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -Attachments $Attachment
####################################################

##############Remove Excel File###################

Remove-Item -Path $filename -WarningAction Continue

###################################################
}
Catch
{$errfile= "Error_"+ $timestamp +".txt"
$_.exception.message | Out-File $Path/$errfile -Append}