/* =====================================================================
   Procedure: dbo.SP_GetLecturesByDetailedFilters
   Kind: RETRIEVE
   Purpose: Retrieve lectures with full filters (faculty, material, group, class, academic year) - Page ShowLecture
   Ticket: LEC-003
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-24
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetLecturesByDetailedFilters', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetLecturesByDetailedFilters;
GO

CREATE PROCEDURE dbo.SP_GetLecturesByDetailedFilters
    -- [Input Parameters]
    @p_cat_id       INT,   
    @p_material_id  INT,   
    @p_group_id     INT,  
    @p_class_id     INT,  
    @p_academic_id  INT,  
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
        IF @p_cat_id IS NULL OR @p_material_id IS NULL OR @p_group_id IS NULL 
           OR @p_class_id IS NULL OR @p_academic_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'جميع فلاتر المحاضرات مطلوبة' 
                                  ELSE N'All lecture filters are required' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.Lectures
        WHERE IsDeleted = 0
          AND Catid = @p_cat_id
          AND MaterialId = @p_material_id
          AND groupid = @p_group_id
          AND ClassId = @p_class_id
          AND AcademicId = @p_academic_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد محاضرات بهذه الفلاتر' 
                                  ELSE N'No lectures found with these filters' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب المحاضرات بنجاح' 
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

EXEC dbo.SP_GetLecturesByDetailedFilters
    @p_cat_id      = 358,    
    @p_material_id = 8611, 
    @p_group_id    = 0,     
    @p_class_id    = 1,     
    @p_academic_id = 53,    
    @p_lang        = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;