
USE DropZone
go

CREATE TABLE [dbo].[SSISConnections]
(
[SSISName] [nvarchar] (200) COLLATE Danish_Norwegian_CI_AS NULL,
[CreationName] [varchar] (200) COLLATE Danish_Norwegian_CI_AS NULL,
[RefId] [nvarchar] (200) COLLATE Danish_Norwegian_CI_AS NULL,
[DTSID] [nvarchar] (200) COLLATE Danish_Norwegian_CI_AS NULL,
[ConnectionString] [nvarchar] (max) COLLATE Danish_Norwegian_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[SSISTaskSQL]
(
[SSISName] [nvarchar] (200) COLLATE Danish_Norwegian_CI_AS NULL,
[DTSID] [nvarchar] (200) COLLATE Danish_Norwegian_CI_AS NULL,
[SQLQuery] [nvarchar] (max) COLLATE Danish_Norwegian_CI_AS NULL,
[Type] [nvarchar] (max) COLLATE Danish_Norwegian_CI_AS NULL,
[RefId] [nvarchar] (max) COLLATE Danish_Norwegian_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
