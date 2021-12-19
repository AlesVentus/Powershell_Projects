$data = @(
       [pscustomobject]@{FirstName='Kevin';LastName='Marquette';number = 50}
       [pscustomobject]@{FirstName='John'; LastName='Doe'; number = 45}
       [pscustomobject]@{FirstName='Marc'; LastName='Doe'; number = 45}
       [pscustomobject]@{FirstName='Jim'; LastName='Doe'; number = 45}
       
   )


   $data.number[0]
   $data[0].number


$data.FirstName -join '-'

$data.FirsName -ne 'Jim'

$data += [pscustomobject]@{FirstName='Tom'; LastName='Jones'; number = 45}

$x = 0

foreach ($i in $data.number)
{
$x += $i
}

$x