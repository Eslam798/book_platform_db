/* =====================================================================
   Procedure: dbo.SP_GetQuizQuestionById
   Kind: RETRIEVE
   Purpose: Retrieve question details by QuestionId (Page Quizes)
   Ticket: QUIZ-005
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetQuizQuestionById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetQuizQuestionById;
GO

CREATE PROCEDURE dbo.SP_GetQuizQuestionById
    @p_question_id  INT,
    @p_lang         NVARCHAR(10) = 'ar',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_question_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'معرف السؤال مطلوب' 
                                  ELSE N'Question ID is required' END;
            RETURN;
        END

        SELECT *
        FROM dbo.QuestionTable
        WHERE QuestionId = @p_question_id
          AND IsDeleted = 0;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'السؤال غير موجود أو تم حذفه' 
                                  ELSE N'Question not found or deleted' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب السؤال بنجاح' 
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

EXEC dbo.SP_GetQuizQuestionById
    @p_question_id    = 373,      
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;
    

SELECT @code AS Code, @msg AS Message;