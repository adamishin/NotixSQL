USE [Token]
GO

/****** Object:  StoredProcedure [dbo].[End_Procedure]    Script Date: 5/17/2018 10:31:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[End_Procedure] @StatusMessage varchar(4000), @Procedure nvarchar(50) 
as

UPDATE Log_DB.dbo.LOG_PROCEDURE
SET [STATUS] = 'Procedure ends', END_DATE = GETDATE(),[CHECKPOINT] = '2nd step', [MESSAGE] = @StatusMessage
WHERE [PROCEDURE_NAME] = @Procedure AND END_DATE IS NULL
GO


