


/*
Brugeren indtaster tabel, schema og database navn, kan bruges %% for wildcard
Systemet finder en liste af tabeller via ovenstående kriterier, de bliver gemt som "tables"
Systemet går videre og finder alle de views hvor ovenstående tabeller har en reference til
Systemet går videre og finder alle de SP'er hvor ovenstående tabeller har en reference til
Så finder systemet alle de Views som indgår i ovenstående Views og SP'er (en SP eller et view kan bruges i et andet view)
Så finder systemet alle de SP'er som indgår i ovenstående Views og SP'er (en SP eller et view kan bruges i en anden SP)
Derefter tager systemet alle de fundende referencer for oven og søger alle de steder ovennævnte bliver brugt i SSIS
Tilsidst vises resultaterne til brugeren
*/


-- USER INPUT
 DECLARE @searchObj VARCHAR(200) = '%DB_virksomheder%'
 DECLARE @searchSch VARCHAR(200) = '%Experian%'
 DECLARE @searchDb VARCHAR(200) = '%LZSB%'
	DECLARE @SpScript VARCHAR(200) = 'insert into LZSB.Experian.DB_virksomheder'
	 
	-------------------------------------------------------------------------
	-- Find, via user indput, en række tabeller, som skal bruges til at finde resten af referencerne med

 DROP TABLE IF EXISTS #Tables
 SELECT DISTINCT referenced_database_name,
        referenced_schema_name,
        referenced_entity_name 
	INTO #Tables
 FROM DropZone.dbo.ObjReferences
 WHERE referenced_entity_name LIKE @searchObj 
 AND referenced_schema_name LIKE @searchSch
	AND referenced_database_name LIKE @searchDb



	-------------------------------------------------------------------------
	-- Hvilke views har tabellerne en reference til 

 DROP TABLE IF EXISTS #Tabel_Til_ViewRelation
 SELECT *
	INTO #Tabel_Til_ViewRelation
 FROM DropZone.dbo.ObjReferences
 WHERE referenced_entity_name LIKE @searchObj 
 AND referenced_schema_name LIKE @searchSch
	AND referenced_database_name LIKE @searchDb
	AND type_desc = 'VIEW'



	-------------------------------------------------------------------------
	-- Hvilke SP'er har tabellerne en reference til 

 DROP TABLE IF EXISTS #Tabel_Til_SP_Relation
 SELECT * 
	INTO #Tabel_Til_SP_Relation
 FROM DropZone.dbo.ObjReferences
 WHERE referenced_entity_name LIKE @searchObj 
 AND referenced_schema_name LIKE @searchSch
	AND referenced_database_name LIKE @searchDb
	AND type_desc = 'SQL_STORED_PROCEDURE'
	AND Script LIKE '%'+@SpScript+'%'



	-------------------------------------------------------------------------
	-- Preprare next step

	DROP TABLE IF EXISTS #View_Til_ViewOgSP_Relation
	CREATE TABLE  #View_Til_ViewOgSP_Relation
(
[DatabaseName] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS  NULL,
[SchemaName] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS  NULL,
[ObjName] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS  NULL,
[Script] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS NULL,
[referenced_database_name] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS NULL,
[referenced_schema_name] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS NULL,
[referenced_entity_name] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS NULL,
[type_desc] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS NULL
) ON [PRIMARY] 
GO

DROP TABLE IF EXISTS #SP_Til_ViewOgSP_Relation
CREATE TABLE #SP_Til_ViewOgSP_Relation
(
[DatabaseName] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS  NULL,
[SchemaName] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS  NULL,
[ObjName] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS  NULL,
[Script] [NVARCHAR] (MAX) COLLATE Danish_Norwegian_CI_AS NULL,
[referenced_database_name] [NVARCHAR] (max) COLLATE Danish_Norwegian_CI_AS NULL,
[referenced_schema_name] [nvarchar] (max) COLLATE Danish_Norwegian_CI_AS NULL,
[referenced_entity_name] [nvarchar] (max) COLLATE Danish_Norwegian_CI_AS NULL,
[type_desc] [nvarchar] (max) COLLATE Danish_Norwegian_CI_AS NULL
) ON [PRIMARY]  
GO

DROP TABLE IF EXISTS #TabelViewSP_Til_SSIS_Relation
CREATE TABLE #TabelViewSP_Til_SSIS_Relation
(
SearchObjName NVARCHAR(200),
SearchSchName NVARCHAR(200),
SearchDbName NVARCHAR(200),
[SSISName] NVARCHAR(200),
[Connection] NVARCHAR(200),
[SQLQuery] NVARCHAR(MAX),
[Type] NVARCHAR(MAX),
[RefId] NVARCHAR(MAX),
[isEnabled] BIT  NULL
)

	 

-------------------------------------------------------------------------
-- Hvilke Views og SP'er har Viewsne referencer til 

DECLARE @ViewDatabaseName VARCHAR(100),  @ViewSchemaName VARCHAR(100),  @ViewObjName VARCHAR(100) 
 
DECLARE SnapshotCur CURSOR FOR 
SELECT DatabaseName,
       SchemaName,
       ObjName
FROM #Tabel_Til_ViewRelation
 
OPEN SnapshotCur
FETCH NEXT FROM SnapshotCur INTO  @ViewDatabaseName , @ViewSchemaName , @ViewObjName  
WHILE @@FETCH_STATUS = 0  
BEGIN 

 INSERT INTO  #View_Til_ViewOgSP_Relation
 SELECT *  
 FROM DropZone.dbo.ObjReferences
 WHERE referenced_entity_name LIKE @ViewObjName 
 AND referenced_schema_name LIKE @ViewSchemaName
	AND referenced_database_name LIKE @ViewDatabaseName
 
FETCH NEXT FROM SnapshotCur INTO  @ViewDatabaseName , @ViewSchemaName , @ViewObjName 
END;

CLOSE SnapshotCur
DEALLOCATE SnapshotCur



-------------------------------------------------------------------------
-- Hvilke Views og SP'er har SP'erne referencer til 

DECLARE @SpDatabaseName VARCHAR(100),  @SpSchemaName VARCHAR(100),  @SpObjName VARCHAR(100) 
 
DECLARE SnapshotCur CURSOR FOR 
SELECT DatabaseName,
       SchemaName,
       ObjName
FROM #Tabel_Til_SP_Relation
 
OPEN SnapshotCur
FETCH NEXT FROM SnapshotCur INTO  @SpDatabaseName , @SpSchemaName , @SpObjName  
WHILE @@FETCH_STATUS = 0  
BEGIN 

 INSERT INTO  #SP_Til_ViewOgSP_Relation
 SELECT *
 FROM DropZone.dbo.ObjReferences
 WHERE referenced_entity_name LIKE @SpObjName 
 AND referenced_schema_name LIKE @SpSchemaName
	AND referenced_database_name LIKE @SpDatabaseName
 
FETCH NEXT FROM SnapshotCur INTO @SpDatabaseName , @SpSchemaName , @SpObjName 
END;

CLOSE SnapshotCur
DEALLOCATE SnapshotCur



	------------------------------
	-- SSIS referencer baseret på resultater for oven

	DROP TABLE IF EXISTS #temp
SELECT a.SSISName, 
       a.SQLQuery,
       a.Type, 
       b.CreationName, 
       b.ConnectionString,
							        CASE WHEN b.CreationName = 'OLEDB' OR  LEFT(b.CreationName,7) = 'ADO.NET' 
								     THEN SUBSTRING(
																		b.ConnectionString, 
																		(CHARINDEX('Initial Catalog=' ,b.ConnectionString))+16, 
																		(CHARINDEX(';',b.ConnectionString,CHARINDEX('Initial Catalog=' ,b.ConnectionString)) - CHARINDEX('Initial Catalog=' ,b.ConnectionString)-16)
													     )
													ELSE b.ConnectionString 
								END Connection  
								, a.RefId
INTO #temp
FROM DropZone.dbo.SSISTaskSQL a
    LEFT JOIN DropZone.dbo.SSISConnections b
        ON CASE WHEN a.Type LIKE 'Data flow%' THEN  b.DTSID
                WHEN a.Type = 'Execute sql task' THEN b.RefId 
											END = a.DTSID  AND b.SSISName = a.SSISName 
	WHERE  a.SQLQuery NOT LIKE '%EXEC LogSSIS%'


	DECLARE @SSIS_DatabaseName VARCHAR(100),  @SSIS_SchemaName VARCHAR(100),  @SSIS_ObjName VARCHAR(100) 


DECLARE SnapshotCur CURSOR FOR 
	SELECT referenced_database_name DatabaseName,
           referenced_schema_name SchemaName,
           referenced_entity_name ObjName
	FROM #Tables
	WHERE referenced_entity_name IS NOT NULL
	UNION
	SELECT DatabaseName,
           SchemaName,
           ObjName 
 FROM #Tabel_Til_ViewRelation
	WHERE ObjName IS NOT NULL
	UNION
	SELECT DatabaseName,
           SchemaName,
           ObjName 
 FROM #Tabel_Til_SP_Relation
	WHERE ObjName IS NOT NULL
	UNION
	SELECT DatabaseName,
           SchemaName,
           ObjName 
 FROM #SP_Til_ViewOgSP_Relation
	WHERE ObjName IS NOT NULL
	UNION
	SELECT DatabaseName,
           SchemaName,
           ObjName 
 FROM #View_Til_ViewOgSP_Relation
	WHERE ObjName IS NOT NULL


OPEN SnapshotCur
FETCH NEXT FROM SnapshotCur INTO  @SSIS_DatabaseName , @SSIS_SchemaName , @SSIS_ObjName  
WHILE @@FETCH_STATUS = 0  
BEGIN

INSERT INTO #TabelViewSP_Til_SSIS_Relation
SELECT @SSIS_ObjName,
       @SSIS_SchemaName,
							@SSIS_DatabaseName,
       a.SSISName,
       a.Connection,
       a.SQLQuery,
       a.Type,
       a.RefId ,
							b.isEnabled 
FROM #temp a
LEFT JOIN SSISDrift.dbo.SSIS_Job b ON LOWER(a.SSISName) = LOWER(b.SSIS_package)
WHERE  

--REPLACE(REPLACE(a.SQLQuery,'[',''),']','') LIKE  '%'+ CONCAT(@SSIS_SchemaName,'.',@SSIS_ObjName) +'%' 

(REPLACE(REPLACE(a.SQLQuery,'[',''),']','') LIKE  '%'+ CONCAT(@SSIS_SchemaName,'.',@SSIS_ObjName) +'%' 
AND @SSIS_DatabaseName LIKE a.Connection)

OR 

(REPLACE(REPLACE(a.SQLQuery,'[',''),']','') LIKE  '%'+ CONCAT('..',@SSIS_ObjName) +'%' 
AND @SSIS_DatabaseName LIKE a.Connection)

OR 

(REPLACE(REPLACE(a.SQLQuery,'[',''),']','') LIKE  '%'+ CONCAT(@SSIS_DatabaseName,'.',@SSIS_SchemaName,'.',@SSIS_ObjName) +'%' 
OR REPLACE(REPLACE(a.SQLQuery,'[',''),']','') LIKE  '%'+ CONCAT(@SSIS_DatabaseName,'..',@SSIS_ObjName) +'%' 
AND @SSIS_DatabaseName <> a.Connection)
 
FETCH NEXT FROM SnapshotCur INTO @SSIS_DatabaseName , @SSIS_SchemaName , @SSIS_ObjName
END;

CLOSE SnapshotCur
DEALLOCATE SnapshotCur

-------



 -- your search
	SELECT * FROM #Tables


	 
	-- results dhub only
	SELECT *
 FROM #Tabel_Til_ViewRelation

	UNION

	SELECT * 
 FROM #Tabel_Til_SP_Relation

	UNION

	SELECT *
 FROM #SP_Til_ViewOgSP_Relation

	UNION

	SELECT *
 FROM #View_Til_ViewOgSP_Relation



	-- results ssis
	SELECT *
 FROM #TabelViewSP_Til_SSIS_Relation



 