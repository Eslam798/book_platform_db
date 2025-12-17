/* =====================================================================
   Procedure: dbo.sp_customer_get
   Kind: RETRIEVE
   Purpose: Get customer details
   Ticket: CRM-1237
   Author: YourName
   Version: 1.0.0
   CreatedOn: YYYY-MM-DD
   ===================================================================== */

IF OBJECT_ID('dbo.sp_customer_get', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_customer_get;
GO

CREATE PROCEDURE dbo.sp_customer_get
    -- [Input Parameters]
    @p_customer_id BIGINT,
    @p_lang        NVARCHAR(10),
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
        SET @o_success_code = 4001;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'المعرف مطلوب' ELSE N'ID required' END;
        RETURN;
    END

    -- [Permission Checks]
    -- Example: IF IS_MEMBER('crm_reader') = 0 RETURN;

    -- [Business Rules]
    -- No DML or transactions allowed

    -- [Output]
    SELECT id, first_name, last_name, email
    FROM dbo.Customer
    WHERE id = @p_customer_id;

    IF @@ROWCOUNT = 0
    BEGIN
        SET @o_success_code = 4404;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'غير موجود' ELSE N'Not found' END;
        RETURN;
    END

    SET @o_success_code = 0;
    SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' THEN N'تم بنجاح' ELSE N'OK' END;
END TRY
BEGIN CATCH
    SET @o_success_code = -ERROR_NUMBER();
    SET @o_message = CONCAT(N'Error: ', ERROR_MESSAGE());
END CATCH;
GO
