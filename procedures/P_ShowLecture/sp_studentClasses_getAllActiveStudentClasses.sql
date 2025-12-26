/* =====================================================================
   Procedure: dbo.SP_GetAllActiveStudentClasses
   Kind: RETRIEVE
   Purpose: Retrieve all active student classes (no filters) - Used in Page ShowLecture
   Ticket: LEC-002
   Author: Osama Mahmoud
   Version: 1.0.1  
   CreatedOn: 2025-12-24
   ===================================================================== */
IF OBJECT_ID('dbo.SP_GetAllActiveStudentClasses', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SP_GetAllActiveStudentClasses;
GO

CREATE PROCEDURE dbo.SP_GetAllActiveStudentClasses
    @p_lang         NVARCHAR(10) = 'en',
    @o_success_code INT OUTPUT,
    @o_message      NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @o_success_code = -1;
    SET @o_message = N'Uninitialized';

    BEGIN TRY
        SELECT *
        FROM dbo.[StudentClass]
        WHERE IsDeleted = 0;

        IF @@ROWCOUNT = 0
        BEGIN
            SET @o_success_code = 4404;
            SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                                  THEN N'لا توجد فصول دراسية نشطة' 
                                  ELSE N'No active student classes found' END;
            RETURN;
        END

        SET @o_success_code = 0;
        SET @o_message = CASE WHEN LEFT(@p_lang,2)='ar' 
                              THEN N'تم جلب الفصول بنجاح' 
                              ELSE N'Success' END;
    END TRY
    BEGIN CATCH
        SET @o_success_code = -ERROR_NUMBER();
       
        SET @o_message = N'Error: ' + ISNULL(ERROR_MESSAGE(), N'Unknown error');
    END CATCH
END
GO


DECLARE @code INT, @msg NVARCHAR(4000);

EXEC dbo.SP_GetAllActiveStudentClasses
   -- @p_lang = 'ar',
    @o_success_code = @code OUTPUT,
    @o_message = @msg OUTPUT;

SELECT @code AS Code, @msg AS Message;