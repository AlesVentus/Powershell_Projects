function change-date
{
[CmdletBinding()]

    param([parameter(mandatory=$true, HelpMessage= 'write path of the folder', ValueFromPipeline = $true)]
    [alias('MyPath')]
    [string[]]$path)

    Add-Type -AssemblyName system.windows.forms
    [System.Windows.Forms.Application]::EnableVisualStyles()

    #$path  = get-item -Path "C:\Users\jventua1\Desktop\tasks"

    function get-dates
    {
        $global:folders = @()
        $files = @()
        $result_folders = $null
        $result_files = $null

        $content = Get-ChildItem -Directory $path

        ForEach ($object in $content)
        {
            if ($object.psiscontainer -eq $true)
            {
                $global:folders += [pscustomobject]@{LastDate = $object.LastWriteTime; name= $object.name}
            }
            else
            {
                $files += [pscustomobject]@{name= $object.name; LastDate = $object.LastWriteTime}
            }
        }

        $global:result_folders = $global:folders | Out-String
        $global:result_files = $files | Out-String
    }

    get-dates

    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "Content"
    $Form.StartPosition = 1
    $Form.ClientSize = New-Object System.Drawing.Point(1050,600)


    $tb_Folders = New-Object System.Windows.Forms.TextBox
    $tb_Folders.Location = New-Object System.Drawing.Point(20,40)
    $tb_Folders.Multiline = $true
    $tb_Folders.Height = 500
    $tb_Folders.Width = 400
    $tb_Folders.Text = $result_folders

    $tb_Files = New-Object System.Windows.Forms.TextBox
    $tb_Files.Location = New-Object System.Drawing.Point(440,40)
    $tb_Files.Multiline = $true
    $tb_Files.Height = 500
    $tb_Files.Width = 400
    $tb_Files.Text = $result_files

    $btn_Change = New-Object System.Windows.Forms.Button
    $btn_Change.Location = New-Object System.Drawing.Point(900,40)
    $btn_Change.Text = "Change date"
    $btn_Change.name = "btn_change_date"
    $btn_Change.Width = 120
    $btn_Change.Add_Click($Button_Click)



    $Button_Click = 
    {param($sender,$eventarg)

    
        $content | ForEach-Object {$_.LastWriteTime = (get-date)}
        get-dates
        $tb_Folders.Text = $result_folders
        $tb_Folders.Refresh()
    
    }


    $Form.Controls.AddRange(@($tb_Folders, $tb_Files, $btn_Change))

    $Form.ShowDialog()

}



change-date -path "C:\Users\jventua1\Desktop\tasks"