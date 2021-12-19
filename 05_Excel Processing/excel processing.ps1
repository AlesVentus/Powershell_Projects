$excel = Import-Excel -path "C:\Users\jventua1\Desktop\PS\Excel Processing\Raw_Data.xlsx" -NoHeader

$path = "C:\Users\jventua1\Desktop\PS\Excel Processing\Raw_Data.csv" 
$excel | Export-Csv -Path $path -NoTypeInformation
$data = Import-Csv -Path $path 

#$data.Where({$_.P4 -eq "EUR"})

$result = @()

foreach ($x in $data)
{
    if ($x.P1 -match "Fornitore          :")
    {
        $firm = $x.P1
        $firm = $firm.Substring(0,28)
        $firm = $firm.Substring(22, 6)
        #Write-Host $firm
    }

    if ($x.P4 -match "EUR")
    {
        $invoice = $x.P1
        $date    = $x.P2
        $amount  = $x.p5
        
        $myObject = [PSCustomObject]@{
            Company  = $firm
            Invoice  = $invoice
            Date     = $date
            Amount   = $amount          
        }

        $result += $myObject
    }
}

$result | Export-csv -Path "C:\Users\jventua1\Desktop\PS\Excel Processing\processed_Data.csv" -NoTypeInformation