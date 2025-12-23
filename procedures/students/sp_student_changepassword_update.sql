/* =====================================================================
   Procedure: dbo.sp_student_change_password
   Kind: UPDATE
   Purpose: Update student password
   Ticket: student-st1
   Author: Abdelrahman Mamdouh
   Version: 1.0.0
   CreatedOn: 2025-12-19
   ===================================================================== */

IF OBJECT_ID('dbo.sp_student_change_password', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_student_change_password;
GO

CREATE PROCEDURE dbo.sp_student_change_password
    -- [Input Parameters]
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
    IF @p_ed_stud_id IS NULL
    BEGIN
        SET @o_success_code = 2001;
        SET @o_message = N'Student ID is required';
        RETURN;
    END

    -- [DML & Transactions]
    BEGIN TRAN;
        UPDATE dbo.E_BOOK_STUD
        SET pass = @p_new_password
        WHERE ed_stud_id = @p_ed_stud_id;
    COMMIT TRAN;

    -- [Output]
    SET @o_success_code = 0;
    SET @o_message = N'Password is updated sucessfully';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    SET @o_success_code = -ERROR_NUMBER();
    SET @o_message = N'Error: ' + ERROR_MESSAGE();
END CATCH;
GO
