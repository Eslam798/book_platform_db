/* =====================================================================
   Procedure: dbo.SP_GetSpecialistsByCatId
   Kind: RETRIEVE
   Purpose: Retrieve active specialists by category (Page ShowAllLectures - Dropdown population)
   Ticket: LEC-004
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-24
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetSpecialistsByCatId', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetSpecialistsByCatId;
GO

CREATE PROCEDURE dbo.SP_GetSpecialistsByCatId
    @p_cat_id       INT,
    @p_lang         NVARCHAR(10) = 'ar',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        IF @p_cat_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'معرف الفئة مطلوب' 
                                  ELSE N'Category ID is required' END;
            RETURN;
        END

        SELECT *
        FROM dbo.[Specialists]
        WHERE IsDeleted = 0
          AND Catid = @p_cat_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد تخصصات لهذه الفئة' 
                                  ELSE N'No specialists found for this category' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب التخصصات بنجاح' 
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

EXEC dbo.SP_GetSpecialistsByCatId
    @p_cat_id = 10,
    @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message      = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;