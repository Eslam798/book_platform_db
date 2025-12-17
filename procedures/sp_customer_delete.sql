/* =====================================================================
   Procedure: dbo.sp_customer_delete
   Kind: DELETE
   Purpose: Delete a customer
   Ticket: CRM-1236
   Author: YourName
   Version: 1.0.0
   CreatedOn: YYYY-MM-DD
   ===================================================================== */

IF OBJECT_ID('dbo.sp_customer_delete', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_customer_delete;
GO

CREATE PROCEDURE dbo.sp_customer_delete
    -- [Input Parameters]
    @p_customer_id BIGINT,
    -- [Output Parameters]
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
SET NOCOUNT ON;

SET @o_success_code = -1;
SET @o_message = N'Uninitialized';

BEGIN TRY
    -- [Validation]
    IF @p_customer_id IS NULL
    BEGIN
        SET @o_success_code = 3001;
        SET @o_message = N'Customer ID is required';
        RETURN;
    END

    -- [Permission Checks]
    -- Example: IF IS_MEMBER('crm_writer') = 0 RETURN;

    -- [Business Rules]
    -- None for delete

    -- [DML & Transactions]
    BEGIN TRAN;
        DELETE FROM dbo.Customer WHERE id = @p_customer_id;
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
