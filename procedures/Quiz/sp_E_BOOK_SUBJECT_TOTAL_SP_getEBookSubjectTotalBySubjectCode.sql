/* =====================================================================
   Procedure: dbo.SP_GetEBookSubjectTotalBySubjectCode
   Kind: RETRIEVE
   Purpose: Retrieve subject total details by SUBJECT_CODE (Page Quizes)
   Ticket: QUIZ-006
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetEBookSubjectTotalBySubjectCode', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetEBookSubjectTotalBySubjectCode;
GO

CREATE PROCEDURE dbo.SP_GetEBookSubjectTotalBySubjectCode
    @p_subject_code INT, 
    @p_lang         NVARCHAR(10) = 'ar',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_subject_code IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'كود المادة مطلوب' 
                                  ELSE N'Subject code is required' END;
            RETURN;
        END

        SELECT *
        FROM dbo.E_BOOK_SUBJECT_TOTAL
        WHERE SUBJECT_CODE = @p_subject_code;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد تفاصيل لهذه المادة' 
                                  ELSE N'No subject total found' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب تفاصيل المادة بنجاح' 
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO

--EX

DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_GetEBookSubjectTotalBySubjectCode
    @p_subject_code    = 373,      
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;
    

SELECT @code AS Code, @msg AS Message;