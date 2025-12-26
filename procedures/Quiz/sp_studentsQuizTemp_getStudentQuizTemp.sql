/* =====================================================================
   Procedure: dbo.SP_GetStudentQuizTemp
   Kind: RETRIEVE
   Purpose: Retrieve student quiz answers from Student_Quiz_temp (Page Quizes)
   Updated to make AcademicId optional for broader use (covers new query without AcademicId)
   Ticket: QUIZ-004
   Author: Osama Mahmoud
   Version: 1.1.0  -- Updated to support optional AcademicId
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetStudentQuizTemp', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetStudentQuizTemp;
GO

CREATE PROCEDURE dbo.SP_GetStudentQuizTemp
    -- [Input Parameters]
    @p_sheet_id     INT,
    @p_student_id   BIGINT,
    @p_class_id     INT,
    @p_academic_id  INT = NULL,  
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
       
        IF @p_sheet_id IS NULL OR @p_student_id IS NULL OR @p_class_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'معرف الورقة أو الطالب أو الفصل مطلوب' 
                                  ELSE N'Sheet ID, Student ID, or Class ID is required' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.Student_Quiz_temp
        WHERE sheetid = @p_sheet_id
          AND Student_Id = @p_student_id
          AND ClassId = @p_class_id
          AND (@p_academic_id IS NULL OR AcademicId = @p_academic_id);  -- فلتر اختياري

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد إجابات  لهذا لطالب' 
                                  ELSE N'No temporary quiz answers found' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب الإجابات لطالب بنجاح' 
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

EXEC dbo.SP_GetStudentQuizTemp
    @p_sheet_id    = 3175,      
    @p_student_id  = 1990833,   
    @p_class_id    = 1,        
    @p_academic_id = NULL,     
    @p_lang        = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;
    

SELECT @code AS Code, @msg AS Message;