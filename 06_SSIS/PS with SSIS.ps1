# Variables
$SSISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"
$TargetServerName = "c051ma91"
$TargetFolderName = "Project1Folder"
$ProjectFilePath = "C:\Projects\Integration Services Project1\Integration Services Project1\bin\Development\Integration Services Project1.ispac"
$ProjectName = "Integration Services Project1"

# Load the IntegrationServices assembly
$loadStatus = [System.Reflection.Assembly]::Load("Microsoft.SQLServer.Management.IntegrationServices, "+
    "Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91, processorArchitecture=MSIL")

# Create a connection to the server
$sqlConnectionString = "Data Source=" + $TargetServerName + ";Initial Catalog=master;Integrated Security=SSPI;"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

# Create the Integration Services object
$integrationServices = New-Object $SSISNamespace".IntegrationServices" $sqlConnection

# Get the Integration Services catalog
$catalog = $integrationServices.Catalogs["SSISDB"]

$catalog.Folders | Out-GridView


#get all packages in catalog
foreach ($fld in $catalog.Folders)
{
    Write-Host $fld.Projects

    foreach ($p in $fld.Projects.packages)
    {
        $p.Name
    }
}


#export ispac project to disk
$proj = "danubia_gl_extracts"
$x = $catalog.Folders | where {$_.name -eq $proj}
$Project = $x.Projects | where {$_.name -eq $proj }
$ISPAC = $Project.GetProjectBytes()
[System.IO.File]::WriteAllBytes(("C:\Users\jventua1SA2\Desktop\ssis" + "\test" + $Project.Name + ".ispac"),$ISPAC)


#export dtsx package to disk
$package = $Project.Packages["99_UploadandClean.dtsx"]
$dtsx = $package.


# Create the target folder
$folder = New-Object Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder ($catalog, "Test_av_2","Folder description test")
$folder.Create()


# deploy it project to catalog
# ProjectName must be the same as name of the project in ispac file
$ProjectFilePath = "C:\Users\jventua1SA2\Desktop\ssis\test.ispac"
$ProjectName = "Danubia_GL_Extracts"
$folder = $catalog.Folders["Test_av_2"]
[byte[]] $projectFile = [System.IO.File]::ReadAllBytes($ProjectFilePath)
#$folder.DeployProject($ProjectName, $projectFile)
$folder.DeployProject($ProjectName, $projectFile)




