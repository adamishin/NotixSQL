CREATE procedure [dbo].[InsertData] as

INSERT INTO Log_DB.dbo.LOG_PROCEDURE ([PROCEDURE_NAME],[START_DATE],[STATUS],[CHECKPOINT])
VALUES (OBJECT_NAME(@@PROCID), GetDate(),'Procedure starts', '1st step')

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


UPDATE Log_DB.dbo.LOG_PROCEDURE
SET [STATUS] = 'Procedure ends', END_DATE = GETDATE(),[CHECKPOINT] = '2nd step'
WHERE [PROCEDURE_NAME] = OBJECT_NAME(@@PROCID) AND END_DATE IS NULL
GO
