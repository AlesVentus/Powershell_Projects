$import = Import-Csv -Path "C:\Users\jventua1\desktop\PS\family.csv"

$set = $import | Select-Object @{name = "meno clena"; Expression = {$_.Name}}, @{name = "poradie clena"; expression = {$_.Number}}

$set[2].'poradie clena' = 213


foreach ($member in $set)

{
    if ($member.'meno clena' -eq "Mama" -and $member.'poradie clena' -ne 2)

    {
        $member.'poradie clena' = 2
        "poradie clena bolo zmenene"
    }
}


$output = $set |Select-Object 'meno clena', 'poradie clena', @{name = "rola"; expression = {$_.'meno clena'.substring(0,1)}}


$output += [PSCustomObject]@{
    'meno clena' = "Pes";
    'poradie clena' = 123;
    rola = "P"
}

$output.Remove(4)

$output | Out-GridView