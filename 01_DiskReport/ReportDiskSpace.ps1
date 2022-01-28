#
#(Get-Credential).Password | ConvertFrom-SecureString | Out-File C:\Coding\Powershell\Powershell_Projects\01_DiskReport\pass.txt
#

$servers = @('WINDC', 'WinOFF')

try{

    $pass = get-Content 'C:\Coding\Powershell\Powershell_Projects\01_DiskReport\pass.txt'  | ConvertTo-SecureString
}


catch{

    Write-Host -f DarkRed "Cannot get the password"
}

trap {"Error found."}

$user = 'Administrator'
$credential = New-Object System.Management.Automation.PSCredential($user, $pass)
$report = 'C:\Coding\Powershell\Powershell_Projects\01_DiskReport\report_disk_space.html'  


$data = @()

foreach ($server in $servers){

    if (!(Test-Connection -ComputerName $server -Count 1 -Quiet)){ 
    
        $data += [PSCustomObject]@{PSComputerName = $server
                                   DeviceID = "Not Available" 
                                   Free_Space_Perc = 0
                                   status = "Offline"
                                  }
    }
    else{
    
        $data += Get-WmiObject -class win32_logicaldisk –credential $credential  -ComputerName $server |  Where-Object {$_.drivetype -eq 3} | Select-Object PSComputerName, DeviceID, @{'Name'='Free_Space_Perc';'Expression'={[math]::Round($_.FreeSpace /1GB)}}, @{'Name'='status';'Expression'={'Online'}} 
    }
}

$html = @"
<html>
<style>
#report {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 75%;
}

#report td, #report th {
  border: 1px solid #ddd;
  padding: 8px;
}

</style>

<head>
<h1>Servers disk capacity</h1>
</head>
<body>
<h3>Available disk space in listed servers</h3>
<table id = 'report'>
<tr>
    <th>Server</th>
    <th>Drive Name</th>
    <th>Free Space</th>
    <th>Status</th>    
</tr>
"@

Write-Host "creating report"

foreach ($disk in $data)
{
    $server = $disk.pscomputername
    $device = $disk.DeviceID
    $freespace = $disk.Free_Space_Perc
    $status = $disk.status
    

    if ($disk.status -eq 'Offline'){

    
         if ($disk.Free_Space_Perc -le 10){

                $html += "<tr style='mso-border-alt:solid'>
                        <td>$server</td>
                        <td style=`'background:red`'>$device</td>
                        <td>$freespace</td>
                        <td style=`'background:red`'>$status</td>
                        </tr>"
         }
         else{

            $html += "<tr style='mso-border-alt:solid'>
                    <td>$server</td>
                    <td style=`'background:green`'>$device</td>
                    <td>$freespace</td>
                    <td>$status</td>
                    </tr>"   
         }
    }

    else{

        if ($disk.Free_Space_Perc -le 10){

            $html += "<tr style='mso-border-alt:solid'>
                    <td>$server</td>
                    <td style=`'background:red`'>$device</td>
                    <td>$freespace</td>
                    <td>$status</td>
                    </tr>"
        }
        else{

            $html += "<tr style='mso-border-alt:solid'>
                    <td>$server</td>
                    <td style=`'background:green`'>$device</td>
                    <td>$freespace</td>
                    <td>$status</td>
                    </tr>"   
        }
    }
}

$html +="</table>
        </body>
        </html>"



$mail_pass = Get-Content "gmail_pass.txt" | ConvertTo-SecureString
$user = "alesventus@gmail.com"
$From = "hello_kitty@gmail.com"
$To = "alesventus@gmail.com"
$Subject = "hello_kitty@gmail.com tester"
$Password = $mail_pass
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $Password
Send-MailMessage -From "hello_kitty@gmail.com" -To $To -Subject $Subject -body $html -BodyAsHtml -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential
