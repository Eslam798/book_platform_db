/* =====================================================================
   Procedure: dbo.sp_customer_insert
   Kind: INSERT
   Purpose: Insert a new customer
   Ticket: CRM-1234
   Author: YourName
   Version: 1.0.0
   CreatedOn: YYYY-MM-DD
   ===================================================================== */

IF OBJECT_ID('dbo.sp_customer_insert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_customer_insert;
GO

CREATE PROCEDURE dbo.sp_customer_insert
    -- [Input Parameters]
    @p_first_name NVARCHAR(50),
    @p_last_name  NVARCHAR(50),
    @p_email      NVARCHAR(255),
    -- [Output Parameters]
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
SET NOCOUNT ON;

SET @o_success_code = -1;
SET @o_message = N'Uninitialized';

BEGIN TRY
    -- [Validation]
    IF @p_email IS NULL
    BEGIN
        SET @o_success_code = 1001;
        SET @o_message = N'Email is required';
        RETURN;
    END

    -- [Permission Checks]
    -- Example: IF IS_MEMBER('crm_writer') = 0 RETURN;

    -- [Business Rules]
    SET @p_email = LOWER(LTRIM(RTRIM(@p_email)));

    -- [DML & Transactions]
    BEGIN TRAN;
        INSERT INTO dbo.Customer(first_name, last_name, email)
        VALUES(@p_first_name, @p_last_name, @p_email);
    COMMIT TRAN;

    -- [Output]
    SET @o_success_code = 0;
    SET @o_message = N'OK';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    SET @o_success_code = -ERROR_NUMBER();
    SET @o_message = CONCAT(N'Error: ', ERROR_MESSAGE());
END CATCH;
GO
