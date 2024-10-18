USE [DropZone]
GO
/****** Object:  Table [dbo].[ObjReferences]    Script Date: 16-10-2024 21:02:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjReferences](
	[DatabaseName] [nvarchar](max) NULL,
	[SchemaName] [nvarchar](max) NULL,
	[ObjName] [nvarchar](max) NULL,
	[Script] [nvarchar](max) NULL,
	[referenced_database_name] [nvarchar](max) NULL,
	[referenced_schema_name] [nvarchar](max) NULL,
	[referenced_entity_name] [nvarchar](max) NULL,
	[type_desc] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[uspObjReferences]    Script Date: 16-10-2024 21:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
	CREATE PROCEDURE [dbo].[uspObjReferences]
	AS 

TRUNCATE TABLE DropZone.dbo.ObjReferences

DECLARE @DB_NAME NVARCHAR(max)

DECLARE SnapshotCur CURSOR FOR 
SELECT name 
FROM sys.databases
WHERE name  NOT IN
(
N'master',
N'MellemTB',
N'model',
N'msdb' ,
N'tempdb',
N'BIZ_BankDataDeletes',
N'BIZ_Baseline',
N'BIZ_Extract', 
N'BIZ_Staging',
N'ReportServer_DW_PreProdTempDB',
N'ReportServer_DW_Prod',
N'ReportServer_DW_PreProd',
N'ReportServer_DW_ProdTempDB',
N'ReportServer_sy001dhub04',
N'ReportServer_sy001dhub04TempDB',
N'SelfServiceRisikoValidering', 
N'HR', 
--N'LZ01', 
--N'LZ47', 
N'Personale',
N'SelfServiceHR',
N'SSISDB',
N'SSISDB_HIS'
)
ORDER BY name

 
OPEN SnapshotCur
FETCH NEXT FROM SnapshotCur INTO @DB_NAME
WHILE @@FETCH_STATUS = 0  
BEGIN

PRINT @DB_NAME   
DECLARE @sql NVARCHAR(MAX) = 'use ' + @DB_NAME + '

 INSERT INTO DropZone.dbo.ObjReferences
	SELECT DB_NAME() DatabaseName, 
	       c.name SchemaName,
        b.name ObjName, 
								OBJECT_DEFINITION (OBJECT_ID(CONCAT(c.name,''.'',b.name))) SpScript, 
        COALESCE(a.referenced_database_name, DB_NAME()) referenced_database_name,
        CASE WHEN referenced_schema_name = '''' THEN ''dbo'' ELSE referenced_schema_name END referenced_schema_name,
        a.referenced_entity_name,
								b.type_desc
FROM sys.sql_expression_dependencies a
RIGHT JOIN sys.objects b ON a.referencing_id = b.object_id 
RIGHT JOIN sys.schemas c ON c.schema_id = b.schema_id
WHERE b.type = ''P'' or b.type = ''V''
AND 
(
    (a.referenced_schema_name IS NULL AND a.referenced_entity_name IS NULL)
  OR a.referenced_schema_name IS NOT NULL
)



	INSERT INTO DropZone.dbo.ObjReferences
	(
	    DatabaseName,
	    SchemaName,
	    ObjName,
	    Script,
	    referenced_database_name,
	    referenced_schema_name,
	    referenced_entity_name,
	    type_desc
	) 
	SELECT a.DatabaseName,
           a.SchemaName,
           a.ObjName,
           a.Script,
           a.referenced_database_name,
           a.referenced_schema_name,
           a.referenced_entity_name,
           a.type_desc 
 FROM (
	
      SELECT NULL DatabaseName,
             NULL SchemaName,
             NULL ObjName,
      							ROUTINE_DEFINITION Script,
      							SPECIFIC_CATALOG referenced_database_name,
      							SPECIFIC_SCHEMA referenced_schema_name,
      							SPECIFIC_NAME referenced_entity_name,
      							''SQL_STORED_PROCEDURE'' type_desc
      FROM INFORMATION_SCHEMA.ROUTINES 
      WHERE ROUTINE_TYPE = ''PROCEDURE''
       
      	UNION
      
      SELECT NULL DatabaseName,
             NULL SchemaName,
             NULL ObjName,
      							OBJECT_DEFINITION (OBJECT_ID(CONCAT(TABLE_SCHEMA,''.'',TABLE_NAME))) SpScript,  
              TABLE_CATALOG referenced_database_name,
             TABLE_SCHEMA referenced_schema_name,
             TABLE_NAME referenced_entity_name,
             TABLE_TYPE type_desc
      FROM INFORMATION_SCHEMA.TABLES
      WHERE TABLE_TYPE IN (''BASE TABLE'',''VIEW'')
      
      
      ) 
						a  LEFT JOIN  	
						(
 
      SELECT DatabaseName,
             SchemaName,
             ObjName,
             Script,
             referenced_database_name,
             referenced_schema_name,
             referenced_entity_name,
             type_desc 
      FROM DropZone.dbo.ObjReferences 
       
      ) b 

	ON b.referenced_database_name = a.referenced_database_name
	AND b.referenced_schema_name = a.referenced_schema_name
	AND b.referenced_entity_name = a.referenced_entity_name
	WHERE b.ObjName IS NULL
 
' 
EXEC (@sql)
 
 
	FETCH NEXT FROM SnapshotCur INTO @DB_NAME
END;

CLOSE SnapshotCur
DEALLOCATE SnapshotCur

 
 
 
GO
