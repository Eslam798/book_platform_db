/* =====================================================================
   Procedure: dbo.sp_addNewStudent
   Kind: INSERT
   Purpose: Add new student
   PageName: Page Site1.Master
   Ticket: student-st1
   Author: Abdelrahman Mamdouh
   Version: 1.0.0
   CreatedOn: 2025-12-25
   ===================================================================== */

IF OBJECT_ID('dbo.sp_addNewStudent', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_addNewStudent;
GO

CREATE PROCEDURE dbo.sp_addNewStudent
    -- [Input Parameters]
    @p_acad_year_id INT,
    @p_acad_year NVARCHAR(50),
    @p_stud_code NVARCHAR(50),
    @p_stud_name NVARCHAR(250),
    @p_study_nature_id NVARCHAR(50),
    @p_study_nature NVARCHAR(250),
    @p_faculty_code NVARCHAR(50),
    @p_faculty_name NVARCHAR(250),
    @p_study_method_id NVARCHAR(50),
    @p_study_method NVARCHAR(250),
    @p_department_id NVARCHAR(50),
    @p_department NVARCHAR(250),
    @p_phase_id NVARCHAR(50),
    @p_phase NVARCHAR(250),
    @p_semester_id NVARCHAR(50),
    @p_semester NVARCHAR(250),
    @p_study_photo NVARCHAR(500),
    @p_pay_flag BOOLEAN,
    @p_law_id NVARCHAR(50),
    @p_law_name NVARCHAR(250),
    @p_group_id NVBARCHAR(50),
    @p_group_name NVARCHAR(250),
    @p_stud_national_number NVARCHAR(50),
    @p_seat_number NVARCHAR(50),
    @p_pay_flag2 BOOLEAN,


    @p_ed_stud_id VARCHAR(100),
    @p_new_password       NVARCHAR(255),

    -- [Output Parameters]
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
SET NOCOUNT ON;

SET @o_success_code = -1;
SET @o_message = N'Uninitialized';

BEGIN TRY
    -- [Validation]
    IF @p_ed_stud_id IS NULL or @p_acad_year_id IS NULL or @p_acad_year IS NULL 
    or @p_stud_code IS NULL or @p_stud_name IS NULL or @p_study_nature_id IS NULL
    or @p_study_nature IS NULL or @p_faculty_code IS NULL or @p_faculty_name IS NULL
    or @p_study_method_id IS NULL or @p_study_method IS NULL or @p_department_id IS NULL
    or @p_department IS NULL or @p_phase_id IS NULL or @p_phase IS NULL 
    or @p_semester_id IS NULL or @p_semester IS NULL or @p_study_photo IS NULL
    or @p_pay_flag IS NULL or @p_law_id IS NULL or @p_law_name IS NULL
    or @p_group_id IS NULL or @p_group_name IS NULL or @p_stud_national_number IS NULL
    or @p_seat_number IS NULL or @p_pay_flag2 IS NULL
    BEGIN
        SET @o_success_code = 2001;
        SET @o_message = N'All student's data is required';
        RETURN;
    END

    -- [DML & Transactions]
    BEGIN TRAN;
                INSERT INTO dbo.E_BOOK_STUD
        (
            ED_STUD_ID,
            ACAD_YEAR_ID,
            ACAD_YEAR,
            STUD_CODE,
            STUD_NAME,
            STUDY_NATURE_ID,
            STUDY_NATURE,
            FACULTY_CODE,
            FACULTY_NAME,
            STUDY_METHOD_ID,
            STUDY_METHOD,
            DEPARTMENT_ID,
            DEPARTMENT,
            PHASE_ID,
            PHASE,
            SEMESTER_ID,
            SEMESTER,
            STUDY_PHOTO,
            PAY_FLAG,
            LAW_ID,
            LAW_NAME,
            GROUP_ID,
            GROUP_NAME,
            STUD_NATIONAL_NUMBER,
            SEAT_NUMBER,
            PAY_FLAG2
        )
        VALUES
        (
            @p_ed_stud_id,
            @p_acad_year_id,
            @p_acad_year,
            @p_stud_code,
            @p_stud_name,
            @p_study_nature_id,
            @p_study_nature,
            @p_faculty_code,
            @p_faculty_name,
            @p_study_method_id,
            @p_study_method,
            @p_department_id,
            @p_department,
            @p_phase_id,
            @p_phase,
            @p_semester_id,
            @p_semester,
            @p_study_photo,
            @p_pay_flag,
            @p_law_id,
            @p_law_name,
            @p_group_id,
            @p_group_name,
            @p_stud_national_number,
            @p_seat_number,
            @p_pay_flag2
        );
    COMMIT TRAN;

    -- [Output]
    SET @o_success_code = 0;
    SET @o_message = N'Student data is updated sucessfully';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    SET @o_success_code = -ERROR_NUMBER();
    SET @o_message = N'Error: ' + ERROR_MESSAGE();
END CATCH;
GO
