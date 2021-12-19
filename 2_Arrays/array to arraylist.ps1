$File = Import-Csv -Path "C:\Users\jventua1\desktop\PS\family.csv"

$resourceFiles = New-Object System.Collections.ArrayList(,$File )

$resourceFiles.add($File)

$resourceFiles.GetType()

$resourceFiles.Removeat(1)


$second = New-Object System.Collections.ArrayList($null)
$second.AddRange($File)