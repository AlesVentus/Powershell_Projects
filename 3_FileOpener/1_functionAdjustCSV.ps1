Add-Type -AssemblyName System.Windows.Forms

$form = New-Object -TypeName System.Windows.Forms.OpenFileDialog
$form.initialdirectory = "C:\Users\jventua1\Desktop\PS"
$form.filter = "csv files (*.txt)|*.csv|All files (*.*)|*.*"

$form.ShowDialog()

$out = "C:\Users\jventua1\Desktop\PS\3_FileOpener\adjustCSV_result.csv"
$date = Get-Date
$file = $form.FileName
$htmlFile = "C:\Users\jventua1\Desktop\PS\3_FileOpener\FileOpener.html"

$data= @()

$header =@"
<style> 
TABLE {border-width: 1px;border-style: solid} 
th {
padding-top: 12px;
padding-bottom: 12px;
text-align: left;
background-color: #4CAF50;
color: white;
}
tr{
color: black; background-color: white;
}

</style> 
"@

try {
    $csv = import-csv $file
    $result = 'SUCCESS'
}
catch { 
    $result = 'FAILED'
}
Finally{
    $data= @([PSCustomObject]@{File = $file;  Result = $result; Date = $date})
    $result = $data | Export-Csv $out -Append

    $html = Import-Csv -Path $out | ConvertTo-Html -Title "File opener report" -Body "this is fi history" -Head $header | Out-File $htmlFile
    Invoke-Item $htmlFile
}



