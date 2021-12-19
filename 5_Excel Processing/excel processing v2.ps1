function process_excel
{
    [CmdletBinding()]

    param([parameter(mandatory=$true, HelpMessage= 'Write down name of file', ValueFromPipeline = $true)]
    [string[]]$file_name)    

    try
    {
        $DesktopPath = [Environment]::GetFolderPath("Desktop")
        $path = "$DesktopPath\PS\Excel Processing\"
        $file = $path + $file_name


        $tmp_csv = "$path/tmp_file.csv"
        $path_result = "$path" + [io.path]::GetFileNameWithoutExtension($file_name) + "_result.csv"

        $excel = Import-Excel -path $file -NoHeader
        $excel | Export-Csv -Path $tmp_csv -NoTypeInformation

        $data = Import-Csv -Path $tmp_csv

        $result = @()

        foreach ($x in $data)
        {
            if ($x.P1 -match "Fornitore          :")
            {
                $firm = $x.P1
                $firm = $firm.Substring(0,28)
                $firm = $firm.Substring(22, 6)
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

        $result | Export-csv -Path $path_result -NoTypeInformation
        write-host -f Green "File successfully processed"
    }

    catch
    {
        Write-Warning $error[0]
    }
    finally
    {
        if (Test-Path -path $tmp_csv)
        {
            Remove-Item -Path $tmp_csv
        }
    }
}


<# testing #>
process_excel -file_name "Raw_Data.xlsx"

process_excel -file_name "Raw_Data.xls"

process_excel -file_name "fdskajl.xlsx"

process_excel -file_name "Raw_Data.csv"