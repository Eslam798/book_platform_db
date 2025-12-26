/* =====================================================================
   Procedure: dbo.SP_GetAllLecturesByFilters
   Kind: RETRIEVE
   Purpose: Retrieve all lectures with full filters (Page ShowAllLectures - Main grid)
   Ticket: LEC-009
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-24
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetAllLecturesByFilters', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetAllLecturesByFilters;
GO

CREATE PROCEDURE dbo.SP_GetAllLecturesByFilters
    @p_academic_id  INT,   
    @p_year_id      INT,   
    @p_specialid    INT,   
    @p_cat_id       INT,   
    @p_material_id  INT,   
    @p_lang         NVARCHAR(10) = 'ar',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_academic_id IS NULL OR @p_year_id IS NULL OR @p_specialid IS NULL 
           OR @p_cat_id IS NULL OR @p_material_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'جميع فلاتر المحاضرات مطلوبة' 
                                  ELSE N'All lecture filters are required' END;
            RETURN;
        END

        SELECT *
        FROM dbo.Lectures
        WHERE IsDeleted = 0
          AND AcademicId = @p_academic_id
          AND YearId = @p_year_id
          AND Specialid = @p_specialid
          AND Catid = @p_cat_id
          AND MaterialId = @p_material_id;

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
                              THEN N'تم جلب جميع المحاضرات بنجاح' 
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO

--ex:
DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_GetAllLecturesByFilters
    @p_academic_id = 53,
    @p_year_id     = 1,
    @p_specialid   = 8,
    @p_cat_id      = 1,
    @p_material_id = 11388,
    @p_lang        = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;