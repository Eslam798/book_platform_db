/* =====================================================================
   Procedure: dbo.SP_UpdateStudentQuizTempIsDeleted
   Kind: UPDATE
   Purpose: Soft delete (set IsDeleted) for a specific question in Student_Quiz_temp (Page Quizes)
   Ticket: QUIZ-007
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-26
   ===================================================================== */
IF OBJECT_ID('dbo.SP_UpdateStudentQuizTempIsDeleted', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_UpdateStudentQuizTempIsDeleted;
GO

CREATE PROCEDURE dbo.SP_UpdateStudentQuizTempIsDeleted
    -- [Input Parameters]
    @p_student_id   BIGINT,
    @p_sheet_id     INT,
    @p_class_id     INT,
    @p_question_id  INT,
    @p_is_deleted   BIT, --0 or 1
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
        IF @p_student_id IS NULL OR @p_sheet_id IS NULL OR @p_class_id IS NULL OR @p_question_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'جميع معايير التحديث مطلوبة' 
                                  ELSE N'All update parameters are required' END;
            RETURN;
        END

        -- [Update]
        UPDATE dbo.Student_Quiz_temp
        SET IsDeleted = @p_is_deleted
        WHERE Student_Id = @p_student_id
          AND sheetid = @p_sheet_id
          AND ClassId = @p_class_id
          AND QuestionId = @p_question_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد سجل للتحديث' 
                                  ELSE N'No record found to update' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم التحديث بنجاح' 
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO


--EX

DECLARE @code INT,@msg NVARCHAR(4000);

EXEC dbo.SP_UpdateStudentQuizTempIsDeleted
    @p_student_id  = 1990833,    
    @p_sheet_id    = 3175,       
    @p_class_id    = 1,       
    @p_is_deleted  = 0, 
    @p_question_id=18874,       
    @p_lang        = 'ar',      
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;

SELECT @code AS SuccessCode, @msg AS Message;
