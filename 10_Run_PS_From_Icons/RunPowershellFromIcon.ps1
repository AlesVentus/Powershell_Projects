$report = 'C:\Coding\Powershell\Powershell_Projects\1_DiskReport\report_disk_space.html'  

$data = Get-WmiObject -class win32_logicaldisk  -ComputerName $env:COMPUTERNAME |  Where-Object {$_.drivetype -eq 3} | Select-Object PSComputerName, DeviceID, @{'Name'='Free_Space_Perc';'Expression'={[math]::Round($_.FreeSpace /1GB)}} 


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

#bcg_yellow{
    background-color: yellow
}

</style>

<script>
function myFunction() {

  var x = document.getElementById('content').innerHTML;
  switch (x)
  {
    case 'This is nice report':
    document.getElementById('content').innerHTML = 'THIS IS REPORT !';
    break;

    case 'THIS IS REPORT !':
    document.getElementById('content').innerHTML = 'This is nice report';
    break;
  }


}
</script>

<head>
<h1>This is disk report</h1>
</head>
<body>
<h3 id = 'content' onclick="myFunction()">This is nice report</h3>
<h3 id = 'content2' ">Check this javas script above</h3>
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
                <td id = `'bcg_yellow`'>$freespace</td>
                </tr>"
        }
        else
        {
        $html += "<tr style='mso-border-alt:solid'>
                <td>$server</td>
                <td style=`'background:green`'>$device</td>
                <td id = `"bcg_green`">$freespace</td>
                </tr>"   
        }

}

$html +="</table>
        </body>
        </html>"

convertto-html  -Head $html | Out-File $report

Invoke-Item -Path $report 

#Send-MailMessage -from 'hello_kitty@gmail.com' -to 'ales.ventus@jci.com' -Subject 'this is test' -SmtpServer smtp.jci.com -Port 25 -body $html -BodyAsHtml


