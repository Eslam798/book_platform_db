/* =====================================================================
   Procedure: dbo.sp_ChangeStudentData
   Kind: UPDATE
   Purpose: Update student Data
   PageName: Page Site1.Master
   Ticket: student-st1
   Author: Abdelrahman Mamdouh
   Version: 1.0.0
   CreatedOn: 2025-12-25
   ===================================================================== */

IF OBJECT_ID('dbo.sp_ChangeStudentData', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ChangeStudentData;
GO

CREATE PROCEDURE dbo.sp_ChangeStudentData
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
        UPDATE dbo.E_BOOK_STUD
        SET ACAD_YEAR_ID = @p_acad_year_id,
            ACAD_YEAR = @p_acad_year,
            STUD_CODE = @p_stud_code,
            STUD_NAME = @p_stud_name,
            STUDY_NATURE_ID = @p_study_nature_id,
            STUDY_NATURE = @p_study_nature, 
            FACULTY_CODE = @p_faculty_code,
            FACULTY_NAME = @p_faculty_name,
            STUDY_METHOD_ID = @p_study_method_id,
            STUDY_METHOD = @p_study_method,
            DEPARTMENT_ID = @p_department_id,
            DEPARTMENT = @p_department,
            PHASE_ID = @p_phase_id,
            PHASE = @p_phase,
            SEMESTER_ID = @p_semester_id,
            SEMESTER = @p_semester,
            STUDY_PHOTO = @p_study_photo,
            PAY_FLAG = @p_pay_flag,
            LAW_ID = @p_law_id,
            LAW_NAME = @p_law_name,
            GROUP_ID = @p_group_id,
            GROUP_NAME = @p_group_name,
            STUD_NATIONAL_NUMBER = @p_stud_national_number,
            SEAT_NUMBER = @p_seat_number,
            PAY_FLAG2 = @p_pay_flag2,
               
        WHERE ed_stud_id = @p_ed_stud_id;
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
