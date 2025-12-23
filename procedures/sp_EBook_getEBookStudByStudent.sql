/* =====================================================================
   Procedure: dbo.GetEBookStudByStudent
   Kind: RETRIEVE
   Purpose: Retrieve all electronic books for a specific student (across all faculties)
   Ticket: EBOOK-002
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-23
   ===================================================================== */
IF OBJECT_ID('dbo.GetEBookStudByStudent', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetEBookStudByStudent;
GO

CREATE PROCEDURE dbo.GetEBookStudByStudent
    -- [Input Parameters]
    @p_student_id BIGINT,
    @p_lang       NVARCHAR(10) = 'en',
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
        IF @p_student_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'معرف الطالب مطلوب' 
                                  ELSE N'Student ID is required' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.E_BOOK_STUD
        WHERE ED_STUD_ID = @p_student_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد كتب إلكترونية لهذا الطالب' 
                                  ELSE N'No e-books found for this student' END;
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
