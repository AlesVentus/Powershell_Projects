#
#(Get-Credential).Password | ConvertFrom-SecureString | Out-File C:\Users\jventua1\Desktop\PS\1_DiskReport\pass.txt
#


<# Must run under the CISCO #>
try
{
    $pass = get-Content 'C:\Users\jventua1\Desktop\PS\1_DiskReport\passX.txt'  -ErrorAction -stop| ConvertTo-SecureString
}

catch
{
    Write-Host -f DarkRed "Cannot get the password"
}
trap {"Error found."}

$user = 'jventua1sa2'
$credential = New-Object System.Management.Automation.PSCredential($user, $pass)
$report = 'C:\Users\jventua1\Desktop\PS\1_DiskReport\report_disk_space.html'  

#$data = Get-WmiObject -class win32_logicaldisk  -ComputerName M5257150  | Select-Object PSComputerName, @{'Name'='DriveName';'Expression'={$_.deviceID}}, @{'Name'='Free_Space_Perc';'Expression'={[math]::Round($_.freespace/$_.size*100)}} 


$data = Get-WmiObject -class win32_logicaldisk –credential $credential  -ComputerName C051M436,c051ma91 |  Where-Object {$_.drivetype -eq 3} | Select-Object PSComputerName, DeviceID, @{'Name'='Free_Space_Perc';'Expression'={[math]::Round($_.FreeSpace /1GB)}} 


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
<h1>This is disk report</h1>
</head>
<body>
<h3>this is content</h3>
<table id = 'report'>
<tr>
    <th>Server</th>
    <th>Drive Name</th>
    <th>Free Space</th>    
</tr>
"@

Write-Host "creating report"

foreach ($disk in $data)
{
    $server = $disk.pscomputername
    $device = $disk.DeviceID
    $freespace = $disk.Free_Space_Perc
    
    if ($disk.Free_Space_Perc -le 10)
        {
        $html += "<tr style='mso-border-alt:solid'>
                <td>$server</td>
                <td style=`'background:red`'>$device</td>
                <td>$freespace</td>
                </tr>"
        }
        else
        {
        $html += "<tr style='mso-border-alt:solid'>
                <td>$server</td>
                <td style=`'background:green`'>$device</td>
                <td>$freespace</td>
                </tr>"   
        }

}

$html +="</table>
        </body>
        </html>"

Send-MailMessage -from 'hello_kitty@gmail.com' -to 'ales.ventus@jci.com' -Subject 'this is test' -SmtpServer smtp.jci.com -Port 25 -body $html -BodyAsHtml


