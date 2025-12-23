   /* =====================================================================
   Procedure: dbo.GetEBookStudByFacultyAndStudent
   Kind: RETRIEVE
   Purpose: Retrieve electronic books for a specific student in a specific faculty
   Ticket: EBOOK-001
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-23
   ===================================================================== */
IF OBJECT_ID('dbo.GetEBookStudByFacultyAndStudent', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetEBookStudByFacultyAndStudent;
GO

CREATE PROCEDURE dbo.GetEBookStudByFacultyAndStudent
    -- [Input Parameters]
    @p_faculty_code BIGINT,
    @p_student_id   BIGINT,
    @p_lang         NVARCHAR(10) = 'en',  -- 'ar' or 'en'
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
        IF @p_faculty_code IS NULL OR @p_student_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'معرف الكلية أو الطالب مطلوب' 
                                  ELSE N'Faculty code or Student ID is required' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.E_BOOK_STUD
        WHERE FACULTY_CODE = @p_faculty_code
          AND ED_STUD_ID = @p_student_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد كتب إلكترونية لهذا الطالب في هذه الكلية' 
                                  ELSE N'No e-books found for this student in this faculty' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب البيانات بنجاح' 
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = CONCAT(N'Error: ', ERROR_MESSAGE());
    END CATCH
END
GO