/* =====================================================================
   Procedure: dbo.GetSectionCatById
   Kind: RETRIEVE
   Purpose: Retrieve section category information by SectionId
   Ticket: EBOOK-003
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-23
   ===================================================================== */
IF OBJECT_ID('dbo.GetSectionCatById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetSectionCatById;
GO

CREATE PROCEDURE dbo.GetSectionCatById
    -- [Input Parameters]
    @p_section_id BIGINT,
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
        IF @p_section_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'معرف القسم مطلوب' 
                                  ELSE N'Section ID is required' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.Section_Cat
        WHERE SectionId = @p_section_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'القسم غير موجود' 
                                  ELSE N'Section not found' END;
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
