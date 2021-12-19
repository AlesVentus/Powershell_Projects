[int[]]$array = @(1..9)

$array.Count

$array[2..5]

$array[-3..-1]

$array[0..2+7..8]  # + combine ranges

# count and length are synonims
$array.Count
$array.Length

# how many dimensions array has
$array.Rank


#methods

# clear = set values to default
$array.Clear()

# foreach
$array.ForEach({$_ * $_})

# where 
$array.Where({$_ -eq 5})

# join 
$array -join '|'

# GetUpperBound
$array.GetUpperBound(0)

# multidim arrays
$array2 = New-Object 'object[,]' 10,20
$array2[4,8] = 'Hello'
$array2[9,16] = 'Test'
$array2

# jagged array
$array1 = 1,2,(1,2,3),3
$array1[0]
$array1[1]
$array1[2]
$array1[2][0]
$array1[2][1]

# multicolumn array
$arr = @(
    [PSCustomObject]@{Name = 'David';  Article = 'TShirt'; Size = 'M'},
    [PSCustomObject]@{Name = 'Eduard'; Article = 'Trouwsers'; Size = 'S'}
)

$arr[1].Size