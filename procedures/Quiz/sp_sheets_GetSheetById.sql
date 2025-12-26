/* =====================================================================
   Procedure: dbo.SP_GetSheetById
   Kind: RETRIEVE
   Purpose: Retrieve sheet details for a quiz (Page Quizes)
   Ticket: QUIZ-001
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetSheetById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetSheetById;
GO

CREATE PROCEDURE dbo.SP_GetSheetById
    -- [Input Parameters]
    @p_sheet_id     INT,                  
    @p_lang         NVARCHAR(10) = 'ar',
    -- [Output Parameters]
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        -- [Validation]
        IF @p_sheet_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'معرف الورقة مطلوب' 
                                  ELSE N'Sheet ID is required' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.Sheets
        WHERE id = @p_sheet_id
          AND IsDeleted = 0;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'الورقة غير موجودة أو تم حذفها' 
                                  ELSE N'Sheet not found or deleted' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب الورقة بنجاح' 
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO

--ex

DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_GetSheetById
    @p_sheet_id =446,   
    @p_lang       = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;
   
SELECT @code AS Code, @msg AS Message;