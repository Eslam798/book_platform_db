   /* =====================================================================
   Procedure: dbo.SP_GetEBookStudByFacultyAndStudentAndPassword
   Kind: RETRIEVE
   Purpose: Retrieve electronic books for a specific student in a specific faculty and password
   PageName: Page Site1.Master
   Ticket: EBOOK-001
   Author: Abdelrahman Mamdouh
   Version: 1.0.0
   CreatedOn: 2025-12-23
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetEBookStudByFacultyAndStudentAndPassword', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetEBookStudByFacultyAndStudentAndPassword;
GO

CREATE PROCEDURE dbo.SP_GetEBookStudByFacultyAndStudentAndPassword
    -- [Input Parameters]
    @p_faculty_code BIGINT,
    @p_student_id   BIGINT,
    @p_stud_password NVARCHAR(255),
    @p_lang         NVARCHAR(10) = 'ar',  -- 'ar' or 'en'
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
                                  THEN N'من فضلك ادخل الرقم القومى وكود الكليه' 
                                  ELSE N'Please enter the national number and faculty code' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.E_BOOK_STUD
        WHERE ( STUD_NATIONAL_NUMBER = @p_student_id or ED_STUD_ID = @p_student_id)
            AND FACULTY_CODE = @p_faculty_code
            AND PASS = @p_stud_password;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'الطالب غير مسجل او كلمة المرور غير صحيحه' 
                                  ELSE N'Error in National number or password' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب البيانات بنجاح' 
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
        SET @o_message = N'Error: ' + ERROR_MESSAGE();
    END CATCH
END
GO