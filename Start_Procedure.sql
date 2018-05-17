USE [Token]
GO

/****** Object:  StoredProcedure [dbo].[Start_Procedure]    Script Date: 5/17/2018 10:34:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Start_Procedure] @Procedure nvarchar(50) as 

INSERT INTO Log_DB.dbo.LOG_PROCEDURE ([PROCEDURE_NAME],[START_DATE],[STATUS],[CHECKPOINT])
VALUES (@Procedure, GetDate(),'Procedure starts', '1st step')
GO


