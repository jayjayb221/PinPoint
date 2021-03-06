USE [PinDB]
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteCategoryType]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_DeleteCategoryType]
@ID int
as
Delete from Category_Type
where ID = @ID
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertAsset]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_InsertAsset]
@Serial varchar(50),
@TypeID int,
@RFID varchar(24),
@Description varchar(500)
as
declare @Location int  = 0
 set @Location = (Select ID from Location where Name = 'Registered')

 insert into Asset_Register
 values(@RFID,0,@TypeID,@Serial,GETDATE(),@Description,'Active',@Location)

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertCategoryType]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_InsertCategoryType]
@ID int  = 0,
@Category_ID int,
@Type varchar(50)
as
if(@ID = 0)
begin
insert into Category_Type 
Values(@Category_ID,@Type)
end
else
begin
update Category_Type
set Type = @Type
where ID =@ID 
end

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertReaderEvents]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_InsertReaderEvents]
@ReaderID int,
@RFID varchar(50),
@Status varchar(10)
as
Insert into Reader_Events
Values(@ReaderID,@RFID,GETDATE(),@Status)
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertUserLocationAccess]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_InsertUserLocationAccess]
@User_ID int,
@Location_ID int

as
IF not  exists(Select * from User_LocationAccess where User_ID = @User_ID and Location_ID = @Location_ID)
INSERT INTO User_LocationAccess
VALUES(@User_ID, @Location_ID)


GO
/****** Object:  StoredProcedure [dbo].[sp_SearchTrackEvents]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[sp_SearchTrackEvents]
@Asset_ID int = 0,
@User_ID int = 0,
@Dt_Start varchar(50) = null,
@Dt_End varchar(50) = null

AS

SELECT        dbo.Categories.Category, dbo.Category_Type.Type, dbo.Asset_Register.Serial_No, dbo.Location.Name, dbo.Users.First_Name, dbo.Users.Last_Name, dbo.Track_Events.Date_Time ,
                         dbo.Track_Events.Event
FROM            dbo.Track_Events INNER JOIN
                         dbo.Asset_Register ON dbo.Track_Events.Asset_ID = dbo.Asset_Register.ID INNER JOIN
                         dbo.Location ON dbo.Track_Events.Location_ID = dbo.Location.ID  INNER JOIN
                         dbo.Category_Type ON dbo.Asset_Register.Category_Type_ID = dbo.Category_Type.ID INNER JOIN
                         dbo.Categories ON dbo.Category_Type.Category_ID = dbo.Categories.ID LEFT OUTER JOIN 
                         dbo.Users ON dbo.Track_Events.User_ID = dbo.Users.ID
WHERE (@Asset_ID  = 0 or Asset_ID = @Asset_ID) AND (@User_ID = 0 or User_ID = @User_ID)
AND (@Dt_Start is null or Track_Events.Date_Time between cast (@Dt_Start as datetime) and cast(@Dt_End as datetime) )


GO
/****** Object:  StoredProcedure [dbo].[sp_SelectAssets_ByCtype]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_SelectAssets_ByCtype]
@Type Int
as
Select * from Asset_Register
where Category_Type_ID = @Type
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectAssets_ByRFID]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectAssets_ByRFID]
@RFID varchar(24)
as
Select * from Asset_Register
where RFID  =@RFID
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectCategories]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectCategories]
as
Select * from Categories
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectCategoryType_ByCategoryID]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectCategoryType_ByCategoryID]
@Category_ID int
as
Select * from Category_Type
where Category_ID = @Category_ID

GO
/****** Object:  StoredProcedure [dbo].[sp_SelectDeviceByPort]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectDeviceByPort]
@Port int
as
Select * from Devices
where Port = @Port

GO
/****** Object:  StoredProcedure [dbo].[sp_SelectDevicesWithLocation]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectDevicesWithLocation]
as
Select D.*,L.Name from Devices D 
INNER JOIN Location L on
L.ID = D.Location_ID

GO
/****** Object:  StoredProcedure [dbo].[sp_SelectLastReaderEvent_ByReaderIDANDRFID]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectLastReaderEvent_ByReaderIDANDRFID]
@ReaderID int,
@RFID varchar(50)
as
Select * from Reader_Events
where ID = (Select max(ID) from Reader_Events where Reader_ID = @ReaderID and RFID = @RFID)
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectLastReaderEvent_ByRFID]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectLastReaderEvent_ByRFID]
@RFID varchar(50)
as
Select * from Reader_Events
where ID = (Select max(ID) from Reader_Events where  RFID = @RFID)
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectLocations]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectLocations]
as
Select * from Location
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectUser_ByRFID]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectUser_ByRFID]
@RFID varchar(50)
as
Select * from Users
where RFID = @RFID
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectUsers]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_SelectUsers]
as
Select * from Users
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateDeviceStatus_ByID]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_UpdateDeviceStatus_ByID]
@Status varchar(50),
@ID int
as
Update Devices
set Status =@Status
where ID =  @ID
GO
/****** Object:  Table [dbo].[Asset_CurrentLocation]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Asset_CurrentLocation](
	[Asset_ID] [int] NOT NULL,
	[Location_ID] [int] NULL,
	[User_ID] [int] NULL,
	[DateTime] [datetime] NULL,
 CONSTRAINT [PK_Asset_CurrentLocation] PRIMARY KEY CLUSTERED 
(
	[Asset_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Asset_Register]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Asset_Register](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RFID] [nvarchar](50) NULL,
	[Owner] [int] NULL,
	[Category_Type_ID] [int] NULL,
	[Serial_No] [nvarchar](50) NULL,
	[Date_Time] [datetime] NULL,
	[Description] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[Current_Location] [int] NULL,
 CONSTRAINT [PK_Asset_Register] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Categories]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Category] [nvarchar](50) NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category_Type]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category_Type](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Category_ID] [int] NULL,
	[Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_Category_Type] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Devices]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Devices](
	[ID] [int] NOT NULL,
	[Device] [nvarchar](50) NULL,
	[IP_Address] [varchar](50) NULL,
	[Port] [int] NULL,
	[Location_ID] [int] NULL,
	[Status] [varchar](10) NULL,
	[Attenuation] [int] NULL,
	[In_Out] [bit] NULL,
	[TimeLimitType] [nvarchar](10) NULL,
	[TimeLimit] [int] NULL,
 CONSTRAINT [PK_Devices] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Location]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Location](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[RFID] [varchar](50) NULL,
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Reader_Events]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Reader_Events](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Reader_ID] [int] NULL,
	[RFID] [varchar](50) NULL,
	[DateTime] [datetime] NULL,
	[Status] [varchar](20) NULL,
 CONSTRAINT [PK_Reader_Events] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Status]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[System_Log]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[System_Log](
	[DB_Table] [nvarchar](50) NULL,
	[System_Log] [nvarchar](50) NULL,
	[User_ID] [int] NULL,
	[Date_Time] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tag_Read_History]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tag_Read_History](
	[RFID] [varchar](50) NULL,
	[Reader_ID] [int] NULL,
	[Total_Read_Times] [int] NULL,
	[First_Read] [datetime] NULL,
	[Last_Read] [datetime] NULL,
	[Last_Session] [nvarchar](50) NULL,
	[ReadsInSession] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Track_Events]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Track_Events](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Asset_ID] [int] NULL,
	[Location_ID] [int] NULL,
	[User_ID] [int] NULL,
	[Date_Time] [datetime] NULL,
	[Event] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User_Alerts]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User_Alerts](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [int] NULL,
	[Location_ID] [int] NULL,
	[Asset_ID] [int] NULL,
	[Alert] [varchar](max) NULL,
	[DateTime] [datetime] NULL,
	[Seen] [bit] NULL,
 CONSTRAINT [PK_User_Alerts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User_LocationAccess]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_LocationAccess](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [int] NULL,
	[Location_ID] [int] NULL,
 CONSTRAINT [PK_User_LocationAccess] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User_Roles]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Roles](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Role] [nvarchar](50) NULL,
 CONSTRAINT [PK_User_Roles] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User_TrackEvents]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User_TrackEvents](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [int] NULL,
	[Location_ID] [int] NULL,
	[DateTime] [datetime] NULL,
	[Event] [varchar](50) NULL,
 CONSTRAINT [PK_User_TrackEvents] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserInLocation]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInLocation](
	[User_ID] [int] NULL,
	[Location_ID] [int] NULL,
	[DateTime] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[First_Name] [nvarchar](50) NULL,
	[Last_Name] [nvarchar](50) NULL,
	[Username] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[Role] [int] NULL,
	[Email] [nvarchar](50) NULL,
	[RFID] [nvarchar](50) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[View_TrackEvents]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[View_TrackEvents]
AS
SELECT        dbo.Categories.Category, dbo.Category_Type.Type, dbo.Asset_Register.Serial_No, dbo.Location.Name, dbo.Users.First_Name, dbo.Users.Last_Name, dbo.Track_Events.Date_Time ,
                         dbo.Track_Events.Event
FROM            dbo.Track_Events INNER JOIN
                         dbo.Asset_Register ON dbo.Track_Events.Asset_ID = dbo.Asset_Register.ID INNER JOIN
                         dbo.Location ON dbo.Track_Events.Location_ID = dbo.Location.ID  INNER JOIN
                         dbo.Category_Type ON dbo.Asset_Register.Category_Type_ID = dbo.Category_Type.ID INNER JOIN
                         dbo.Categories ON dbo.Category_Type.Category_ID = dbo.Categories.ID LEFT OUTER JOIN 
                         dbo.Users ON dbo.Track_Events.User_ID = dbo.Users.ID



GO
/****** Object:  View [dbo].[View_User_TrackEvents]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_User_TrackEvents]
AS
SELECT        dbo.Users.First_Name, dbo.Users.Last_Name, dbo.Location.Name, dbo.User_TrackEvents.DateTime, dbo.User_TrackEvents.Event
FROM            dbo.Users INNER JOIN
                         dbo.User_TrackEvents ON dbo.Users.ID = dbo.User_TrackEvents.User_ID INNER JOIN
                         dbo.Location ON dbo.User_TrackEvents.Location_ID = dbo.Location.ID

GO
/****** Object:  View [dbo].[View_UserAlerts]    Script Date: 11/20/2015 12:42:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_UserAlerts]
AS
SELECT        dbo.User_Alerts.ID, dbo.Users.First_Name, dbo.Users.Last_Name, dbo.Asset_Register.Serial_No, dbo.Location.Name, dbo.User_Alerts.Alert, dbo.User_Alerts.DateTime, dbo.User_Alerts.Seen
FROM            dbo.User_Alerts INNER JOIN
                         dbo.Asset_Register ON dbo.User_Alerts.Asset_ID = dbo.Asset_Register.ID INNER JOIN
                         dbo.Location ON dbo.User_Alerts.Location_ID = dbo.Location.ID INNER JOIN
                         dbo.Users ON dbo.User_Alerts.User_ID = dbo.Users.ID

GO
ALTER TABLE [dbo].[Asset_Register]  WITH CHECK ADD  CONSTRAINT [FK_Asset_Register_Category_Type] FOREIGN KEY([Category_Type_ID])
REFERENCES [dbo].[Category_Type] ([ID])
GO
ALTER TABLE [dbo].[Asset_Register] CHECK CONSTRAINT [FK_Asset_Register_Category_Type]
GO
ALTER TABLE [dbo].[Category_Type]  WITH CHECK ADD  CONSTRAINT [FK_Category_Type_Categories] FOREIGN KEY([Category_ID])
REFERENCES [dbo].[Categories] ([ID])
GO
ALTER TABLE [dbo].[Category_Type] CHECK CONSTRAINT [FK_Category_Type_Categories]
GO
ALTER TABLE [dbo].[Devices]  WITH CHECK ADD  CONSTRAINT [FK_Devices_Location] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([ID])
GO
ALTER TABLE [dbo].[Devices] CHECK CONSTRAINT [FK_Devices_Location]
GO
ALTER TABLE [dbo].[Track_Events]  WITH CHECK ADD  CONSTRAINT [FK_Track_Events_Asset_Register] FOREIGN KEY([Asset_ID])
REFERENCES [dbo].[Asset_Register] ([ID])
GO
ALTER TABLE [dbo].[Track_Events] CHECK CONSTRAINT [FK_Track_Events_Asset_Register]
GO
ALTER TABLE [dbo].[Track_Events]  WITH CHECK ADD  CONSTRAINT [FK_Track_Events_Location] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([ID])
GO
ALTER TABLE [dbo].[Track_Events] CHECK CONSTRAINT [FK_Track_Events_Location]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Track_Events"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Asset_Register"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 430
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Users"
            Begin Extent = 
               Top = 6
               Left = 676
               Bottom = 136
               Right = 846
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Category_Type"
            Begin Extent = 
               Top = 6
               Left = 884
               Bottom = 119
               Right = 1054
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Categories"
            Begin Extent = 
               Top = 6
               Left = 1092
               Bottom = 102
               Right = 1262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Location"
            Begin Extent = 
               Top = 6
               Left = 468
               Bottom = 119
               Right = 638
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Wid' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_TrackEvents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'th = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_TrackEvents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_TrackEvents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Users"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User_TrackEvents"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Location"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 119
               Right = 624
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_User_TrackEvents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_User_TrackEvents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "User_Alerts"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Asset_Register"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 428
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Location"
            Begin Extent = 
               Top = 6
               Left = 468
               Bottom = 119
               Right = 638
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Users"
            Begin Extent = 
               Top = 6
               Left = 676
               Bottom = 136
               Right = 846
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2955
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_UserAlerts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_UserAlerts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_UserAlerts'
GO
