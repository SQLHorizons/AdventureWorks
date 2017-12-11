
CREATE TRIGGER [ddlDatabaseTriggerLog] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @data XML;
    DECLARE @schema [sys].[sysname];
    DECLARE @object [sys].[sysname];
    DECLARE @eventType [sys].[sysname];

    SET @data = EVENTDATA();
    SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
    SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
    SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname') 

    IF @object IS NOT NULL
        PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
    ELSE
        PRINT '  ' + @eventType + ' - ' + @schema;

    IF @eventType IS NULL
        PRINT CONVERT(nvarchar(max), @data);

    INSERT [dbo].[DatabaseLog] 
        (
        [dbo].[DatabaseLog].[PostTime], 
        [dbo].[DatabaseLog].[DatabaseUser], 
        [dbo].[DatabaseLog].[Event], 
        [dbo].[DatabaseLog].[Schema], 
        [dbo].[DatabaseLog].[Object], 
        [dbo].[DatabaseLog].[TSQL], 
        [dbo].[DatabaseLog].[XmlEvent]
        ) 
    VALUES 
        (
        GETDATE(), 
        CONVERT([sys].[sysname], CURRENT_USER), 
        @eventType, 
        CONVERT([sys].[sysname], @schema), 
        CONVERT([sys].[sysname], @object), 
        @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'), 
        @data
        );
END;


GO
DISABLE TRIGGER [ddlDatabaseTriggerLog]
    ON DATABASE;


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Database trigger to audit all of the DDL changes made to the AdventureWorks 2016 database.', @level0type = N'TRIGGER', @level0name = N'ddlDatabaseTriggerLog';

