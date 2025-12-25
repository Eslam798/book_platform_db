/* =====================================================================
   Procedure: dbo.SP_GetSectionCatById
   Kind: RETRIEVE
   Purpose: Retrieve Faculty information by SectionId (faculty code)
   PageName: Page Schedule Student and Site1.Master
   Ticket: EBOOK-003
   Author: Osama Mahmoud
   Version: 1.0.0
   CreatedOn: 2025-12-23
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetSectionCatById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetSectionCatById;
GO

--  @p_section_id [0 or -1 or any number]
--  - 0 return intro message
--  - -1 return all faculties
--  - [1-34] return specific faculty

CREATE PROCEDURE dbo.SP_GetSectionCatById
    -- [Input Parameters]
    @p_section_id BIGINT = 0, 
    @p_lang       NVARCHAR(10) = 'ar',
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
                                  THEN N'كود الكلية مطلوب' 
                                  ELSE N'Section ID is required' END;
            RETURN;
        END

        -- [Output]
        IF @p_section_id = -1 
        BEGIN
            SELECT *
            FROM dbo.Section_Cat
            WHERE SectionId > 0 and IsDeleted = 0
        END

        ELSE
        BEGIN
            SELECT *
            FROM dbo.Section_Cat
            WHERE SectionId = @p_section_id and IsDeleted = 0;
        END

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'الكلية غير موجوده' 
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
        SET @o_message = N'Error: ' + ERROR_MESSAGE();
    END CATCH
END
GO
