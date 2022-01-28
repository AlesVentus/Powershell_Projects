$DesktopPath = [Environment]::GetFolderPath("Desktop")

class FolderGenerator{
    hidden[System.IO.DirectoryInfo]$DefaultPath = "$DesktopPath\tester\"
    [string]$RootName = "WoWw"
    [int]$NumberOfFiles = 1
    [byte[]]$ByteHash = 0

    FolderGenerator(){
        $This.GenerateByte()
    }

    [void] SetRootName([string]$RootName){
        $This.RootName = $RootName
        $This.GenerateByte()
    }

    [void] SetNumberOfFiles([int]$NumberOfFiles){
        $This.NumberOfFiles = $NumberOfFiles
    }

    [void] GenerateByte(){
        $enc = [System.Text.Encoding]::UTF8
        $ByteArray = $enc.GetBytes($this.RootName)
        $This.ByteHash = $ByteArray
    }

    [void] Create(){

        for ($i = 0; $i -lt $this.NumberOfFiles ; $i++) {
            $Folder = $This.RootName + "_" + $i
            New-Item -ItemType Directory -Path $This.DefaultPath -Name $Folder
            
            $Path = Join-Path -Path $This.DefaultPath -ChildPath $Folder
            $File = Join-Path -path $Path -ChildPath "File_$i.txt"
            Set-Content -Path $File -Value $this.ByteHash
            
        }

    }

}


function Create-Folders()
{
    [CmdletBinding()]
    param (
        $RootName,
        $NumberOfFiles
    )
    $x = [FolderGenerator]::new()
    $x.SetRootName($RootName)
    $x.SetNumberOfFiles($NumberOfFiles)

    $x.Create()
}

Create-Folders -RootName Lubko_a_Tomasko -NumberOfFiles 10