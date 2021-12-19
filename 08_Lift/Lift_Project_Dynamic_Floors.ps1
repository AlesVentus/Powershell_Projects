Add-Type -AssemblyName system.windows.forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form_MAIN = New-Object System.Windows.Forms.Form

$Form_MAIN.Location = New-Object System.Drawing.Size(600,600)

$Form_MAIN.ClientSize = New-Object System.Drawing.point(600,700)

$Form_MAIN.Text = "This is form"



$Graph = $Form_MAIN.CreateGraphics()


$Staring_Floor = 1

$floors = 18
$y_axis = 0

For ($x = 1; $x -le $floors; $x ++)
{
    $y_axis += 20

    $Obj = New-Object System.Windows.Forms.Label
    $Obj.Text = "Floor $x"
    $Obj.Height = 15
    $Obj.Width = 50
    $Obj.BorderStyle = 2
    $Obj.Name = "Floor$x"
    $Obj.Location = New-Object System.Drawing.Point(40,$y_axis)

    $Form_MAIN.Controls.Add($Obj)
}

$Form_MAIN.Controls.AddRange(@($B_Call_Lift))
$controls = $Form_MAIN.controls


$TB_Floor = New-Object System.Windows.Forms.TextBox
$TB_Floor.Text = "1"
$TB_Floor.Multiline = $false
$TB_Floor.Height = 30
$TB_Floor.Width = 30
$TB_Floor.font = New-Object System.Drawing.Font("arial", 16)
$TB_Floor.Location = New-Object System.Drawing.Point(120, 10)

$B_Call_Lift = New-Object System.Windows.Forms.Button
$B_Call_Lift.Text = "Call Lift"
$B_Call_Lift.Width = 60
$B_Call_Lift.Height = 30
$B_Call_Lift.Location = New-Object System.Drawing.Point(120, 50)

$TB_LastFloor = New-Object System.Windows.Forms.TextBox
$TB_LastFloor.Text = "1"
$TB_LastFloor.Multiline = $false
$TB_LastFloor.Height = 30
$TB_LastFloor.Width = 30
$TB_LastFloor.font = New-Object System.Drawing.Font("arial", 16)
$TB_LastFloor.Location = New-Object System.Drawing.Point(120, 100)


$Form_MAIN.Controls.AddRange(@($B_Call_Lift, $TB_Floor, $TB_LastFloor))


function Run_Lift_2
{   
    [int]$LastFloor = $TB_LastFloor.Text
    [int]$selection = $TB_Floor.Text


    if ($selection -gt $LastFloor)
    {
        For ($i = $LastFloor; $i -le $selection; $i++)
        {
            $active_color = 'Floor' + $i            
            $controls[$active_color].backcolor = "pink"
            Start-Sleep -millisecond 120

            if($i -gt 1)
            {
                $passive_color = 'Floor' + ($i - 1)     
                $controls[$passive_color].backcolor = 0
                Start-Sleep -millisecond 120
            }
        }

        $TB_LastFloor.Text = $selection
     }



    if ($LastFloor -gt $selection)
    {
        For ($i = $LastFloor; $i -ge $selection; $i--)
        {
            $active_color = 'Floor' + $i            
            $controls[$active_color].backcolor = "pink"
            Start-Sleep -millisecond 120

            if($i -lt $floors)
            {
                $passive_color = 'Floor' + ($i + 1)     
                $controls[$passive_color].backcolor = 0
                Start-Sleep -millisecond 120
            }
        }
        $TB_LastFloor.Text = $selection
    }
}



$B_Call_Lift.add_click({Run_Lift_2})


$Form_MAIN.ShowDialog()