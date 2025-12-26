/* =====================================================================
   Procedure: dbo.SP_GetStudentQuiz
   Kind: RETRIEVE
   Purpose: Retrieve student's attempted quiz  from Students_Quiz (Page Quizes)
   Ticket: QUIZ-003
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetStudentQuiz', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetStudentQuiz;
GO

CREATE PROCEDURE dbo.SP_GetStudentQuiz
    -- [Input Parameters]
    @p_student_id   BIGINT,
    @p_sheet_id     INT,
    @p_class_id     INT,
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
        IF @p_student_id IS NULL OR @p_sheet_id IS NULL OR @p_class_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'معرف الطالب أو الورقة أو الفصل مطلوب' 
                                  ELSE N'Student ID, Sheet ID, or Class ID is required' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.Students_Quiz
        WHERE Student_Id = @p_student_id
          AND sheetid = @p_sheet_id
          AND ClassId = @p_class_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد إجابات لهذا الطالب في هذا الكويز' 
                                  ELSE N'No quiz answers found for this student' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب الطالب بنجاح' 
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO

--EX:
DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_GetStudentQuiz
    @p_student_id = 84081,   
    @p_sheet_id   = 3366,       
    @p_class_id   = 1,       
    @p_lang       = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;
 

SELECT @code AS Code, @msg AS Message;