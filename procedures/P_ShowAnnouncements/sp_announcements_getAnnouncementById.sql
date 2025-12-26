/* =====================================================================
   Procedure: dbo.SP_GetAnnouncementById
   Kind: RETRIEVE
   Purpose: Retrieve a specific announcement by its ID (Page ShowAnnouncements)
   Ticket: ANN-001
   Author: Osama Mahmoud
   Version: 1.0.1
   CreatedOn: 2025-12-24
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetAnnouncementById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetAnnouncementById;
GO

CREATE PROCEDURE dbo.SP_GetAnnouncementById
    -- [Input Parameters]
    @p_an_id        INT,                  
    @p_lang         NVARCHAR(10) = 'en',  -- 'ar' or 'en'
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
        IF @p_an_id IS NULL
        BEGIN
            SET @o_success_code = 4001;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'معرف الإعلان مطلوب' 
                                  ELSE N'Announcement ID is required' END;
            RETURN;
        END

        -- [Output]
        SELECT *
        FROM dbo.[Announcements]
        WHERE IsDeleted = 0
          AND an_id = @p_an_id;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'الإعلان غير موجود أو تم حذفه' 
                                  ELSE N'Announcement not found or deleted' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب الإعلان بنجاح' 
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
      
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO

--ex

DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_GetAnnouncementById
    @p_an_id = 10,     
    @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;