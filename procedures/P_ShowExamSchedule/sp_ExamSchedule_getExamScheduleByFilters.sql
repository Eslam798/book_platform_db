/* =====================================================================
   Procedure: dbo.SP_GetExamScheduleByFilters
   Kind: RETRIEVE
   Purpose: Retrieve exam schedule for a student based on academic year, phase, department, and faculty (Page ShowExamSchedule)
   Ticket: EXAM-003
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-24
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetExamScheduleByFilters', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetExamScheduleByFilters;
GO

CREATE PROCEDURE dbo.SP_GetExamScheduleByFilters
    -- [Input Parameters]
    @p_academic_id   INT,   
    @p_year_id       INT,   
    @p_specialid     INT,   
    @p_cat_id        INT,   
    @p_lang          NVARCHAR(10) = 'ar',  -- 'ar' or 'en'
    -- [Output Parameters]
    @o_success_code  INT OUTPUT,
    @o_message       NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        -- [Validation]
        IF @p_academic_id IS NULL 
           OR @p_year_id IS NULL 
           OR @p_specialid IS NULL 
           OR @p_cat_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'جميع معايير جدول الامتحانات مطلوبة' 
                                  ELSE N'All exam schedule filters are required' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.ExamSchedule
        WHERE IsDeleted = 0
          AND AcademicId = @p_academic_id
          AND YearId = @p_year_id
          AND Specialid = @p_specialid
          AND Catid = @p_cat_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا يوجد جدول امتحانات بهذه المعايير' 
                                  ELSE N'No exam schedule found with these criteria' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب جدول الامتحانات بنجاح' 
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

EXEC dbo.SP_GetExamScheduleByFilters
    @p_academic_id = 6,      
    @p_year_id     = 4,      
    @p_specialid   = 4,      
    @p_cat_id      = 2,      
    @p_lang        = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;