
Import-Module  sqlserver


function Export-SSISProjectSSISDB
 {
 param
 (
     [Parameter(position=0, mandatory=$true)][string]$Instance,
     [Parameter(position=1, mandatory=$true)][string]$OutputDir
 )
 

 Remove-Item -LiteralPath $OutputDir -Force -Recurse

 [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices") | Out-Null
  
 $connstring = "Data source=$($Instance);Initial Catalog=master;Integrated Security=SSPI;"
 $sqlconn = New-Object System.Data.SqlClient.SqlConnection $connstring 
 $SSIS = New-Object "Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices" $sqlconn

 $catalog = $SSIS.Catalogs["SSISDB"]
 foreach($folder in $catalog.Folders)
 {  
     New-Item -ItemType Directory -Name $folder.Name -Path $OutputDir  -Force | Out-Null
  
     $folderpath = $outputdir + "\" + $folder.Name
  
     $projects = $folder.Projects

     if($projects.Count -gt 0)
     {
          foreach($project in $projects)
          {  
            New-Item -ItemType Directory -Name $project.Name -Path $folderpath  -Force | Out-Null
            $projectpath = $folderpath + "\" + $project.Name + "\" + $project.Name  + ".zip" 
            $unzipDest = $folderpath + "\" + $project.Name 
            
               Write-Host "Exporting to $($projectpath) ..."; 
               [System.IO.File]::WriteAllBytes($projectpath, $project.GetProjectBytes()) 
               Unzip $projectpath $unzipDest
  
          }
     }
 }
 }
 
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

 Export-SSISProjectSSISDB 'preprod.sql.dhub.sydbank.net' 'T:\!IT_Forretningsprocesser\bruger\naer\ispac'
