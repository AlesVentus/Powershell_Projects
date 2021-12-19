$csv = Import-Csv '.\arrays replace.csv' -Header 'Colour', 'Country', 'Name', 'Gender'

foreach ($item in $csv) {
    
    if ($item.gender -eq '') {
        $item.gender = 'REPLACED'
    }
    
}

# other version
$csv.ForEach({if ($_.gender -eq 'REPLACED') {$_.gender = "NEW REPLACE"}})

# get rid of last row
$csv[0..($csv.Length-2)]


# replace
foreach ($item in $csv) {
    
    if ($item.Colour -match '>') {
        $item.Colour = $item.Colour.Replace('>', 'XXX')        
    }
    
}