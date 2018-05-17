USE [Token]
GO

/****** Object:  StoredProcedure [dbo].[InsertData]    Script Date: 5/17/2018 10:32:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[InsertData] as

DECLARE @ProcedureName nvarchar(50)
set @ProcedureName = (select OBJECT_NAME(@@PROCID))

EXEC Start_Procedure @Procedure = @ProcedureName

WAITFOR DELAY '00:00:10';

BEGIN TRY
INSERT INTO Token.dbo.Table1
VALUES ('JKLOPERHGFJCNEMGHDSKJHSF1234548613486431348631654865314654',GETDATE())
END TRY

BEGIN CATCH
declare @error int,
 @message varchar(4000)
        select @error = ERROR_NUMBER(),
                 @message = ERROR_MESSAGE()
END CATCH


EXEC End_Procedure @StatusMessage = @message, @Procedure = @ProcedureName
GO


