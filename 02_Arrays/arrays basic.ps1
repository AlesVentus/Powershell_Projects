$a =@('aaa', 'bbb', 'ccc', 'ddd', 'eee')

$a.Count

$a.Length

$a.GetUpperBound(0)

#$a.GetType()

#$a[0]

Write-Host ($a[0])


foreach($i in $a)
{
Write-Host ($i + "_TEST")
}



for (($i = 0), ($e = 0); $i -lt 10; $i ++)
{
Write-Host ("$i" + ', ' + "$e")
}


for ($aa = 0; $aa -lt $a.Count; $aa ++)
{
Write-Host ('this is array, ' + $a[$aa])
Test-Connection "c051ma91"
}


