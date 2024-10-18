$ErrorActionPreference = "Stop"

function InsertIntoSSISTaskSQL
{
    param([Object]$SSISName, [Object]$DTSID, [Object]$SQLQuery, [Object]$Type, [Object]$RefId)
 
    $command = New-Object System.Data.SQLClient.SQLCommand 
    $command = $connection.CreateCommand() 
    $command.CommandText = $sql_InsertIntoSSISTaskSQL
    $command.Parameters.AddWithValue('@SSISName', $SSISName)
    $command.Parameters.AddWithValue('@DTSID', $DTSID)
    $command.Parameters.AddWithValue('@SQLQuery', $SQLQuery)
    $command.Parameters.AddWithValue('@Type', $Type)
    $command.Parameters.AddWithValue('@RefId', $RefId)
    $command.ExecuteNonQuery()     
} 
function ExecNoParamQuery
{
    param([string]$CommandText)

    $command = New-Object System.Data.SQLClient.SQLCommand        
    $command = $connection.CreateCommand() 
    $command.CommandText = $CommandText
    $command.ExecuteNonQuery()  
}

$rootPath = "T:\!IT_Forretningsprocesser\bruger\naer\ispac\DHUB\"
 
$serverName = "preprod.sql.dhub.sydbank.net"
$databaseName = "Dropzone"
$connection = New-Object System.Data.SQLClient.SQLConnection
$connection.ConnectionString = "server='$serverName';database='$databaseName';trusted_connection=true;"
$connection.Open()

$sql_InsertIntoSSISConnections = 'INSERT INTO dbo.SSISConnections VALUES (@SSISName, @CreationName, @DTSID, @RefId, @ConnectionString)'
$sql_TruncateSSISConnections = 'TRUNCATE TABLE dbo.SSISConnections'
$sql_InsertIntoSSISTaskSQL = 'INSERT INTO dbo.SSISTaskSQL VALUES (@SSISName, @DTSID, @SQLQuery, @Type, @RefId)'
$sql_TruncateSSISTaskSQL = 'TRUNCATE TABLE dbo.SSISTaskSQL'


$Paths = Get-ChildItem -Path $rootPath -Filter *.dtsx -Recurse  | ForEach-Object{$_}  


# Truncate table before insert
ExecNoParamQuery $sql_TruncateSSISTaskSQL
ExecNoParamQuery $sql_TruncateSSISConnections
  
 
foreach($Path in $Paths) {
    
    if($Path.Directory.Name -ne "BIMLSyncPreProd"){ #Unlad at læse bestemte projekter
 
        # Connection Managers
        [xml] $xmlDoc = Get-Content -Raw $Path.FullName  
        Select-Xml -Xml $xmlDoc -Namespace @{
            ns = 'www.microsoft.com/SqlServer/Dts'
        }  //ns:Executable/ns:ConnectionManagers/ns:ConnectionManager  |
        ForEach-Object { 
            $con = [PSCustomObject] @{
                CreationName = $_.Node.CreationName
                DTSID = $_.Node.DTSID
                refId = $_.Node.refId
                ConnectionString = $_.Node.ObjectData.ConnectionManager.ConnectionString 
            }
        
        $command = New-Object System.Data.SQLClient.SQLCommand    
        $command = $connection.CreateCommand() 
        $command.CommandText = $sql_InsertIntoSSISConnections
        $command.Parameters.AddWithValue('@SSISName', $Path.Name)
        $command.Parameters.AddWithValue('@CreationName', $con.CreationName)
        $command.Parameters.AddWithValue('@DTSID', $con.DTSID)
        $command.Parameters.AddWithValue('@RefId', $con.refId)
        $command.Parameters.AddWithValue('@ConnectionString', $(If ($null -eq $con.ConnectionString) {[System.DBNull]::Value} Else {$con.ConnectionString}))
        $command.ExecuteNonQuery()  

        }
 

        # sql task
        [xml] $xmlDoc = Get-Content -Raw $Path.FullName  
        Select-Xml -Xml $xmlDoc -Namespace @{
            ns = 'www.microsoft.com/sqlserver/dts/tasks/sqltask'
        }  //ns:SqlTaskData    |
        ForEach-Object { 
            $node = [PSCustomObject]@{ 
                Connection = $_.Node.Connection  
                SqlStatementSource = $(If ($null -eq $_.Node.SqlStatementSource ) {[System.DBNull]::Value} Else {$_.Node.SqlStatementSource })
            } 
 
InsertIntoSSISTaskSQL $Path.Name $node.Connection $node.SqlStatementSource "Execute sql task" "" 
        }
 
        # Data flow task
        [xml] $xmlDoc = Get-Content -Raw $Path.FullName  
        Select-Xml -Xml $xmlDoc -Namespace @{
                  ns = 'www.microsoft.com/SqlServer/Dts'
        }  //ns:ObjectData/pipeline/components/component    |
        ForEach-Object { 
            $ex = [PSCustomObject]@{ 
                component = $_.Node
                connection = $_.Node.connections.connection
                property = $_.Node.properties.property  
            } 
        
            if($ex.component.componentClassID -eq "Microsoft.OLEDBSource" -Or 
            $ex.component.componentClassID -eq "Microsoft.OLEDBDestination")  { 
            
                for ($k = 0; $k -lt $ex.property.Count; $k++) {

                    if($ex.property[$k].UITypeEditor -eq 
                    "Microsoft.DataTransformationServices.Controls.ModalMultilineStringEditor" -And 
                    ![string]::IsNullOrEmpty($ex.property[$k].'#text')) {

InsertIntoSSISTaskSQL $Path.Name $ex.connection.connectionManagerRefId $ex.property[$k].'#text' 'Data flow task UITypeEditor' $ex.component.refId
                    
                        }  elseif ($ex.property[$k].name -eq 
                        "OpenRowset" -And 
                        ![string]::IsNullOrEmpty($ex.property[$k].'#text')) {

InsertIntoSSISTaskSQL $Path.Name $ex.connection.connectionManagerRefId $ex.property[$k].'#text' 'Data flow task OpenRowset' $ex.component.refId
                        
                    }
                } 
            }  
        } 
 
    }
}
$connection.Close();

  

 




 

 

