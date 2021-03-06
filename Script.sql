USE [master]
GO
/****** Object:  Database [Inventories]    Script Date: 06/21/2022 3:23:24 PM ******/
CREATE DATABASE [Inventories]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Inventories', FILENAME = N'C:\Eazisols\Data\Inventories.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Inventories_log', FILENAME = N'C:\Eazisols\Data\Inventories_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Inventories] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Inventories].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Inventories] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Inventories] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Inventories] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Inventories] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Inventories] SET ARITHABORT OFF 
GO
ALTER DATABASE [Inventories] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Inventories] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Inventories] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Inventories] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Inventories] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Inventories] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Inventories] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Inventories] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Inventories] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Inventories] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Inventories] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Inventories] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Inventories] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Inventories] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Inventories] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Inventories] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Inventories] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Inventories] SET RECOVERY FULL 
GO
ALTER DATABASE [Inventories] SET  MULTI_USER 
GO
ALTER DATABASE [Inventories] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Inventories] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Inventories] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Inventories] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Inventories] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Inventories] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Inventories', N'ON'
GO
ALTER DATABASE [Inventories] SET QUERY_STORE = OFF
GO
USE [Inventories]
GO
/****** Object:  UserDefinedFunction [dbo].[ItemSumCal]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[ItemSumCal]  
(  
   @Id INT 
)  
returns int 
as  
begin return(select sum(ItemNetQuantity) as TQty from(

select I.ItemId as ItemId, Cat.Name as CategoryName,I.Name as ItemName,CII.ItemNetQuantity as ItemNetQuantity from tblCheckin as CI 
inner join tblCheckinItem as CII on CI.CheckinId=CII.CheckinId inner join tblItem as I on CII.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId  where I.ItemId=@Id

union

select I.ItemId as ItemId, Cat.Name as CategoryName,I.Name as ItemName,TI.ItemNetQuantity as ItemNetQuantity from tblTransfer as T 
inner join tblTransferItem as TI on T.TransferId=TI.TransferId inner join tblItem as I on TI.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId  where I.ItemId=@Id

union

select I.ItemId as ItemId, Cat.Name as CategoryName,I.Name as ItemName,AI.ItemNetQuantity as ItemNetQuantity from tblAdjustment as A 
inner join tblAdjustmentItem as AI on A.AdjustmentId=AI.AdjustmentId inner join tblItem as I on AI.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId  where I.ItemId=@Id
) as Z group by ItemId,CategoryName,ItemName)  
end  
GO
/****** Object:  Table [dbo].[tblAccessLevel]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAccessLevel](
	[AccessId] [int] IDENTITY(1,1) NOT NULL,
	[EditAccess] [bit] NULL,
	[DeleteAccess] [bit] NULL,
	[CreateAccess] [bit] NULL,
	[MenuId] [int] NULL,
	[RoleId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[DeletedBy] [int] NULL,
	[DeletedDate] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK__tblAcces__4130D05FDB13929B] PRIMARY KEY CLUSTERED 
(
	[AccessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAdjustment]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAdjustment](
	[AdjustmentId] [int] IDENTITY(1,1) NOT NULL,
	[AdjustmentNumber] [nvarchar](max) NULL,
	[AdjustmentDate] [date] NOT NULL,
	[Reference] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[Warehouse] [int] NULL,
	[Attachment] [nvarchar](max) NULL,
	[Details] [nvarchar](max) NULL,
	[draft] [bit] NULL,
	[QRCode] [nvarchar](max) NULL,
	[BarCode] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK__tblAdjus__E60DB893F12CF73A] PRIMARY KEY CLUSTERED 
(
	[AdjustmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAdjustmentItem]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAdjustmentItem](
	[AdjustmentItemId] [int] IDENTITY(1,1) NOT NULL,
	[AdjustmentId] [int] NULL,
	[ItemId] [int] NULL,
	[ItemWeight] [int] NULL,
	[ItemQuantity] [int] NULL,
	[ItemUnit] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[ItemUsedQuantity] [int] NULL,
	[ItemNetQuantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AdjustmentItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAlertQty]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAlertQty](
	[AlertQtyId] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NULL,
	[Notify] [bit] NULL,
	[TotalQty] [int] NULL,
	[NotifyDate] [datetime] NULL,
 CONSTRAINT [PK_tblAlertQty] PRIMARY KEY CLUSTERED 
(
	[AlertQtyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCategory]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCategory](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCheckin]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCheckin](
	[CheckinId] [int] IDENTITY(1,1) NOT NULL,
	[CheckinNumber] [nvarchar](max) NULL,
	[CheckinDate] [date] NOT NULL,
	[Reference] [nvarchar](max) NULL,
	[Contact] [int] NULL,
	[Warehouse] [int] NULL,
	[Attachment] [nvarchar](max) NULL,
	[Details] [nvarchar](max) NULL,
	[draft] [bit] NULL,
	[QRCode] [nvarchar](max) NULL,
	[BarCode] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK__tblCheck__F3C85D71DD0F3637] PRIMARY KEY CLUSTERED 
(
	[CheckinId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCheckinItem]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCheckinItem](
	[CheckinItemId] [int] IDENTITY(1,1) NOT NULL,
	[CheckinId] [int] NULL,
	[ItemId] [int] NULL,
	[ItemWeight] [int] NULL,
	[ItemQuantity] [int] NULL,
	[ItemUnit] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[ItemUsedQuantity] [int] NULL,
	[ItemNetQuantity] [int] NULL,
 CONSTRAINT [PK__tblCheck__1DA97B26CFA31501] PRIMARY KEY CLUSTERED 
(
	[CheckinItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCheckout]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCheckout](
	[CheckoutId] [int] IDENTITY(1,1) NOT NULL,
	[CheckoutNumber] [nvarchar](max) NULL,
	[CheckoutDate] [date] NOT NULL,
	[Reference] [nvarchar](max) NULL,
	[Contact] [int] NULL,
	[Warehouse] [int] NULL,
	[Attachment] [nvarchar](max) NULL,
	[Details] [nvarchar](max) NULL,
	[draft] [bit] NULL,
	[QRCode] [nvarchar](max) NULL,
	[BarCode] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK__tblCheck__E07EF5FCF2A309B8] PRIMARY KEY CLUSTERED 
(
	[CheckoutId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCheckoutItem]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCheckoutItem](
	[CheckoutItemId] [int] IDENTITY(1,1) NOT NULL,
	[CheckoutId] [int] NULL,
	[ItemId] [int] NULL,
	[ItemWeight] [int] NULL,
	[ItemQuantity] [int] NULL,
	[ItemUnit] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[CheckinItemId] [int] NULL,
	[VNumber] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[CheckoutItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblContact]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblContact](
	[ContactId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[Details] [nvarchar](max) NULL,
	[ContactType] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK__tblConta__5C66259B4C8D5820] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblEmailSetting]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmailSetting](
	[EmailSettingId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[SMTP] [nvarchar](max) NULL,
	[Port] [nvarchar](max) NULL,
	[isActive] [bit] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
 CONSTRAINT [PK_tblEmailSetting] PRIMARY KEY CLUSTERED 
(
	[EmailSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblItem]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblItem](
	[ItemId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
	[CategoryId] [int] NULL,
	[Unit] [nvarchar](max) NULL,
	[BarcodeSymbology] [nvarchar](max) NULL,
	[RackLocation] [nvarchar](max) NULL,
	[SKU] [nvarchar](max) NULL,
	[Details] [nvarchar](max) NULL,
	[Alertonlowstock] [int] NULL,
	[TrackQuantity] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblMenu]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMenu](
	[MenuId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[NameES] [nvarchar](max) NULL,
	[ControllerName] [nvarchar](50) NULL,
	[ActionName] [nvarchar](50) NULL,
	[isParent] [bit] NULL,
	[ParentId] [int] NULL,
	[FontAwesome] [nvarchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[DeletedBy] [int] NULL,
	[DeletedDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[ElementId] [nvarchar](max) NULL,
 CONSTRAINT [PK__tblMenu__C99ED23030211200] PRIMARY KEY CLUSTERED 
(
	[MenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRole]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRole](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[Role] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblSetting]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSetting](
	[SettingId] [int] IDENTITY(1,1) NOT NULL,
	[Logo] [image] NULL,
	[Name] [nvarchar](max) NULL,
	[Color] [nvarchar](max) NULL,
	[HoverColor] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
 CONSTRAINT [PK_tblSetting] PRIMARY KEY CLUSTERED 
(
	[SettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTempPath]    Script Date: 06/21/2022 3:23:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTempPath](
	[TempPathId] [int] IDENTITY(1,1) NOT NULL,
	[TNumber] [nvarchar](max) NULL,
	[CINumber] [nvarchar](max) NULL,
	[CONumber] [nvarchar](max) NULL,
	[ANumber] [nvarchar](max) NULL,
	[Path] [nvarchar](max) NULL,
	[UserId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK__tblTempP__247BD9CB2A662F66] PRIMARY KEY CLUSTERED 
(
	[TempPathId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTransfer]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTransfer](
	[TransferId] [int] IDENTITY(1,1) NOT NULL,
	[TransferNumber] [nvarchar](max) NULL,
	[TransferDate] [date] NOT NULL,
	[Reference] [nvarchar](max) NULL,
	[FromWarehouse] [int] NULL,
	[ToWarehouse] [int] NULL,
	[Attachment] [nvarchar](max) NULL,
	[Details] [nvarchar](max) NULL,
	[draft] [bit] NULL,
	[QRCode] [nvarchar](max) NULL,
	[BarCode] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK__tblTrans__95490091EA4CB563] PRIMARY KEY CLUSTERED 
(
	[TransferId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTransferItem]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTransferItem](
	[TransferItemId] [int] IDENTITY(1,1) NOT NULL,
	[TransferId] [int] NULL,
	[ItemId] [int] NULL,
	[ItemWeight] [int] NULL,
	[ItemQuantity] [int] NULL,
	[ItemUnit] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[CheckinItemId] [int] NULL,
	[ItemUsedQuantity] [int] NULL,
	[ItemNetQuantity] [int] NULL,
	[VNumber] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[TransferItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUnit]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUnit](
	[UnitId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
	[BaseUnit] [nvarchar](max) NULL,
	[Operator] [nvarchar](max) NULL,
	[OperationValue] [float] NULL,
	[Formula] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK__tblUnit__44F5ECB54B2FDB44] PRIMARY KEY CLUSTERED 
(
	[UnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUser]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUser](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Username] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Warehouse] [int] NULL,
	[Phone] [nvarchar](max) NULL,
	[RoleId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUserWarehouse]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserWarehouse](
	[UserWarehouseId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[WarehouseId] [int] NULL,
 CONSTRAINT [PK_tblUserWarehouse] PRIMARY KEY CLUSTERED 
(
	[UserWarehouseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWarehouse]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWarehouse](
	[WarehouseId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Logo] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[WarehouseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tblAccessLevel] ON 

INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (462, 0, 0, 0, 2, 1, 1, CAST(N'2022-06-02T19:22:14.853' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.853' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (463, 0, 0, 0, 3, 1, 1, CAST(N'2022-06-02T19:22:14.867' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.867' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (464, 1, 1, 1, 4, 1, 1, CAST(N'2022-06-02T19:22:14.867' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.867' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (465, 0, 0, 0, 5, 1, 1, CAST(N'2022-06-02T19:22:14.867' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.867' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (466, 0, 0, 0, 6, 1, 1, CAST(N'2022-06-02T19:22:14.870' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.870' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (467, 1, 1, 1, 7, 1, 1, CAST(N'2022-06-02T19:22:14.870' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.870' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (468, 1, 1, 1, 8, 1, 1, CAST(N'2022-06-02T19:22:14.873' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.873' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (469, 1, 1, 1, 9, 1, 1, CAST(N'2022-06-02T19:22:14.873' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.873' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (470, 1, 1, 1, 10, 1, 1, CAST(N'2022-06-02T19:22:14.873' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.873' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (471, 1, 1, 1, 11, 1, 1, CAST(N'2022-06-02T19:22:14.877' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.877' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (472, 1, 1, 1, 12, 1, 1, CAST(N'2022-06-02T19:22:14.877' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.877' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (473, 0, 0, 0, 13, 1, 1, CAST(N'2022-06-02T19:22:14.880' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.880' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (474, 1, 1, 1, 14, 1, 1, CAST(N'2022-06-02T19:22:14.880' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.880' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (475, 0, 0, 0, 15, 1, 1, CAST(N'2022-06-02T19:22:14.880' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.880' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (476, 1, 1, 1, 16, 1, 1, CAST(N'2022-06-02T19:22:14.883' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.883' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (477, 0, 0, 0, 17, 1, 1, CAST(N'2022-06-02T19:22:14.883' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.883' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (478, 1, 1, 1, 18, 1, 1, CAST(N'2022-06-02T19:22:14.883' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.883' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (479, 0, 0, 0, 19, 1, 1, CAST(N'2022-06-02T19:22:14.887' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.887' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (480, 0, 0, 0, 20, 1, 1, CAST(N'2022-06-02T19:22:14.887' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.887' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (481, 0, 0, 0, 21, 1, 1, CAST(N'2022-06-02T19:22:14.890' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.890' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (482, 0, 0, 0, 22, 1, 1, CAST(N'2022-06-02T19:22:14.890' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.890' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (483, 0, 0, 0, 23, 1, 1, CAST(N'2022-06-02T19:22:14.890' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.890' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (484, 0, 0, 0, 24, 1, 1, CAST(N'2022-06-02T19:22:14.893' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.893' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (485, 0, 0, 0, 25, 1, 1, CAST(N'2022-06-02T19:22:14.893' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.893' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (486, 0, 0, 0, 26, 1, 1, CAST(N'2022-06-02T19:22:14.893' AS DateTime), 1, CAST(N'2022-06-02T19:22:14.893' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (512, 0, 0, 0, 2, 2, 1, CAST(N'2022-06-06T12:48:17.557' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.557' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (513, 0, 0, 0, 3, 2, 1, CAST(N'2022-06-06T12:48:17.590' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.590' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (514, 0, 0, 0, 4, 2, 1, CAST(N'2022-06-06T12:48:17.597' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.597' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (515, 0, 0, 0, 5, 2, 1, CAST(N'2022-06-06T12:48:17.607' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.607' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (516, 0, 0, 0, 6, 2, 1, CAST(N'2022-06-06T12:48:17.613' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.613' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (517, 0, 0, 0, 7, 2, 1, CAST(N'2022-06-06T12:48:17.613' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.613' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (518, 0, 0, 0, 8, 2, 1, CAST(N'2022-06-06T12:48:17.623' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.623' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (519, 0, 0, 0, 9, 2, 1, CAST(N'2022-06-06T12:48:17.630' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.630' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (520, 0, 0, 0, 10, 2, 1, CAST(N'2022-06-06T12:48:17.630' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.630' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (521, 0, 0, 0, 11, 2, 1, CAST(N'2022-06-06T12:48:17.640' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.640' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (522, 0, 0, 0, 12, 2, 1, CAST(N'2022-06-06T12:48:17.647' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.647' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (523, 0, 0, 0, 13, 2, 1, CAST(N'2022-06-06T12:48:17.647' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.647' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (524, 0, 0, 0, 14, 2, 1, CAST(N'2022-06-06T12:48:17.657' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.657' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (525, 0, 0, 0, 15, 2, 1, CAST(N'2022-06-06T12:48:17.663' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.663' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (526, 0, 0, 0, 16, 2, 1, CAST(N'2022-06-06T12:48:17.663' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.663' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (527, 0, 0, 0, 17, 2, 1, CAST(N'2022-06-06T12:48:17.677' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.677' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (528, 0, 0, 0, 18, 2, 1, CAST(N'2022-06-06T12:48:17.683' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.683' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (529, 0, 0, 0, 19, 2, 1, CAST(N'2022-06-06T12:48:17.690' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.690' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (530, 0, 0, 0, 20, 2, 1, CAST(N'2022-06-06T12:48:17.693' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.693' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (531, 0, 0, 0, 21, 2, 1, CAST(N'2022-06-06T12:48:17.700' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.700' AS DateTime), NULL, NULL, 0)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (532, 0, 0, 0, 22, 2, 1, CAST(N'2022-06-06T12:48:17.703' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.703' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (533, 0, 0, 0, 23, 2, 1, CAST(N'2022-06-06T12:48:17.713' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.713' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (534, 0, 0, 0, 24, 2, 1, CAST(N'2022-06-06T12:48:17.717' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.717' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (535, 0, 0, 0, 25, 2, 1, CAST(N'2022-06-06T12:48:17.723' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.723' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (536, 0, 0, 0, 26, 2, 1, CAST(N'2022-06-06T12:48:17.730' AS DateTime), 1, CAST(N'2022-06-06T12:48:17.730' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[tblAccessLevel] OFF
GO
SET IDENTITY_INSERT [dbo].[tblAdjustment] ON 

INSERT [dbo].[tblAdjustment] ([AdjustmentId], [AdjustmentNumber], [AdjustmentDate], [Reference], [Type], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'A-001', CAST(N'2022-05-25' AS Date), N'Ref', N'Damage', 1, N'\Uploading\Tracking XML Developer Guide.pdf', N'Details', 0, NULL, NULL, 1, CAST(N'2022-05-25T14:18:41.377' AS DateTime), 1, CAST(N'2022-05-25T14:18:41.377' AS DateTime), NULL)
INSERT [dbo].[tblAdjustment] ([AdjustmentId], [AdjustmentNumber], [AdjustmentDate], [Reference], [Type], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (3, N'A-002', CAST(N'2022-06-01' AS Date), N'A-Ref', N'Addition', 1, NULL, N'Details', NULL, NULL, NULL, 1, CAST(N'2022-06-01T15:13:34.017' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblAdjustment] ([AdjustmentId], [AdjustmentNumber], [AdjustmentDate], [Reference], [Type], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (4, N'A-004', CAST(N'2022-06-01' AS Date), N'Ref', N'Addition', 3, NULL, N'Details', NULL, N'/Uploading/QRCode/A-004.jpg', N'/Uploading/BarCode/A-004.jpg', 1, CAST(N'2022-06-16T16:58:33.583' AS DateTime), 1, CAST(N'2022-06-16T16:58:33.583' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[tblAdjustment] OFF
GO
SET IDENTITY_INSERT [dbo].[tblAdjustmentItem] ON 

INSERT [dbo].[tblAdjustmentItem] ([AdjustmentItemId], [AdjustmentId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (3, 1, 1, 1, 1, N'Dozen', 1, CAST(N'2022-05-25T14:18:41.393' AS DateTime), NULL, NULL, NULL, 0, 1)
INSERT [dbo].[tblAdjustmentItem] ([AdjustmentItemId], [AdjustmentId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (5, 3, 1, 1, 6, N'Piece', 1, CAST(N'2022-06-01T15:13:34.040' AS DateTime), NULL, NULL, NULL, 0, 6)
INSERT [dbo].[tblAdjustmentItem] ([AdjustmentItemId], [AdjustmentId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (7, 4, 1, 1, 10, N'Piece', 1, CAST(N'2022-06-16T16:58:33.613' AS DateTime), NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblAdjustmentItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblAlertQty] ON 

INSERT [dbo].[tblAlertQty] ([AlertQtyId], [ItemId], [Notify], [TotalQty], [NotifyDate]) VALUES (1, 3, 1, 8, CAST(N'2022-06-13T15:08:00.353' AS DateTime))
SET IDENTITY_INSERT [dbo].[tblAlertQty] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCategory] ON 

INSERT [dbo].[tblCategory] ([CategoryId], [Name], [Code], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'A', N'100', 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCheckin] ON 

INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (3, N'CI-002', CAST(N'2022-05-27' AS Date), N'Ref', 1, 1, NULL, NULL, 0, NULL, NULL, 1, CAST(N'2022-05-27T17:07:54.970' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (4, N'CI-004', CAST(N'2022-05-27' AS Date), N'Ref', 1, 1, NULL, NULL, 0, NULL, NULL, 1, CAST(N'2022-05-27T18:15:33.817' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (5, N'CI-005', CAST(N'2022-06-01' AS Date), N'CI-Ref', 1, 3, NULL, N'Deteils', 0, NULL, NULL, 1, CAST(N'2022-06-01T15:11:27.997' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (6, N'CI-006', CAST(N'2022-06-01' AS Date), N'CI-Ref', 1, 3, NULL, N'Details', 0, NULL, NULL, 1, CAST(N'2022-06-01T15:35:50.437' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (7, N'CI-007', CAST(N'2022-06-03' AS Date), N'Ref', 1, 3, N'\Uploading\Points.docx', NULL, 0, NULL, NULL, 1, CAST(N'2022-06-03T14:13:34.907' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (8, N'CI-008', CAST(N'2022-06-03' AS Date), N'CI-Ref', 1, 1, NULL, NULL, 0, NULL, NULL, 1, CAST(N'2022-06-03T14:19:05.163' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (9, N'CI-009', CAST(N'2022-06-03' AS Date), N'CI-Ref', 1, 3, NULL, NULL, 0, NULL, NULL, 1, CAST(N'2022-06-03T14:59:08.953' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (14, N'CI-0010', CAST(N'2022-06-10' AS Date), N'CI-Ref', 1, 1, NULL, NULL, 0, NULL, NULL, 1, CAST(N'2022-06-10T12:14:45.710' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (16, N'CI-0015', CAST(N'2022-06-10' AS Date), N'CI-Ref', 1, 1, NULL, NULL, 0, NULL, NULL, 1, CAST(N'2022-06-10T16:20:28.727' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (21, N'CI-0017', CAST(N'2022-06-16' AS Date), N'CI-Ref1', 1, 1, NULL, NULL, 0, N'/Uploading/QRCode/CI-0017.jpg', N'/Uploading/BarCode/CI-0017.jpg', 1, CAST(N'2022-06-16T16:48:50.013' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblCheckin] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCheckinItem] ON 

INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (3, 3, 1, 1, 10, N'Piece', 1, CAST(N'2022-05-27T17:07:55.027' AS DateTime), NULL, NULL, NULL, 10, 0)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (4, 4, 1, 1, 15, N'Piece', 1, CAST(N'2022-05-27T18:15:33.830' AS DateTime), NULL, NULL, NULL, 10, 5)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (5, 5, 1, 1, 10, N'Piece', 1, CAST(N'2022-06-01T15:11:28.073' AS DateTime), NULL, NULL, NULL, 10, 0)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (6, 6, 1, 1, 10, N'Piece', 1, CAST(N'2022-06-01T15:35:50.493' AS DateTime), NULL, NULL, NULL, 6, 4)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (7, 7, 3, 1, 6, N'Piece', 1, CAST(N'2022-06-03T14:13:34.953' AS DateTime), NULL, NULL, NULL, 6, 0)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (8, 8, 3, 1, 5, N'Piece', 1, CAST(N'2022-06-03T14:19:05.190' AS DateTime), NULL, NULL, NULL, 0, 5)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (9, 9, 3, 1, 2, N'Piece', 1, CAST(N'2022-06-03T14:59:08.960' AS DateTime), NULL, NULL, NULL, 1, 1)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (14, 14, 1, 1, 1, N'Piece', 1, CAST(N'2022-06-10T12:14:45.810' AS DateTime), NULL, NULL, NULL, 0, 1)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (16, 16, 3, 1, 2, N'Piece', 1, CAST(N'2022-06-10T16:20:28.783' AS DateTime), NULL, NULL, NULL, 0, 2)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (24, 21, 1, 1, 7, N'Piece', 1, CAST(N'2022-06-16T16:48:50.053' AS DateTime), NULL, NULL, NULL, 0, 7)
SET IDENTITY_INSERT [dbo].[tblCheckinItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCheckout] ON 

INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'CO-001', CAST(N'2022-05-25' AS Date), N'Ref', 1, 1, N'\Uploading\Tracking RESTful Developer Guide.pdf', N'Details', 0, NULL, NULL, 1, CAST(N'2022-05-25T13:05:40.043' AS DateTime), 1, CAST(N'2022-05-25T13:05:40.043' AS DateTime), NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (5, N'CO-002', CAST(N'2022-05-27' AS Date), N'Ref', 1, 1, NULL, NULL, 0, NULL, NULL, 1, CAST(N'2022-05-30T15:05:29.800' AS DateTime), 1, CAST(N'2022-05-30T15:05:30.113' AS DateTime), NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (9, N'CO-006', CAST(N'2022-05-30' AS Date), N'Ref', 1, 1, NULL, N'Det', 0, NULL, NULL, 1, CAST(N'2022-05-30T19:51:36.783' AS DateTime), 1, CAST(N'2022-05-30T19:51:36.783' AS DateTime), NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (10, N'CO-0010', CAST(N'2022-06-01' AS Date), N'CO-Ref', 1, 3, NULL, N'Details', 0, NULL, NULL, 1, CAST(N'2022-06-01T15:12:21.667' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (11, N'CO-0011', CAST(N'2022-06-01' AS Date), N'CO-Ref', 1, 3, NULL, N'Details', 0, NULL, NULL, 1, CAST(N'2022-06-01T15:36:21.707' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (17, N'CO-0012', CAST(N'2022-06-06' AS Date), N'Ref', 1, 3, NULL, NULL, 0, NULL, NULL, 1, CAST(N'2022-06-06T19:43:57.787' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (19, N'CO-0018', CAST(N'2022-06-07' AS Date), N'Ref', 1, 3, NULL, NULL, 0, N'/Uploading/QRCode/CO-0018.jpg', N'/Uploading/BarCode/CO-0018.jpg', 1, CAST(N'2022-06-16T16:58:22.527' AS DateTime), 1, CAST(N'2022-06-16T16:58:22.527' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[tblCheckout] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCheckoutItem] ON 

INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (3, 1, 1, 1, 1, N'Dozen', 1, CAST(N'2022-05-25T13:05:40.070' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (4, 1, 1, 1, 1, N'Piece', 1, CAST(N'2022-05-25T13:05:40.070' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (10, 5, 1, NULL, 2, NULL, 1, CAST(N'2022-05-30T15:05:58.650' AS DateTime), NULL, NULL, NULL, 3, N'C')
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (14, 9, 1, NULL, 3, NULL, 1, CAST(N'2022-05-30T19:51:36.920' AS DateTime), NULL, NULL, NULL, 23, NULL)
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (15, 10, 1, NULL, 5, NULL, 1, CAST(N'2022-06-01T15:12:21.737' AS DateTime), NULL, NULL, NULL, 5, N'CI-005')
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (16, 11, 1, NULL, 6, NULL, 1, CAST(N'2022-06-01T15:36:21.760' AS DateTime), NULL, NULL, NULL, 6, N'CI-006')
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (22, 17, 3, NULL, 1, NULL, 1, CAST(N'2022-06-06T19:43:57.793' AS DateTime), NULL, NULL, NULL, 9, N'CI-009')
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (35, 19, 3, NULL, 6, NULL, 1, CAST(N'2022-06-07T11:55:09.743' AS DateTime), NULL, NULL, NULL, 7, N'CI-007')
SET IDENTITY_INSERT [dbo].[tblCheckoutItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblContact] ON 

INSERT [dbo].[tblContact] ([ContactId], [Name], [Email], [Phone], [Details], [ContactType], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'Asad', N'asad@gmail.com', N'03210000000', N'Contact Info', NULL, 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblContact] OFF
GO
SET IDENTITY_INSERT [dbo].[tblEmailSetting] ON 

INSERT [dbo].[tblEmailSetting] ([EmailSettingId], [Email], [Password], [SMTP], [Port], [isActive], [EditBy], [EditDate]) VALUES (1, N'restock06@gmail.com', N'Developer@123', N'smtp.gmail.com', N'587', 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblEmailSetting] OFF
GO
SET IDENTITY_INSERT [dbo].[tblItem] ON 

INSERT [dbo].[tblItem] ([ItemId], [Name], [Code], [CategoryId], [Unit], [BarcodeSymbology], [RackLocation], [SKU], [Details], [Alertonlowstock], [TrackQuantity], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'Chair', N'100', 1, N'Kilogram', N'CODE128', N'Left', NULL, N'Good', 5, 1, 1, CAST(N'2022-05-23T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-23T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[tblItem] ([ItemId], [Name], [Code], [CategoryId], [Unit], [BarcodeSymbology], [RackLocation], [SKU], [Details], [Alertonlowstock], [TrackQuantity], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (3, N'Table', N'1001', 1, N'Kilogram', N'EAN-13', N'Left', NULL, N'details', 9, 1, 1, CAST(N'2022-06-01T00:00:00.000' AS DateTime), 1, CAST(N'2022-06-01T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblMenu] ON 

INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (2, N'Dashboard', N'Tablero', N'Home', N'Index', 0, 0, N'fe fe-home', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Dashboard')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (3, N'User Management', N'Gestión de usuarios
', N'User', N'', 1, 0, N'fa fa-users', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'UM')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (4, N'Users', N'Usuarios', N'User', N'Users', 0, 3, N'fa fa-user', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Users')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (5, N'Permissions', N'Permisos', N'User', N'RolesPermission', 0, 3, N'fa fa-key', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Roles')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (6, N'Setup', N'Configuración', NULL, NULL, 1, 0, N'fa fa-code', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Setup')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (7, N'Contacts', N'Contactos', N'Contact', N'Contacts', 0, 6, N'fa fa-address-book', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Contacts')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (8, N'Categories', N'Categorías', N'Category', N'Categories', 0, 6, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Categories')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (9, N'Units', N'Unidades', N'Unit', N'Units', 0, 6, N'fa fa-microchip', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Units')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (10, N'Warehouses', N'Almacenes', N'Warehouse', N'Warehouses', 0, 6, N'fa fa-warehouse', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Warehouses')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (11, N'Items', N'Elementos', N'Item', N'Items', 0, 6, N'fa fa-heart', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Items')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (12, N'Transfer', N'Transferir', NULL, NULL, 1, 0, N'fa fa-truck', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Transfer')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (13, N'Transfers', N'Transferencias', N'Transfer', N'Transfers', 0, 12, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Transfers')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (14, N'Checkin', N'Registrarse', NULL, NULL, 1, 0, N'fa fa-arrow-left', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Checkin')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (15, N'Checkins', N'registros', N'Checkin', N'Checkins', 0, 14, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Checkins')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (16, N'Checkout', N'Verificar', NULL, NULL, 1, 0, N'fa fa-arrow-right', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Checkout')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (17, N'Checkouts', N'Cajas', N'Checkout', N'Checkouts', 0, 16, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Checkouts')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (18, N'Adjustment', N'Ajustamiento', NULL, NULL, 1, 0, N'fa fa-adjust', NULL, NULL, NULL, NULL, NULL, NULL, 0, N'Adjustment')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (19, N'Adjustments', N'Ajustes', N'Adjustment', N'Adjustments', 0, 18, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Adjustments')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (20, N'Reports', N'Informes', N'', N'', 1, 0, N'fa fa-file', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Reports')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (21, N'Total Records', N'Registros totales', N'Report', N'TotalRecord', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'TotalRecord')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (22, N'Checkin Report', N'Informe de registro', N'Report', N'CheckinReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'CheckinReport')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (23, N'Checkout Report', N'Informe de pago', N'Report', N'CheckoutReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'CheckoutReport')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (24, N'Transfer Report', N'Informe de transferencia', N'Report', N'TransferReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'TransferReport')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (25, N'Adjustment Report', N'Informe de ajuste', N'Report', N'AdjustmentReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'AdjustmentReport')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [NameES], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (26, N'Item Stock Ledger Report', N'Informe del libro mayor de existencias de artículos', N'Report', N'ItemStockLedgerReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'ItemStockLedgerReport')
SET IDENTITY_INSERT [dbo].[tblMenu] OFF
GO
SET IDENTITY_INSERT [dbo].[tblRole] ON 

INSERT [dbo].[tblRole] ([RoleId], [Role], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'Admin', 1, CAST(N'2022-05-19T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-19T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[tblRole] ([RoleId], [Role], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (2, N'Employee', 1, CAST(N'2022-06-01T00:00:00.000' AS DateTime), 1, CAST(N'2022-06-01T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblRole] OFF
GO
SET IDENTITY_INSERT [dbo].[tblSetting] ON 

INSERT [dbo].[tblSetting] ([SettingId], [Logo], [Name], [Color], [HoverColor], [CreatedBy], [CreatedDate], [EditBy], [EditDate]) VALUES (1, 0xFFD8FFE100884578696600004D4D002A000000080005011A0005000000010000004A011B0005000000010000005201280003000000010002000002130003000000010001000082980002000000250000005A0000000000000048000000010000004800000001417269736B792050616E64752057696E6F746F207C20447265616D7374696D652E636F6D0000FFED004C50686F746F73686F7020332E30003842494D04040000000000301C02740024417269736B792050616E64752057696E6F746F207C20447265616D7374696D652E636F6D1C020000020004FFE10C75687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F003C3F787061636B657420626567696E3D27EFBBBF272069643D2757354D304D7043656869487A7265537A4E54637A6B633964273F3E0A3C783A786D706D65746120786D6C6E733A783D2761646F62653A6E733A6D6574612F2720783A786D70746B3D27496D6167653A3A45786966546F6F6C2031302E3830273E0A3C7264663A52444620786D6C6E733A7264663D27687474703A2F2F7777772E77332E6F72672F313939392F30322F32322D7264662D73796E7461782D6E7323273E0A0A203C7264663A4465736372697074696F6E207264663A61626F75743D27270A2020786D6C6E733A706C75733D27687474703A2F2F6E732E757365706C75732E6F72672F6C64662F786D702F312E302F273E0A20203C706C75733A4C6963656E736F723E0A2020203C7264663A5365713E0A202020203C7264663A6C69207264663A7061727365547970653D275265736F75726365273E0A20202020203C706C75733A4C6963656E736F7255524C3E68747470733A2F2F7777772E647265616D7374696D652E636F6D3C2F706C75733A4C6963656E736F7255524C3E0A202020203C2F7264663A6C693E0A2020203C2F7264663A5365713E0A20203C2F706C75733A4C6963656E736F723E0A203C2F7264663A4465736372697074696F6E3E0A0A203C7264663A4465736372697074696F6E207264663A61626F75743D27270A2020786D6C6E733A786D705269676874733D27687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F7269676874732F273E0A20203C786D705269676874733A57656253746174656D656E743E68747470733A2F2F7777772E647265616D7374696D652E636F6D2F61626F75742D73746F636B2D696D6167652D6C6963656E7365733C2F786D705269676874733A57656253746174656D656E743E0A203C2F7264663A4465736372697074696F6E3E0A3C2F7264663A5244463E0A3C2F783A786D706D6574613E0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200A3C3F787061636B657420656E643D2777273F3EFFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFC2000B080320032001012200FFC4001B00010002030101000000000000000000000002060405070103FFDA0008010100000001BCCC00000000000000000000000109CC00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000000000000000104C00000000000001E7A000000000413000000000000189AAD56AB559BA9BF5A800000000104C000000000018BAAD4EAB55AAC42C3D177381CF75FD137A000000002098000000000C5D56AB53AAD56201B5E89660D373AC9E87B2000000004130000000063EA355AAD4EAB1000CCE817193E1A3DAE7159E7DBFBF65000000008260000000153E65F10007D6F57AFB1E566C5C9BA96611A6D22E376FA0000000209800000010E714A0007B70E839A18989B6E7561B207C68956BEDB3D000000104C000000181CAB48000B2745DB00AC67527A57D40C1E7DAAE8960000000209800000056B97630006DFA2D8C00F87DC00D473AFA744DA00000041300000023CFE87E000CEE836FF004000F00F056F9E6FBA06580000104C00000187CB6BC000FB592ECF1EBC7A007A3DF1ED1EB3D63336E00000413000000D072DC1000170E9E2B39063507B280AB659874CEBA60F0EEF3F600000104C000003E5CC2A80002E1D3C57647C69BD60056BEA63D5BA8983C3BBCFD80000041300000072BAA0000B874FD663800000F3238A779FB000000826000000E5754000170E9F4CF88000012AEDA798779FB000000826000F8EBF6B83918FF2D96AF65F472BAA0000B874FAD6D8000009D0377CC3BCFD9819FACD962C93FB000209800349F4DBD736D95A9CD86BF7EE5754000170E9F4CC5000003EBA1B3730EF3F6693715CFB31AD3A5DD000209800359F2DB6AFDDA6BF235395B572BAA0000B874FA4EBC03DC8F71E200FAEA6CFCC3BCFD9ADD96A3298BB7D6EC800104C000001CAEA80002E1D3EAD9A01283D00146B2F30EF3F600000104C000001CAEA81F6F9C402E1D3EA3203CF670979E003E95BDE730EF3F600000104C000001CAEA827F5F9FCE519229C6DFD3E9784F4F3DFAFC5F58C7C3D3CF4FAE8ECFCC3BCFD80000041300000072BAA19128C3E9E43E8F94E4B5749A9FC671F3DF61F4F3CF1ECA1F481EF9E255BB3F30EF3F600000104C00035FAF015ED725F4F94D2F8CFE91F9FD7E72D96EF03EFE0F7CF7CF7C3D78F7CF7C27A9C9D15BE40361B00002098000000790F7C943EB0F128FBE7B19C7D8CE32F61E88FD3E728FD209FCE5300000008260000000F232F63247CF7D8FBEF928FBE1279191E7BE7B19C7C9427E800000041300000000000000000000000041323CD6E1BC68A9FD2A6A4E5DAC2B556E8FF0070D1535EE7DC73856EA82C56D30B9EF45CA69A99D3030A93A8C8B4DA42ABADBE143DA5A057A9F8DB1B8EE0F87371F4E962098E4999D3DCB6A5D66CD0E19D4AC81C5B5FD02F2150E697EF2BDA9ED3965168D7937361357C53B7EC157E59DEC6AF8F6DAD1854BB6F4B1CEF45D84E3D60E826938F5F363A6DD5B8C4E1777CE4EEE2098A773AEE90E17B6D9F50AD72EEE7315BE5FD139FF6E90A8739EEA8F09E936F28B50ED206AF8A76FD82AFCB3BD8E4B1EB7EB43C7BB26ECE77A2EC271EB0741299CF7B6E4031385F66DC8104C6370BEB5F1E77D2F95774E66E9E1C8B797EE21D1AD82A1CE7BAB5FC4FAAD9CA2F3FDC9D4B3CD5F14DC7D18D81DEC708E916F1C46ED7839DE8BB09C7AC1D04C3E418360B2DC3E86270BDC7D96FB908261C8F3F1F67D0386F4CE61D4EC834FC63A466D430BB30A8731DBF9ACB27549145A4F4A2C1F6357C53A5E634748EF6386DEAF04786743B91CF6BDD8CE3964BF88E8ABD4DDC75A31385F47D9365B4104C29DCEFE5D8F6FCD2B98FDCE63976976856BAE580A8736EADF1E5DD52CA28B50ED206AF8A76FD82AFCB3BD8E7553EC1B1F39FD1FB6E6153E63DAF3F038A751B4985E6729740EE66270BECDB90209862F0CD976B57B90DC3A78C1E23D7F7A72EC7EB25439CF755339FF69CA28BCFB686FBA49ABE29DBF60ABF2CEF63E7CB6B3B8C3F8F51B288725D26D755BCEB522A1CCF73F5D1DF6F86270BD9FD4EBF90413068B236AF2BDB4CE185ABB08C3D5584C2D6EFCAFEC73CD7EB4656E0F968B7DF4626A6C20D46A7EF60FB03CD0E06C37BE860E93E7B9DA086802C12209800000000000000000000000209800000000000000000000000209800000C4D4FDB77ACD9EB7615FD8EC75BB2D06DE3E6A3659F5ED86CABD9DB35773F3AB9B0DC68BE5BC9D732F771D1EFBE7A1C9DCE8FCDD4C00000413000001AAD6E3DBEBB62AF6F2B9B7D8D7AC346DAEC5AADEE45676DB2ABED36BE55F6BB4AED8B1F59BBAE6FABDF2B5D7FE763AF587172EA99FBC0000008260000035BACF95AABF1CDD8E93E763D0EFB418BB86A76D9DA3F958F41F1B34743F2B2E837FE55FEF9F9D5FF006C955CD965EAFE768ABE5EE3EA00000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000209800000000000000000000000210980000000000000000000000021FFFC4003310000103020307030305010003010000000400020301051215320610111416206013354030333421223136504223244146FFDA00080101000105026B5B830B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616AC2D585AB0B5616A735B81BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3C89DA1BA3FDAA578FF0090ED0DD1FEA3CA822525E818D49B4705149B473D53EF27CB5CBAE84C30945DBA50AF9013FE3BB43747F9CF26089497A063526D1C14526D1CF5525E8E913C99E5EC0ACE49683B60C151121C05B0DB0CD020EE848350EEA319FE2BB43747F90F260894979063526D1C14526D24F5525E8E913CA9E5FA025BC836A1594717B8CB60C6D0CB4121A0AF938C8538731BFE13B43747F8524F0C2A4BC831A9368C7A2936927AA92F47489E5112FD41C598A785608A254A51B4DD2CD1C0C75EC56A1CC80B6EF36CA3948808AB7C816D03D8A0222259FE03B43747F8372BCB0552CAF9E4FAD1C4F99E16CF28A28E166FAD78504879F9248992C65C325A6E22114285DF56D1D436C114A9CD2EDB385B40D7263DB237E73B43747CF7BDB1B6E57C74BF5E94ABAA15865990E240233B49A55C25B1D475B56D2D69EAD8DB5A5ABB658A39D86ECF28882EDD3057D8275FCFCD7686E8F9C59908711F7398E77D60ACC41683B70E153E87096D72D2EA0D5B51E7BD5C238DB147DE489016C36C334284B9140B82BB8C67CC7686E8F9B71BBC41D27225265FAA1DB4836A1598713EA5618AB5FA665B473686D9C911057B205425C0735BF25DA1BA3E5D6B46D2E57DE2BF9AFD41849CB7856186154A5294F85C571A2E345C68B8D162A2C5458A88DB40A522422007857F9234393094CF8EED0DD1F289262122B85D653ABF59B2C8CA5A23A9A565102CA075938EB271D6503AC9C65938CB271964E2AC9C459388B271164E22C98359306B270D64C1AC98359306B270964C12C98259384B270964E0AC9C159382AE76C942AE2E2A3B38358A2B60903FE3BB43747C9B85D220A85133152FC0D9CFCFEC2E3E62EB940EB281D6503A9ACCC73319235C3E8490D0BBC6503ACA075940EA7B351CC0A49E3BB6F37F0543F67E43B43747C9F4A3A57683DCBE06CE7E7F61749E3B8F3E52E7CA5CF94A538EC0DB75C2637E84BCC0F73E7CA5CF94B9F294C75C2AC0EDE7665BCCFC150FD9F90ED0DD1F2B683DCBE06CE7E7A9AE020F266E02CDC059B80B370166E02CDC059B80B370166E02CDC059B80B370166E02CDC059B80B370166E02CDC059B80B370166E02CDC059B80B370166E029E564D6D50FD9F90ED0DD1F2B683DCBE06CE7E7A8C88C46E7E22CFC459F88B3F1167E22CFC459F88B3F1167E22CFC459F88B3F1167E22CFC459F88B3F1167E22CFC459F88B3F1167E22CFC459F88A97E16B5BCCDEB4E07F5C50FD9F90ED0DD1F5A59590C79986A95E3494D1E07C53473B6530781ECB888F739D4637330D31EC91BBB683DCBE06CE7E7A01AC7BB961172C22E5845CB08B961172C22E5845CB08B961172C22E5845CB08B961172C22E5845CB08B961172C22E5845CB08B961172C22E5844D84663B68EB4A9407F5C50FD9DD53476CC9D70158FA568EA4C4C23A848888A4D3C63B629593C7F59DA1BA3EB5DBDBA8656B54CF5019C69A09DAED36AF6C2FF083A53916B6835D776D07B97C0D9CFCF5189CEC7D36BA6D74DAE9B5D36BA6D74DAE9B5D36BA6D74DAE9B5D36BA6D74DAE9B5D36BA6D74DAE9B5D36BA6D74DA8F671B47DF05845200FEB8A1FB3BAE1FCBE95AB0521830968ABB9791DCB5CA9363BC2B57B7FD67686E8FAD7085F387EB9C9BC6ADABCD8DE2412365AFF000042F802219590685C74500E3C949B76D07B97C0D9CFCF54224161CF0F59E1EB3C3D6787ACF0F59E1EB3C3D6787ACF0F59E1EB373B866E65556F770A573C3D6787ACF0F59E1EB3C3D6787ACF0F59E1EB3C3D6787A65E2E523EF5CCD6703FAE287ECEE2E17CDB9D21C851F96866790C7430CCF25010BC713EB3B43747CADA0F72F81B39F9E839E31D66E02CDC059B80B370166E02CDC059B80B370166E02A5D42757350B852EA0B966A170CDC059B80B370166E02CDC059B80B370166E02CDC059B80B37015F0A84A200FEB8A1FB3F21DA1BA3E56D07B976D1B4E15A70AFD1D9CFCF438B198DE9E0D74F06BA7835D3C1AE9E0D74F06BA7835D3E12E9E0D36C4232B910946D2C6271C884AD3A7835D3C1AE9E0D74F06BA7835D3C1AE9E0D74F06BA7835D3C1A6584263F689AD61207F5C50FD9F90ED0DD1F2B683DCBB303B87FC49F7155B5A6EA36B555A569BF03AAB8705B39F9E9AC25F172B7B5CADF17297C5CA5F17297C5CADED72B7B5CB5E78F2B7C5CA5ED507BDD1546BDB97297B5CADED72B7B5CADF17297C5CA5F172B7B5CADED7297C5CA5F17297C518779ABEF703E09C0FEB8A1FB3F21DA1BA3E56D07B96FD0A9FB6BFF000FFB9FAB6B5FD18CA517EE72E2E655F4C2EA7ED6F075571AD16CF530DC1444D036F50C38B3F855368A1C3D4902EA282ADCFE1E1D45071CFE1C59F8EABB43051750C355D430529D43061CFE15D430D1D9F42A9B430F0A6D1C35AF50435AD6FF000529D430E1EA48175240A9B450BAB7B9DD3CE07F5C50FD9F90ED0DD1F049E6D71BB2E3765C6ECB8DD971BB2E3765C6ECB8DD919693CD9FA74C5D3A62A6CF174AE445E2E9E316425E1AD80BC79117C7A74C59017E9E445626D84BA2E9E31642562AECF98EAE405E012DA787371B9A8C6B8B17A2662A4072F40D5E81CBD03787A06AF40E5E899C7D0397A062F40D5E81ABD03787A0771F44DE3E81CBD0317A06AF40CE1E81BC7D0397A072F40E4D8AE0CA9D6CB81F24225CA107A78C4DCD5ADE3765C6ECB8DD971BB2E3765C6ECB8DD971BB21B9BF80ED0DD1FE0FFF003B78F653753F85FF003BE9DB554DD4DDFF002ABBE8B8A6D7E73B43747CFE1BF86FE0B82E1BB82E1BB86EE1BB82E0B86FE0B87670DDC170FD386EE0B86EC2A94E1F39DA1BA3C89DA1BA37D78E176D016C7DACEA9E2EEBA9D5006A6D193C58EA48CDD73BCC821769B8907BFB6ED73A80DEA329432B6787B6EA64808DD4452EA22975194A1DA4FD462E02D9D977B848033A88A5D4452EA22975114AD37398F977972D6013A88A43495986DD732DE106DDA12AAEED24B84464FB46EE35BF1D551ED098DA897D1C8AF6DDEE5280E02F44146EF3EF440A6DA2E329FDA75DC70AB26D096EAE7A7A8B68E6A20AE439DD933EB1C1D4452EA22975114BA88A4CDA129D2763B4374765F07F42E3B3D3FA666EDA023D5395888F5ADC9CEA3193CB59C8B20FE85BBB3F85712B9B39F13E3A6CE958A2EDDA2F6F899EA4BD34C55D9A6A36CE404D1C89059869DA50DBF697ED0B0F30574D46BA6A35D351AB7DA9B6F937DCBDB503F81BAFFED91FDCEC3CD60234E4484CA15A08328DD9B8784FB38EA525864824B35D5D13FB3697EE59BDD77DE7DD766BF9DF752EA183FB9EE1B6778B2BB3A2702367256D2C40BC68B795F8883B130913A6A35D351A6ECE31AFEC7686E8ECDA11FD40C796B010D751ED91F48A39A4ACD31C0D44836788F4CD57C23D1B70F156721ADA319D97A2B9600682A4937B0A8EB78445442DAEA39BD9B45EDE37E56E7368F6CECF4E7D9D756A06FDA5FB56CF73EFB97B6A07F0375FFDB23FB9D97B26B3DC2CE0D0C2A94E14DD7401A68AAD24F356FDFB4BF72CDEEBBEF3EEBB35FCEFDA3A57931A4A42543346447DC57E22B4FB5F7BB4374761115271DCDAB1D649FD7B6DF88F4ADE041CC9D791FD7B6C12D609D8EA3D9B4247A866CF0FEA19DB792B993F6745FD5CDA3D858F514AB095EB07D9B45EDE37E56E30C8C381EEABDF6186B15B77ED2FDA8E474326727ACE4F59C9E8291D285BEE5EDA9974363666E7ACDCF53DC0A2638FEE764F5C446CEB29403B0F65233F66EBFF00AFBF697EE59BDD77DE7DD766BF9DE50CC2C73009C29239A485D0DF4D890FB450BD47232566F2BF1145743218B393D6727AB19A416EEC7686E8EDBD8FE85C76767C05DFC8F54FD9C1FF0075694734986A395662A8FB54F2D6722C63FA36EECB995CA0284BC0028BD4012BB9631B25ACAE50EECDA2F6FA56AD766C72CD4EAA7C8F95D6DB3CA53E94A35BBF697ED0513673721056420AC8415146D862DF72F6D42D903945C80159002AEB6A1830A3FB9D8647E919B39352B06FAD68D69127AC4ECE47843DFB4B4FDD67AE1BAEFBBD715D766A9DB5A51D49ACC14CA6D9B44893092598D70C5EF2BF1101670C80721056420A100802ED7686E8EDDA11F1883CD51C891F5965B60FCB5BD6D10F80980B74038F156721ADA319D97F2BD62C30273964072C80E5901C9EDAC6FB395CD01BF68BDBE16D1F3E460296C41BA29237C32D9EE1CE0FD9B4BF6AD9EE7DF72F6D40FE06EBFF00B647F73B36803AD2410A7864886C26C6BF8A5E2EED7B2289D34A28F4145DF7F82B2831C958A510B8CC81165C61C12495965B0C158ADFBCA25820E319016CDDB44F8F9411B5799BCAFC4569F6BEF7686E8ED221A10339B56BADC3F327EEBD0FEBDB56CF0FEA19D8591414573AAF7DA05E540DF7F17D22EC8572E76FDA2F6F1BF2B75F6DFEB46290F10818861506FDA5FB4C7BA27E6A72CD4E59A9CACE7153DC77DCBDB503F81BAFFED91FDCEC9236CB1DC2CD28AE6BDD1B9B773DB498D248A403CA4C96BB53416F639B47B6E56B9029229A481D9C1FC259A49DD6CB548648D6D1ADDF7E1C9221A55F1BA3BC1D1D1D7C3DD47C924CFB2DADF1BF795F88A3B8971479A9CB353966A7282B570FBDDA1BA3BA4B3852C835B85124DD5A51D4C8C04309086CEC24588B8E9650295EC24584B8F240695DE48B1171B6CA0B1DBEB6502B51838436EF28380CA64602C8C059180B23010F6B105977CB1B668B230146C6C51EE20688A8A9640295EE9ED81915AECF06A3B082CAC70C70B7BAB4E349ACC14D5E9D1143660A1AFF0014ED9C31C94ED9F09CA9B3C1D10F6E145ED7368F664602C8C059180B2301646026B68C6EF7686E8F227686E8F227686E8F9054DCB8B1917192384D7F32B9AAE648426A4A73A8D6B0C309A0D34F255084D49AA0AE6D2889E4F4471A5F5C6265F4058C8B8C918EE29D5AD7851869655069887B934D249A8F312E93734D28943CC43DF2D5F48C834F1991487D64521EE74CE30D1E914AC9E27570B2032E044311CFE6139D46340B8738F4F7B63634D2C9509447AE8A2E78CCF56E6998B07C87686E8F9172F6D18B25A2B257CD765FFE815A948CA4B142E3408853622F75AF52184E646E6F9AB5DBBDBAE3EDA31653451E492563DB47B21E76DD18C744556BFAD216996D68C7C44BD569C690D0CB6B063E225CAF3F88A7755835A58D65B55B3FF1CF2FD9B513032D854CC34C573756447B395AD2B4AD2EFF00BA3A53852421914A8C91F1DEA8617C7E4BB43747C8B836AEB70F7064634AE92E33A3629632AB74C4DB78CE18692AFA474B9E14336422E4ADAC736AAD4C7323BA072568052ADB79F4ABADE3DC5910C398D25CFC582973C0A0A4855CABC7852E4E8D478CDB92771C34B9558A2A3CBB9ABB31CF15569C691FAF6BABAE4F96808BCAC127DAB6850E5F1C75B79CA21287935B4075A5B2B2360305A16332E13414C521C7231F582EF9A46A37FA91FC87686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686E8F227686B9B83135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626AC4D589AB135626A739B83FFFC400421000010301030709040A020202030000000100020311123271041021313491921320223341516061722330405214425073818293A1A2B12462354305C15383D1FFDA0008010100063F021D11A95D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE85742BA15D0AE847A235218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861F6DE8FB20E0861F6AF4E6637172EBAD7A42F670BDD8E85D0858DC74AA0969E4D08CAF73BD2E76928805CD3DAC720D97D949E7ABEC7382187D9FD3998DC5CBAEB5E90BD9C2F763A17B3858DC74AEBACFA42E9CCF762EE60753938FE672E836D3FE776BCD666603E7DA117C1ED59DDDAACD6D33E472A075893E577D8A70430FB27A7331B8B975D6BD2174217BB1D0BD9C2C6E3A575D67D2174E67BB177B8F66CE8FCC7520E7FB593BCEAE774DB65FF003B75AB405B8FE66A0D97DAC7E7AC2AC4FD3F29D7F619C10C3EC3F692B19895D75AF485D089EEC742F670B1B8E95D6D9F485D399EEC5DEF2CC2C2E283F293CA3BE5EC5468A0CF6E5786B7CD5692D9F9AC68558640EF2E61733D949DE352B4E04773DA8332A16C7CE35AB70BC387D8270430FB08C50D1F37ECD46491C5CE3DA7DFD88DA5CEEE083F2B3F91AAC46C0D6F70E6127505F4DCA055B5F62C3A80EF4637B4169EC5EC9C40BCC3E4A3987D61CCA385479A2FC98F26EF97B17D689FDFDE8332B164FCE10731C1CD3DA3E3CE0861F60173C80D1AC9462C97A2CED7F69F7F402A507E5079367776AB30B037CFBF9D301ACB0AC9ECFC94CD00EDA14CAF69279D62560737B8A2FC90FE472A02E61ED694193FB27FECB47C69C10C3E3EDCAEC07695A7A31F6307BF0E70E4E3EF72F66CABFE73AFDCBCB5864C91E6B46EB6155FA434629D2D92D8355A3DC9B1B051AD141EE2CCCC0EF3ED08BF27F6ACEEED5641AB7B58E566BC9C9F2BBE30E0861F1C58CE9CDDDDC8C92BAD38FBEE8368CF9CEA41C472927CCEF79531B2B87BCE9B68FF009C6B569A3948FE66A0D93DAC7DC75AF64FE97CA75FC51C10C3E32A4D00461C90E8ED93FF00C553EF6CC2C2EF3EC083F28F6AFEEEC540283E135AD6B5AD6B585AC2D6117369149DE154EAEC7B4A0CCA4728DF9BB55B85E1C3E20E0861F17CA4AEA0FED591D087E5EFC7DFD1B2380F229D1CB2CB40DAE87AEB27FD42AFCFFA855F9BF50ABF37EA157A6FD42B5CDFA856B9BF50AD737EA15FF6FEA15FF67EA15FF67EA15FF67EA15AA4FD42B549C656A938CABAFE32AE3F8CAB8EE32AE3B8CAB8EE32BAB77195D5BB8CAEACF195D51E22BAA3C45754788AEABF915CA33A70F7F76661306923BCAB714765DDE1C7E20E0861F1566FCDD8D0ADCC4D7B0777C0BFEEF9B0C0E7BC47C99751AEA6957E7FD42AFCFF00A855F9FF0050AF65944CC779BEA844E99F698FA5EF732C723E4B2D8C101AEA2BF3FEA157E7FD42AFCFFA857B0CA6663BCDD55144E95FA24B27A5CC9FD07333D23E24E0861F155B0DAE0BF20F817FDDF362CA6380CAD0C2D21A57FC74BC417FC74BC417FC74BC417B2FFC73C3BFD8A12C909A97D493EE5F3B32674CC7C61BD12BFE3A5E20BFE3A5E20BFE3A5E20BD8FFE3DC1DDEE2A39A585C3A769CE3CC9FEECE667A47C49C10C3E2FF20F817FDDE6B124CD0EEE5B40DC56D03715B40DC56D03715B40DC56D03715B40DC56D03715B40DC56D03715B40DC56D03715B40DC56D03715B40DC56D03715B40DC56D03715B40DC56D03715B40DC56D03715B40DC56D03715B40DC54D246EB4D319A1CCCF48F89382187C5FE41F02FFBBCD974F2476FFC8A2D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82D99DB82A0C95E4E01467E8EF87A3A9C35A77A1F999E91F1270430F7E6491D65A3B575E371550ACC9280EEE56A27870F256249035C835B3024EA45CE3403495D7B55A63839BDE33FE41F02FF00BBCD9689034B7973AD7550F085D543C217550F085D543C217550F085D543C217550F085D543C217550F085D543C217550F085D543C217550F085D543C217550F085D543C217550F085D543C217550F085D543C217550F085D543C217550F08569B1C40F7801434F913BD0FCCCF48CFC8993DA5694A662D330A8D7E4AA0D421CABC36BA82AC4F0EA6B41D2BAC828491BAD34F6FBF382187BF7E2DFED53E879470E69CBF27748C91F6B9466928BA1A6BE968A1AA2A1C3FF6A7F41507DD84191E864CC25CDF31DB9FF20F817FDDE6CBA1B763FC8AD56D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D47856D478502FCA1CE6F7014513616D905BDE9DE87E667A467C97EFDA9C06BA26E4F2C32091BA0B432B6948C70A5890803B93E6958E31BD8035E056CA85F1B1CD8DEC2D248A5ACCDC5DFDFBF382187BF7323157547F6B636FEAA16850F7223918E56D7410EB2A69E6B21F2D3A2DECA22A389F786B52B1BADCD202647F446745B4AF2A9D94650E06522803753467FC83E05FF00779B2E92265B77D2352D947095B28E12B651C256CA384AD947095B28E12B651C256CA384AD947095B28E12BA50347E52B442384AA7D15BC256CA384AD947095B28E12B651C256CA384AD947095B28E12B651C256CA384AD94709418DC90127FD4A8BE92230EB3A2C277A1F999E919E0B1F5250E38662D6E4F1F938C9A158ADA71369CEEF28725089076F4E8BE9394590E02CB18DFAB99B1BEF54FF007EFCE0861F17F907C0BFEEF365D24AEB2DFA41D2B681B96D0372DA06E5B40DCB681B96D0372DA06E5B40DCB681B9689C2B5CB8A2A09C2AF2E34792DA06E5B40DCB681B96D0372DA06E5B40DCB681B96D0372DA06E5B40DCB681B944E85F6806A77A1F999E91F1270430F8BFC839C093AD53DD3FEEF365D1495B3F48AE85AE4DEB5C9BD6B937AD726F5AE4DEB5C9BD6B937ABD2712D726F5A0C9A7CD59AC94C50D3268F344564D27BD6B937AD726F5AE4DEB5C9BD6B937AD726F5AE4DEB5C9BD6B937AD726F41D47BA9D84A8434002C76277A1F999E91F1270430F8BFC839B5A28D1CDA466D016919F515A53FEEF365C32575993E91AD6D1FCD6D1FC96D1FCD6D1FCD6D1FCD6D1FCD6D1FCD3BDBE8ECE92DA3F92DA3F9AD3303F9975E3896D1FCD6D1FCD6D1FCD6D1FC96D1FCD6D1FCD6D1FCD6D1FCD6D1FCD6D1FCD6D1FCD00FCAECB7B4DAAA8C3E77CB56EB7277A1F999E91F1270430F8BFC8399417955CFAF928D1561BAFB5116AA5171D4156B642A1355456BB7B155CFA2B2FD21483FD336592BC5AF6FAAAA9C8495FC16889F5C55AE4645D44889E45EAA6278C4AA724F288E45FA3CD756EDEBAB7EF44F2326840F2326956B917AD313FF0012A9C84955D53ABEA44F23268541048A821937AAF24FDEAD722F5D448BA89151B93CA49519740F8A8DD4F4EF43F333D23E24E0861F04DFA308BCEDABB92EF2AEE4BBCABB92EF2AEE4BBCABB92EF2AEE4BBCABB92EF2AEE4BBCAE564E401A53412AF45BD5E8B7A1D28B7A71B51F96957A2DE9BD28F479AB56A3A57BD3CDA8F4F9ABD16F54B51EBEF474C7A356955B519762AF45BD37A51D00EF55B516F566D45BD7291F224D9A748943A39379E92A6E864CE123ED7490F6191EE43FC7C8B723FE3E45B96CD90EE5B3E455AF72D193E45B96CF90EE4EFF001F23DCB66C8772D193E47F8847FC7C8B721FE3E45B90FF001F22DC8FF8F90EE43FC7C8B72D9F22DC9DFE3E45B969C9F22DCBA8C8B5F72D393E454C16CF90EE5B3643B96CD90EE556C19103E554D7C9C802D14D04A3928193D9208D24D55E8B7A0DB392E8F32AEE4BBCABB92EF2AEE4BBCABB92EF2AEE4BBCABB92EF2AEE4BBCABB92EF29DF49110EEB1F0070430FB03B7DF843DF9FB10E0861F6076780CE0861E2338218730D35A2D31C55069A917B800F06840CE1EC00BDC68015A638E89AF1A9C2B9F9189AC341A6AA4E51AC0C68ECEFE730461A64777F72EAE24C95BA9C2BCE12461A497534AEAE2DCBAB8B72EAE25EDA0FC5A55A85F5EF1DDCD88C61A6D1ED5D5C5B975716E5D5C5B975716E523646B0068AE8E64B2B75B5B5D2BAB8B728A476B7341CFCAC60135034A03938B5F3ADCCFB3FFB54C9E114EF7ABED1F9574C31E3041B27B27F9EAE744236B4DAAEB51C2F6461AEEEE6490B19196B7BD4BCA35A2CD35736C75927CA3B1741AC60C2ABAC6F0AF6B131C3CB42F664878D6D3CC91E35B5A4AEAE2DCBAB8B72EAE2DCBAB8B726B7938B49E69C10C39AE22EC9D24E84EA907EF9C4435463F7CC1A75C66CE62E3A80AA9253F58D5349BD274B9CF93EAEA6E0985C281E2A13F2671D2DE9370E737D698CF98D16D278568CA4F0AB7A1F1FCCDEC42588D08FDD3266EA70E664F8951C24D2D9A556D2EE15B4BB856D2EE14F7894BED0A6AE6651E839B27FBB19CFAC26E3CD321D2ED4D1DE51925755C55BB91FCCE5D29DE4F9055826B5E4E08C72B4B5C3B0A1934EEAC674349FABCDC9F02A1FC7FAE64DF87F4B28FC398E7B6F9E8B577B8A0ECA6420FCAD5A1F28FC5560943FC9DA14924ADB3238D287BB9937A0E68E633B85A15A516D2EE15B4BB85077D21DA0D6EF34E0861CD6CC35C67F651CA3EA9AA0E1A8E94E7BB534553E476B71AAC99FFF00C8CE9629D11D520FDF339A2F49D151C43EB1A20D1A80A734B41E9C9D10A385BF58A6BA31D47F4A398761D3820E1A8F35BEB517AC672D70A82A467CAE2139BF2BF9993E2564FEBF71947A0E6C9FEEC673EB09B8F35CCAF463E885578F671E93E6A8339A0F6ADD2D3998E378744F3327C0A87F1FEB9937E1FD2CA3F0E6447B03D4521150D70283E278734F773E6F41CD93FA7DC1C10C39B2447EB0A22D3AC684D1DB1F4572635C868A28BB2BA704FA0D31F48264A35B4D5070D44553611AA31FBA74C75463F7E73803D08FA213F2A70FF56A2D76A3A0A9213F54AE45C7A517F5CD6FAD45EB19CC921D3D83BD39C75935409FAE6D73327C4A6C8C34737482BAFF00D82EBFF60BAFFD8285EF35739A09E6651E839831B390D028342DA0EE0B683B82E4E594B9BDC9B8F36427B5C539DDA5FCD9DA35079538FF0061CCC9F02A1FC7FAE64DF87F4B28FC398E85FA8FECA9237A3D8E1A8AAC6F730F915D273641FEC15278CC7E634841F1B839A7B47326F41CCD8E39A8D6EA145D7FEC175FFB05372D25AB34A68E69C10C39CE22EC9D24F84EA78D18AE4C6A8C53F152E507D21169D454911FAAEA2E91EA741C14929D6E354D71D7274B9AF7FD63A1B8E68E11CA74469E8AFF00B38532582D5AA51D5098F370F45DCD6FAD070D616D2F5B4BD5A7B8B8F9941F334B21F3ED41A0500E664F8950C4FBAE750AB8FE2571FC4AE3F8936365D68A0E6651E839A291C1F69CD04F496A93896A938972B15AB5680D25371E6CCC3D8F2A587B41B5CC2E3A82924F99C4A91FF33F99939C5418F327C565070E6D08A85D5583DECD0BD84FF83C2B133287B3CD36327D9486847326F41CD14AF6BAD3869E92B8FE2571FC49DC8822D6BA9E69C10C39CD986B8CFECA3986B69AA74875B8D544CEDA54E664E353C50E2A7886A94514710FAC688346A029CD10B4F462FED3B9103A3AEA56A8F896A8F896A8F8916385083429B53D36744F31BEB51B4EA2E01754788A708DA5AFA68354E8DE28E69561E7DB335F9F3727C4AC9FD7EE328F41CD93FDD8CE7D61371E68CADA341D0E4D999D9AC77AB513B4F6B7B466D28E4D93BAB5BEE09B1B055CE340A3847D51CC120D719AFE09B2375B4D50923388EECC6490E03BD3A476B71AAB675C86BCC74CFD415A86407CBB73B187ACB550A168D76C7326F41CD93FA7DC1C10C39D2447EB0A22D3AC685147D95A9C33BE9799D2199D31D518FDF9B24C7EA8D08B9DA493529808E9BFA4EE60980E8CBFDA0C27A12F44F31BEB517AC67FA4C63A6DBDE6136666B1FBA6CB1EA773327C4A0F61A386A2B697ADA5EB697A6B2599CE6D0E83CCCA3D07364FF76339F584DC79A58F1569D6117C40C90FEE15A638B4F7854FA43BF1549667B87755588985C55B7F4A63DBDDCD2D70A83A0A2E682E84EA3DCAD44F730F9154FA41DC15A95EE79F3283DE0B601ACF7A0D02807319C8B6D31BA5C06B5A096B82A72E4FA85553950306AB4F717B8F7AFA54EDA1FA8D3CC9BD07306327735A3505B4BD6D2F5B4BD464EB2D1CC3821873DD23A2E938D4E945F0B28EA535E720EA2BAA3C4516C2DB209A9E6D89812DAD75A0792FE479B6266DA6D6AABC91E23CCB1336ADAD75A0E111A8D378F309E4BF922D84100F65798D1336D59D5A5754788AEA8F115D51E22BAA3C4509628E8E1E7CC746FD2D70A15D51E229AC6DD68A0CFC9CA2ADD6ABC91E23CFABE115EF1A15E947E2B4B5CFF539598D8D68F21CFA155E4AC9FF0043457A5DEAA22B47FDF4AD1CEF6B0B5DE6B45B6E0E5A4C87F1558A115EF3A4F34B5DA88A15D51E22BAA3C45754788AEA8F115D51E228346A029CC38218788CE0861E23382187C4C92815B0DAD135EDC9E1A38547B44326CA61E4A422ADA1A8766FA2D9D1C9DBAE69AADA72721622E3A82E5326C999C976191D4AA7367C9F9323B41A839A6AB69C9C8599A581C2C3DA4D3CC2924A56CB4951CA452DB6B4524A056C36B44D7B726868E151ED13BE911319DD65D5553A95BC97276F25D8E91D4AA7327C9F9323B41A8399C72481A630696E4752A8B328C9EC68ADA6BAA339764993B4C55A07C8EA551665193F2741783AA0A718C073FB0141F264D0D09B3A1E9A258226B3B487E67439243CB3DB78D68D6AB794648D31F6989D5A26C91BAAD76A44F704D963C9A1B2ED557A6C19543C93DD74D6A1D98B9DA86929ED747C99BCDF36E62F79A346B2AD64B928E4FB1F2BA95421CA7262C2ED4F61AB734793C1131EE736D748D16CD07EA216C51D4D3F1270430F89CA3D05440640F70B034DB1A544ECAE33059079269FAC71CDFF00D1FF00BCD95FDFB93A33A9C28842EC9F9789BA03A33A6982706543DB798E14233659F7EECD3BA336678F28718DCB28B42CCCC611233B8AC9FD01651E82A203207B8060D36C6944C90988D751354E69D4451084C1F4889B75CC3A69822D6DA6C8DD6C78A1545C9361FA4400F44B4D1C118E8E64A35B1E287311DEB91107D221174B4F49160B4C906B63C50E68FEF5B9A470D61A4A888D6E1689F3CD96C2DEAD92F47C93FD2A16BA68C1035172C9A2C9CDBE4DF6DEE1A80CD1644C3D29CE9F26F6A832B8C6887A2E1FE8AA351593C46E49300E541A9451BAB6A5346E681D1C46577247A20D17FC7BF8C7C51C10C3E2670D15258742898E8728AB5A01F64540238246471BED97C8299A3CB6067285A2CBD9DE1521C9728749DC5945493AC712F7E29C6300BE9A01549F259D8FEE0CAA7658627451D8B02D6B766CAED348ACE48AE69ED348ACCE3A53B29C9BACB365EDF9C28011421814E1A2A4B0A898E8328AB5A01F668B5B1CADA7CECA236055D4D0A99464B3B1FE4DB417D2F927451B59645AD6E5A35AB394E4B331FF00EADB414794885D1C5134E978A17663675F62A65392CCC7FF00AB6D04CCAB91745146D2017E82ECD186B49F6ADD59A8518F9274D92D6AD2CD6D56725C96573CF6BDB6405473AD48E369EEEF29F828B95C9D96E9A6D374AB2C613934E7B05C7669B29CA58EB35B118D5A152C3B8CA764F2836A13641EF1D88C75A1D6D3DC558CB32696D0FAF18A872C9A4641232288925D268AE686631C8E608C8E836ABA8CA7F4935E0115EFF8938218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E2338218788CE0861E233821D21A95E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF05782BC15E0AF047A4352FFC4002B10000102040404070101000000000000000100112131A1F1415161F0102071D140608191B1C1E13050FFDA0008010100013F21D32305685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685685AE460A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A57FB600720469FE456952BFD5A570B32354AAA9023BF5A228E42F90613E8CCC1FEC21B6461207D14099B347D0A0410E25FE356952BFCFA750B32354AAB90255C853223442AF51C8E239C09F40820E6B13D1970D3C597A053913ECBE98A8B6198E0F4C90D1EF0BD33FF16B4A95FE4D2280B363221557A04A890A64C68855AE3F84BB6386099D33830741CC5072581EACD1D2D28E575182893166F68A6D338A007A7F875A54AFF0E9B1859B5910AF85F238756229935A21563853FE799E8380EA530064A5EE87C404800C0713F1362481BDF960FA1A3627211E9C8CCDDC18BA843C060C7C3DF05433475CD06E879975FF0006B4A95FE164C513B22A6D32FEE0A17A40744303D6F9282C2D2037208E980E4A7A79109259332814D989082163EB8190A046D188C8E3C86E216040382990B353F64EE2D2412FA15D104E1EA149EC0471E3EB4A95FE000AA390C0271C64C8E8E43FB8C9C4900269D8BDEFB268531C5D479A58723D912A401EA13E193F31E8EB2B61D1F98A48D808822233BE0A3A0998781F450519A4C7EB8204002408388F1B5A54AF1E54DB2682699B26321EB99FEF164F0A27A041BA8452EDFC4B8BD207C54325E88E703EC825766024396A986000D3F8688A7C029D41F63EE9D442727F8983AAD3E871F195A54AF1CDA7EDFAFB2203CC61D3FB061CF20FE9408BC080E83FA3BEB3117400018061FCCB0E5907F48A96960447509C1318B07429C80CD083C556952BC61C8C0392704486A4CCDB144921092664FF005D504F9053A81EC7DD01000901FD5C2709C271984E3309C6613330B49EEB49EEB49EEB49EEAECAECAEC9CC13D33D421D963877E2772C9CBDD66929A63A8F115A54AF165818E431D011EBC03013FDCD18B14230B353822E387CF73D2CB7CD71C6A720A528FEC2AB657DAD95F686E6F95B4BED6D6FB5B5BED6E9FB5B43ED6D0FB5BD3ED6D2FB5BABED6EAFB5ADDDAA210BA7047AFBA260CC10B21049E97542048B60FE22B4A95E28BC2208A97544A78B400683C0D4BE472CE9A653390A28A6D61724040888122098C7F88C28FAE22790A28A87879E051B90B4B883163C9B3E5C36CCBC4D6952BC5022232892D72A10DD3F0352F91CA34D9401049D790C30C2C86710903D9025C26E027FC5AEA0301883C86186300DB065BD13651100EBC9BAE4786D99789AD2A578B97BA7E06A5F238140EE7116F65B93E96E4FA5B93E96E4FA5B93E96E4FA5B93E96E4FA5B93E96E4FA5B93E96E4FA5B93E96E4FA5B93E96E4FA5B93E96E4FA5B93E96E4FA5B93E96E4FA5B93E96E4FA5BB3E90B9334E8786D99789AD2A578B97BA7E06A5F23837180A101EBE23CF3CF3CF3CF3CF3CF3CF3CF3CF3CF3CF3C0F2C400111189B16B2134D6D9AF0DB32F135A54AFEE1C5344B6A7D200C8E0870B1A40D7268A3FBD9CA4A1A61D88289AE5980C4A62E3732081E30B36286CF922B8E32F74FC0D4BE470937542E3C410410410410410410410410410410410410241390029E003A3AADB35E1B665C454105369F07B346602475192191881C118A8E93584FA225142664C7509D82181627E10E94907F7AD2A57F7262B12D0874A0060E59C8C2BC08C0C08580702270453F2101A82012304024E2F92DCF2288700FC506D6A5906BEDC65EE9F81A97C8E1138E380F25B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB5B5FB40E62710F5751108988C5F55B66BC36CCB8EEDAA222C4401C90A293B5CCC1917589FF00D76CDBD1D392A13784C1693AC355533176D386ED9FFBD6952BFB82F148012D202AC5EC88D3988B9D8A8F2A46C06A0A0705229C004238942E2D101D006602F8AA9050427C6113C180E8BDB29E8E38CBDD3F0352F91C07B8261C09F8FE6BAEBAEBAEBAEBAE02EE848C753AA9C4FE66BAEBAEBAEBAEBAF2D9540FB4662508CC9F175B66BC36CCB89C604CE703F0388B17692336674D24F0CD1329F0F899D05470AC93803324E278041000A58BCC8FF7AD2A578B97BA7E06A5F238170630395EDD95EDD95EDD95EDD95EDD95EDD95EDD95EDD95EDD9468C0D0A0532F4C512613D0A9C4731895EDD95EDD95EDD95EDD95EDD95EDD95EDD95EDD95EDD95EDD95EDD9081B692019BADB35E1B665E26B4A95E2E5EE9F33F907B064F6587F2A97C8E044C48A2B182B3FB2B3FB2B3FB2B3FB2B3FB2B3FB2B3FB28CD45D959FD9490F47B27828A797B228A1819B7B2CC823B8567F6567F6567F6567F6567F6567F6567F6567F6567F6567F6476742E5608F506C56D9AF0DB32F135A54AF172F74F9481C3646A1F95528024B00E54CC1C266153507100386BA2244C041D554BE4703B43990E68287BBE16B37E89CDDF4B73F0B67F0B7BF0863C38EC11303036C16B37E89D86CF641990706340ADECFA5AEDBA2DFFC2D66FD139BBE96E7E111EEFA5AEDBA2D9FC2DCFC2DCFC22F2C2207A221E5DC98ADB35E1B665E26B4A95E2E5EE9F245838E672D14538349146A1F955A9BD4323065D515D114370E0C59181C91241284935F004A43F2A4011C094E26F228A5303F90898A31A07800C315E8226935D06005D39491621C2BA052071A88A0707264A304C33B84FE6C390E11073B40080F2A6611955330899C6DD807081C0644E4A35080A3900F9003AEAE80E103381D42074834CB028A70D0537232599C2BA0574086E10000CE513F6C89862B6CD786D99789AD2A5782308A4E39A37F1A69A69A69A697B4CCC6DF0AE5ECAE5EC89058718FB2028BCBCDECAF5ECA13345E3CFA223DE4F65951168FB2B97B2388B118FB2648218017764E86573385112972F75F64E49463EC8A27B5F65124E38223EC9E19EFFE05B608A391FE60C98A0FD0F12E79201D0DC4413A81E922CD5F7D9458D11CD244A62E0265D916A3EF3B23872C5A259DEEFB22C4EEDC14173ED81282C7E2EE48B1663C48918307C4BB28CE00789624379B9D459062D120130702CC4832044F1314939001946A3E16009428AFBECAFBEC8345D88015004C3F328F5109A2BD7B201E6000FE2D34D34D34D34991C111CD5FC056952BC710E1B8465C0432E7BC781114DD50719FB208CD04E46E09DC9F45F5596F1533A9427E85F42CF78A24BA8AC4510E085F6A3AC3340454C7A29BDD1EFF002B175430F4E03F659B25A4FED4B3F644E9C53823E3AB4A95E3C875B99008870BD1C26BDDD53B2083110EBD2AF40329B04030E16832F423D0874FA712E5E9F6403221D00C8F420182D0CB017A381C8BA0201918A09878EAD2A5798EB4A95C9846083E6873C71074FDD1834E4BA71C11151D5314CA2C0F74725C40E878978489E2669AE5D11337AF31B62BB4A10381D8E87BA212E307304E95BD255F1DD5F1DD0FC23DD04806C6D314DBE2340F50E52774C0B7257C7757C7757C7757C77432C9069CF903D02700915F1DD06A00F40944713412B49628EF608091EEB0E56390C063D011C40334E7D8224E34C057A888CF842C89A4F72F5530E3943CB122D3827DA03902F2EBC8DB406205E5D517C1734E2FCA5110716A2ABAA154045DCEA28F818E8C640481038711C8C04401F40AF8EEAF8EEAF8EEAF8EE8C8600247BF2D6952B9587301BD714EA303D1B3C5C04BFAA27EB839677CE98703AEC711D14F44E8D3988FE985394900492C0230B301F48885DC73885B6441DEBCD43F82A22332EC9CAD8FBA6135AFED1A9B29FC808FE7D90645638A9B2388E4DAF20867910B024AC25612B094A0442C6E676F3972668E84B92326261BE52681078006F53A0417A38045E09699FD54E62C874C1CC9974E5D8F455FF27257FC0A97EFC84358BD02715AB37A9250CE26397EA89610CD9D9116999C888F30803936BCB815230812CAC256127B5312396B4A95CAD1313D5FACA6B63431EE100516E630BD14DA997AA29C177344DF04270583E8D9E0E618ACE98A9AD8D043B04034E58657B26254EA1BE8314CDD21003D2A491099E24465C4E0E639687F056DB9F10500988388401B201E8515D22B7B0E4DAF20A95FC9DBCE5C99A3A12E41A3066B8A3B7509CD8040000002000E2D08CF64A20E442217BFBE8E4D8F455FF27257FC0A97EFC870399F629D0CE8E8562C442E7DAF2E1B4D7F856952B964B67411EC52413A45CCFF00AA27A237B6CCA870E4FE944AFCD153A2946B42BEE301D1388C7F56C260981EAFC7E68F17E89F74F4B1FBA1CCE320D168521CC609F9C1986B879687F056DB9F1069835CD4D6D17AA006C4FE890F8E4DAF209FA4B4056BF768B5FBB45AFDDA272E28CCF33993521900B767D2DD9F4A256DDC02A3A12E42CEC55501F36FE8072E01C5EE8E7020D4FCE4D8F455FF0027257FC0A97EFC920D679B02880D2E8246B4E1A4C83D407B8468196E315218011C726D79702E41998C16BF768B5FBB44246A1201A7CB5A54AE669CC06FDD53B29BE87E2899F38894F02977CFD2180E0621630D7A304F88CEE8A228A782D18C319FD30E567CB0BD62772E56732188E3C12158C96E304FE1BD90F2D0FE0A3A2C470722B6811098FA0C9E8FE2F1411822643A421A20980180E4DAF20854923305A0AF957CABE504E222838733A0BAB1888E3189E833C2A8E84B9097D44729970D0DB90E0B01C95BFF000A215D2F41C84CA30FC2090712143C832060028119B0A1F9E53D1893043A7B25CE27C248CC4B9B1109EC0D34C74145BA5C4C0E07936BCB810D9E9020AF957CA2E70ECC4B96B4A95CCD7244F57EB297CB666A3EA797AA70431FAB31E0C328C7E2953B2D23D9D4D446835D8601A72C9128F5CD167A0D734392318BB6181AA9E2FC73EDC943F82845B9C747E0D1CEA9B9628CC1B88429396D0CF976BC82A57F276F3972668E84B925AADBC0E054644C190C9028A711C0241090004C94D5EC124D90503320A542C1399C4F20C9776EA81FA46D2103D10AE971AE791E00BA186B1E411A4730BD53696F6790E47D9386264A00CC385D47118B024D7101A2A60267DF936BCB86D35FE15A54AE69411D00EB15C13D81FDB51E2E507A34E9C184607AB67974B9199C11F68B1995010A97E724BD88F4CD43CBDC30DEBC943F82B6DCF8E0BF847B9E88B2C588C98844B9C5EC72E4DAF208F74F7060791DDCAB798F4399DBCE5C99A3A12E404F1D898A9DB8423D5EE8500B22314C21068057A70807B2043FE425D53B301C424390E51DC0D8388478C50682B56D2D2F92627C2D5B4BC88841CB4840441300301C914CC7126104E3C8C8109BC07413D64224678EA27250D32C6606A7936BCB8037DB030E477739EE489CCB7256952B9CCC8B80188A752D1091871194E06238318F3C877E5021540042286C3705E3CA01B7188B4500800224540306E21C60980191423C280CCE24386324769B92F024616EE48CC790ACC089610E569A69A21218805E790314107C383410D80069C5E5DF0C768A0007017E70C9DFAEA228C340DEC808ED8C1697EDAE70100083305131BAC7E028BF57B2166B625F0400000000C0734DAB308FBA34E3B8C51CF4623D9120046F07946B39C0D399A69A69A11EC3074E4AD2A5798EB4A95E63AD2A57892034C8258A61EE38523E88F79B160AC8F08A63398CD9B84343418CDB1444584E4E4136C0F1F6B60A042EDE85F01881A0C66D8F00430E179451C0B8D271608E3C201860E8E2C320962C99EB8E148FA26D286B880723007251046EDEBC801308AB8F4AF8159FA083190434A61878E9C09003990474042F602027AE9C0B20530235812996220E989F444634C6C914E07AF0C570C894C4031D066C50E20CE41433770A69AA7720FC21C965EE940E7C0D730DCC823B0C80126748F01FD15C9805B4E86028A48462EB9702841BB04AF4EC888A020301700F89AD2A578A70AF4001C14D1542245393C9E9C04FC669E2936D531AED58122DD9612E491745234E5D10115E8CC8F85B764B66C908F000701341AFD80570CE0A6B48BD51488B66EB2657C98A00429144A1902C20E0419A0D435F83023B206298A0B307019118A17C2DD90E1B1E7C250FCEACBDF35229A9A1188006A110AA1F08BAD8E00222503F9863616BC02B031318332037C4036250A2033381C15109BA0F92008000060028FD03032E12B40462D510008C13397E2AB4A95E24DB0200072543CAA260081F1F837801C09E098932E49F0D326C07529EF0278199008A278C094CDA69B09E8421A70D45A34C8E1298486719F0159908C670846C66162FD8471C0041111047D8100011305082E839808D6107720A2038024D25812880D14C3E74213E6676EC738B64A258EC8028430532F3D084024601E13A65C084800B6038943DA69C57A1085808A1C9D32E068482303C1F800807060429D780CEFE04648921A87508928E679F9E10922112FF008469E3A81C4668B9D1277E47807462B24C0E3EA8FCA30DB140E724D10C70465C78C892280E517A9D04470A95383407028D4849112AFC411042EC2C4751E26B4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4A95E63AD2A5798EB4B4C8C55E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E15E16B918AFFDA0008010100000010FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00DFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0066BFFF00FF00FF00FF00FF00FF00FF00FF00FF00FE443BFF00FF00FF00FF00FF00FF00FF00FF00FF00F8D01FAFFF00FF00FF00FF00FF00FF00FF00FF00EDC0039F7FFF00FF00FF00FF00FF00FF00FF00FF000002707CFF00FF00FF00FF00FF00FF00FF00FF006000DFFF00C7FF00FF00FF00FF00FF00FF00FF00E00007F9FF00FF00FF00FF00FF00FF00FF00FF00FD0007FF00CFFC3FFF00FF00FF00FF00FF00FF008000BFF878E6FF00FF00FF00FF00FF00FF00F000019C4F069FFF00FF00FF00FF00FF00FE0000FC1FE171FF00FF00FF00FF00FF00FF00C0000FFBFEEF9FFF00FF00FF00FF00FF00FE0000C0000019FF00FF00FF00FF00FF00FF00E0000DFF00FF00FC1FFF00FF00FF00FF00FAC60000E0000011B57FFF00FF00FED9E0000FFF00FF00FF001E87FF00FF00FF00E22E0000FF00F0FF00C1B37FFF00FF00FF00FF00E0000FFF005FFE1FFF00FF00FF00FF00FF00FE0400E0210021FF00FF00FF00FF00FF00FF00E1BA29F9AFBE1FFF00FF00FF00FF00FF00FE19A169D60E01FF00FF00FF00FF00FF00FF00FC4F8D20E11D9FEFFF00FF00FF00FF00FF00F5D5EDE7707FFF00FF00FF00FF00FF00FF00FF0089E08D99DBFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00CEFDFF007FFF00F8F63FF787FF00FF00F9DF1FF8F0F1AE17FF00F93D1FFEDFF17DAF7F1AEFFF00FF007FCFFF00B73F27DBFF00F22E7BFF00F33DDFFF00E5FABDBF8F22FF009CE7EFD3FF00CE3F7FE1F7F1AEF9CE7BBCFF00FF00F3E7BD8F0F1AE7FE5FB7D1FF00F63FF1D9F071FF00D7F9F9FC0FFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00BEB4722CF4B99FFF00FF00FF00FF00FF00FEA97A766A1C73FF00FF00FF00FF00FF00FF009E1D30BBE78DBFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FFC4002B1001000200040308030101010000000000010011213151F04161F1102060718191A1C13040B1D150E1FFDA0008010100013F10F8EA749D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E7C353A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34FFB4A05A80716703156ACFF0091BA69374D3FEA2816B442D6AB300FB5DCB6305C3E66ABE65B0AF048FB6080BE080F90819B3A4C5D0A2E152729E2E4B03C9A98F0D4DEB2FE932E405623F0F93EF0120A2C4707FE36E9A4DD34FF009CA05AD10C5A6CC03ED72C8C370F99AAF996827C127FAB2D01F82C7F425B18EE1F3357F31E5B6CC41ED7155B5B79F6B2BE32E08F79F3C0E708251803E87A3B112C0A2F60627F25582C5051ECCBDA0C1515FAD42CD7C7297AACC5C13CD97F5CBFE2EE9A4DD34FF90A05AD10E5AACC63DAE5B152FF00D6D57CCB61BE081FD59640BC163E896451B87CCD2FCC696EB3107B5D4556D55D5EF891C1AF9CB8BC8B950751CF3ECFAB6C0028283BA4110C01F4079C6B0DA0B675CCF365CE65C80AC03E4F27DE19312FDF3FB167FC3DD349BA69FF000CC1B82C194E42CB6101FF00ADAAF99603DC141FD59420382CF8A259016E1F334BF31C5B2CC41ED751556AAEAFE3317F6015CF4C095A6E92F179F1F81CA19DFA181A01DB9D6DAB5BA1ABC88457C201BC96AE5587617BB589DA822258CA91C6679F67D4AF597F11297790C5726A5E21D00817265F07CE27559B8CB4198F9FFC1DD349BA69FF00087682EC5B73D793DE34A5B65BE46872FCE974E934CC21582623CBEB3DE7017393FF005E7DC1E48238016B0333F02950B2285E331167BC8FA86D8559CC71D6AA47594300D9CBC07A23DC23BB4C0688CB8156B7ABCB8FC8E5048B989C2E4E44AF5C10B4FE43CCBF485572CF4F53F7F74D26E9A7FC04BAAA20D565E3EBC98D3FA3379455556D735FCC922E9655A012F895212CFCB2F563CA19A732AF9C98BDEBF3424CED7528CAE41C3007B8F62015CECB0AF918CA101AEA75FC7BD9F31ED1E668F3271B79711E5F5BEF31B779BD7583E67BCA90BA0B8FCBF83EF0EA3589627EEEE9A4DD34FDF0C37BCE2E83EF222755F600D15B387E6CF297458CCA7EFBE6D1170A8AABE41E0E47E146BBBF366389E7865FDC3E156D47958BB855195C1902D9AC5E578C29032F0051F8118C0CAAE60624A8336E0A3F2CBD18F2986B7ADA350BC5F97B413186080B7B5FD72FDCDD349BA69FBD6250A03EB338FBBCA7192F2C068320E5F9939DF4143CB57942C6C650B7DB3CDB7F2629FEEEBDD501003000A0FC61CEBAA21E7A3931142AC453EE1E6592E930D9076E0DFA430112FE3BE2732FF6B74D26E9A7EE27EE2F4038ACB81C4C9BC9A36358F81AD16AEABF94FBC1AAEB989812A0CD2529FCB3F561CA1B61A1D01A07E0B966B2CD659ACB352730F79CC3DE730F79D7275E9D7A7569D153A2A74544F33F44E889D112DFF04CF5E306FF006DF32996F666CADC31315E752BDC50520F3E1F060FE0E952E8988F9FEC6E9A4DD34FDBC13E9989A1C58E6F144732E2F2C8FCCF94C6335D62FC86372ADDF40CEF9B01715939A4F3FF006ED5140F37F3FF0058BB6DDB78CDA7F7369FDCC1A57CFF00DE72B779CE56EF380393DBAC730DE7DA83060713CE655B51ED4A950055FE7DB0912099A5F37EDD1A30178FE7120AC12E797CB0F5D2E845E0199CA16323C988F93C4727F6374D26E9A7ED52DFC4217C0E59B0F3B620E89C03F589DCDA65841054CF09B3BEE6CEFB9B3BEE211CC54DC917F8C6501E78138B889AEBF84517F0445B8673677DCD9DF73677DCCD0053E6FE367A408656D01062E277009259F7E136ED1FB3BA69374D3F69E19D1B0D56B1801001C1F3FD613B54EF4203C9DC34D35684C0E7E2917EF1DDDDC0C0AE797E1B9D147985BBEE1A69AE70B553E6025FBCAD144D0CECE0F763136ED1FB3BA69374D3F6F71D7F4C4CC328D296D68D7EC942850A142850A142850A142850A142850A142850A5718E87B5E0E1426DDA3F6774D26E9A7EDEE3AFE989A7A44158C2B1E026F5FB9BD7EE6F5FB9BD7EE6F5FB9BD7EE6F5FB9BD7EE6F5FB9BD7EE6F5FB9BD7EE6F5FB9BD7EE6F5FB9BD7EE6F5FB9BD7EE6F5FB9BD7EE6F5FB9BD7EE6F5FB8DB26CF568172E4141AE2340E1C26F3AC936ED1FB3BA69374D3F3D5E7F1F45B465CDEC015EC64D47126129EC033540A7AC7A2565AB68998F2661D6B7AC1C9C074828DA58B1A0BA860154E405AFB102058C919EF505F2D8A9EA76EE3AFE989AAB4E9ACA2B0709B63EA6D8FA9B63EA6D8FA9B63EA6D8FA9B63EA6D8FA9B63EA6D8FA9B63EA6D8FA9B63EA6D8FA9B63EA6D8FA9B63EA6D8FA9B63EA6D8FA9B63EA6D8FA9B63EA6402431E484421478ABE39BCEB24DBB4768964858AF22EABE7B08BAF685A008F5600832F607246058F0C069E74057DA546B0585D1313D49C7E0B2357581D25920EA20D34E7CC7F3EE9A4DD34FCF9D80711E091EC70A096E2E9EC309378819F3230AB270140784326046B58C742DF872970A5E6D760389D436899E182EF05CB1406459475EDDC75FD313E0AC6E150C2AC969B69B69B69B69B69B69B69B69B69B69B69B69B69B69B69B69B69B69B69B69B69B69A92BAEF5CB895ED2DCFC789B0BC4CDE75926DDA3B496574E39A578C8D31B07C8F7B6410CD6BC7183BB7364685FCC205AD1AC8D20A2C375198458B46B6D358014E2C41313F41CEE9A4DD34FCE1B79F96C3172C0ECB463414A8AB12F8D6B0448A5EA38044B32B1C658B3852E16A165B6D4433350404430A02B73F2602425CB4280C7CD83FA838140BA2DC20F749CE22F1B155C55CFB771D7F4C4CEB152A885B58A6F4FB9BD3EE6F4FB9BD3EE6F4FB9BD3EE6F4FB9BD3EE6F4FB82A05EE075218BCF0B7EEB032694FA891AD81A20FCCDE9F737A7DCDE9F737A7DCDE9F737A7DCDE9F737A7DCDE9F737A7DC65574137AAD03CE38BED501659A97A4DE75926DDA3B5953920AC456AE261D8B552B60B608E257080A2E4157EE8E05E5C825EB5301698508895CE52F424B0B642CA0C0A0EC02D315280C7C93F3EE9A4DD34FDBDC75FD3134C44414B428C3F16AD5AB56AD5AB56A5C90DBAEFA4A438D61EDE530D1B6563FC4069189FF00E3F9356AD5AB56AD5AB56AD499346156B5884DE75926DDA3F6774D26E9A7EDEE3AF78F75208BCB0B62BEB555FE426A38B21602B147F04C993264C99305A113876098FB801BCC21B4F2872A00EE91982A2E0312A197E34C993264C993264C9873A5749F3802E0C1C80A0C7C09BCEB24DBB47ECEE9A4DD34FDBDC75EE015A055E044C18CD4CA6CDA27C9414A4E016C244D7253B08B3F50C27CF495DB746D51CAC40AEC26A05A81AB340249D978D4CC56BCB1A846AC82581350C6D98ACB7E18B726F3208C528F06E04200EA0B12BB01668FC9A402D0D78FE0986013813FA40F810F2C5B931A90C0BAE1A98F20904B027231B6616A71E95B8A732356039658F2C6D98DB30AA0B9A872062C6F3C0659B14570E3379D649B768FD9DD349BA69FB7B8EBDC65F2784636E08AA0B42CDAF82CD9B442A4672899E0AF3BD2F80411ED281528E2DC401BE1EAE04C220B4703C80CE14063CEDC1F3C98E6B4A41CCB2EA1B996B286B088C4A091F6329574716DD731988738AD49D89E05D5F0ACD9813291285678139DAD47BDCB118A8ADFD6328843989C9CE6E7FB9600B8538E7D6043059494D4061712828A73E6C31D7B3000C274A4BE0FB294AD5C583C002FCFF38A94128CBA7CE52471062BAE7C224642027D8CA5E38AA315F46E601696FDC338D15C8B85A78E72EE828BC3F986FDE0579ADE511901ABC63CB8303E8EA679E7373FDCDCFF00718EB5BB4D0062AEC000366CAE1379D649B768FD9DD349BA69FA5E4BF6D655F27E1104104104104261155285EAB5ED162D1B8DD5917007030B231AEC6B731ECF20877935AC4CE2A15C45918F605801ACB9010B2FBCAA32B616C620C0733AA3A6936AE3CDFDA713898FF51216BB803561C24BC18A16B9D2AB1B286384F3DFFE14B1CD3ECC9815961C719C1AC7125B94BC87486BF2800E7A573B1678766A6E9A4309E8983482F2D01B0CE297C5B7157B1970CF094A5016AC8AF1584296916ACA8084885149C78E12E36028A463C308BC4774E118F0C23B65037E06BC18BC61C72C2048295F9B794473871138F1C22F681967BDA0EA2061583CA0E98242D7C8C22D62A60869DAD5AB2091147A846C549104B5C6D6B2E879B00BDB815C7B25B130D5B102B4FC22082082082094EF562DBCEFE0FD0DD349BA69FBD73AA5E2DD0DF1C8788F9C2A5006987F66157820981CB2094239D97E771FBF618C3C5B3CF2AF52620AC985999C9942862D60B76D6548E71B1D07C707D200BBA1C6C2E156B312FBB331E5FB9C36E09B06ACDE7261F37F44FB7DA290285D145AC4C98DB69756B5578708723272F22739099B75E47CB12382DA6AAD1FECB806583E865F33E23FB32FCBFA993D7F94FEA9FC7FA67DFEE7F0FE882C0176CB538C0139071C9C139C071DE1D6D512C3567138C56A287A817E511B1598E3BE5FBDBA69374D3F7C558D3ACB69B34B8236B6FF002020F183BC5A5E3462F620292C8BBCCF231F7275863216A8C40D75819AECC925AF27CD2A383045788CE6396AF2C0C88BC8D2ECB3281412C3826180D62112D5805572A83B6C02DB4ADF1F496AD585BA4945DD073055CC8A3B3108D2E7658F9C15E4799016ACDCD78CCF15755898333CD5D5606512ECC1778994C02EF8ACB8E2A19598911879555CBAB60BCD171F4E1D96DE0A7144B25FFF0056632DB5CE266617AD4B8C6D7F7B74D26E9A788F74D26E9A773348BB0B0C185F28DAC05821A7E10613D0838AC5731F8ED1E0931694A9A4C8AF798DFD199D71A8B6B0338859DAB3FE488F1A29385452C1919530315C07E3BC86D08941C684CDAAF2602ED6C42F48BC12BD2CCBD32EF3BE402A529C131C3B6D5A0A2A1A4D61473B69B358AB31862B44C4EE8478F640025526BDDB56AD5A77A32455A636BDC297FE2A438D765ACA6922905AE5DB43DE82D2D7926903814265AD40D87BB7D579EDA062C192B0109CEC03DD9550724F9B841E2E15BEABEA55594C42E5C3EA10404112C4E3DDB2BCCCA501549AC64620B0A4E16B4EE32312D95871A1AC3328AACBCCBB5D3BA27E24605ED1E58B1268605EE2AF89730B4A338DCD17E6B26195040B538263C3B84C81791512FDBBB6AD5AB4468BD2FA50EEB74D26E9A7770053C1C2D87CC5F59864DF2BCD3E3B58AB89865FE053D3B31194D6E2F8B5E9D857922E00B7F91AA5C7FC05C0F42898CA960E36C3E21F5EE99605AB904750D474C03DF17D673A8A334B3D46628C94AE69C07938F7D7C1965705E00BF99D2D16BCAE9A8E006C1BF318873C48E75F12F980E2330E202B6395E82277742602B61B71A9B8BEE6E2FB9B8BEE3F3858F09BBC1EE6E1A766F1A7B768E7369D4991E5DC1245E26BFF0003363F7CE2E0780700D2656BE270FBCF9E073844A0628DECDC3ADCB2E790167B91E48E02BD4D4E6445422D6A649D5F1E5DDDF35FC440813AD232F31F005F69FE9D93F2AC313A203D2ABC7C89E7B05FC41288C4B8F9388FC4A87FC15FEABFC3B9BA6BECB7CBC5312677CA6E2FB9B8BEE1ED440E3537AF7774D26E9A777107ACC392FC3DD1F072FF0010713D4B20D014B88964B8A1BE415FE44596E2E65A86118835707B0F46606F542E19A7C7630A51D7E2F895EB0E072FF01717D0B60E210B8028EEE38CDADC4AFF002C3D61E0D469EA3D0B61511006911E943E8C581A0171301ED70B7966C90B1EF5FDDB4F6B8C19D6214915FB7AE481FC8EAD81CA29FDBFCBA17B869D9BC69EDDA39CDA752647977189278CC389FBE1E92A0887648FB2D2BC8818580280381DAC8278CC54C57C9FED44588A29D4653BEAEE6E08BE653EBDCDF35FC4408133E1687AEAFE4AF301710160948B2C5724E0F27BFBA6BECDAF37E0DD349BA69DD3F0CFFC14C1F4698B4152E08D3FC98E7A62E3463F207A4C185F0675FF00C0F58EB21B706457AC249340870C00F53ED17F41F5C69C4F530813822E28B26267808E19AFC4632F59A724F87799B93A9C147E6F804CBA3189C5A59E947AB010B21928A484B38E371715EA24C3C1AE714CDE989E877AFEEDA7B4BEC2C7E540FEBC22056E3CD5BFD8BB4787CBEE16F5EEE8AAACD21A38D3DC081026137930B0C5A3B9B869D87BD41C10A0CBB746850B8584599381369D4991E5DC7AAD9BCD5084C117201FD7DFBA008020E029FB8F170CF9A87F8EE6F9AFE220409DDF186398621CC666EEAC4BCF83C9C67317A9BE759CA6159876F618AECE0AFBD90F6608DFBBE3B9BA6BECA90132D2EF34BED08114D232E20DB20D0EEEE9A4DD34EF603218385B87C0BEB3049AD2F37FA7DA6694F51C3A01E932EB23A71717DA9EB0D526EE22524349B0178DB17A94C08705CB9059FC7A44CD57DF01703D0A26372F838DB0F897EBDD20FA6F8E203E85BE91488AADABC6314A9033B8ACF8AB39FBFCE3405C144315779969ED11653C9BB3F469F482208D8E49DDBEF2CF3660D8CE8DFE239A37507DC22BE2FA7BCC4B9E50A7A1983AFB438423A80280EEE810013615A3C3B882081E021D880A31E3DCDC34EC4A8C0A0A0B454DB3FC9B67F9027C01AD4DDE15CA6D3A9323CBB8365203CAC9F090B683D5103ECFCBB86A5E764016B34CC1F2527C41968A39C23FABDCC37E29CED45B6817CD23E7B8F6D8AF984FC9304735DCF1F7451F50C1F318D8BC41C5B3843065C2A6CF294BC962D2D43061F41AD83E03A3743CBB9BA6BECAC74A02DA65E9DA820F5002EDF1567E6F7774D26E9A77B1BDB88727F8F74266F142A8667A967AC73541F34BF73D6E57CF7B587A766167680DB68F69673635F0627D50F58152E1FE02E2FA16C2BC1170051DDC752855C1FA051EF290A3324DD03AE136CFF26D9FE4DB3FC8B2961E01A4F894FC076B8B47C94F51EEDFAED09BAB407E26E4FB8B8D979B8762E24546C766269FDB82834AD71CB3EAF3F3FCDA17B869D9BC69EDDA39CDA7526479771D9A7459782724C3CC358F258B2E0F9ADE72B8C0BC0BA27DE5D8795AD14042058A2C5C4FC6F8BE91AC941D5FA8D988C073FD457B8ED41A8E059E8DBD25529EF9AB942E02CE64377D972E02DE443752ED4EF9A57FB2E75423A7FC17D7B85BD085769A02F8CC3E95A35C9CC3B4AD5B80285C8C420CAA303CBDCDD35F66D79BF06E9A4DD34EF14A66CE0A60FA34C6C8AAB8234FF226060F797BD57AC0028C03B310106163D43D98DCE3898649F1DD39462A9C5C07AB5182AC8CD1B5983F0C4311181E943DFB981B5C618181EE29F7987122C702F8FDF0EEAFEEDA7B6DAF571627FD7F1E529279E705CCE49310AAD71E32E6387774193567E1C49D40FF0027503FC9D40FF23DF048A52C70EE6E1A766F1A7B768E7369D4991E5DC4DBB26C0C70714268E80CCE4F5A8C40F130F52191A285FF0074B8B96F37F054441459610D5641CD8CAA70168CFED78F7539342B10A488E589AD3F0F9E4C29A9313E759CD32AAFB4869A9311E57940F48029A7BB7C5E103D0CEA00A03B814C9BED5291C405E58E32F3AF34BBFA404278031EE97F3148B4551BEF5108DD2C669FF91D6315AAC312E186473BEE6E9AFB2E8D032868613A81FE4EA07F93A81FE45DAFF66855EE6E9A4DD34EFA7E309959B434460EB3C6A45AB70C8ED02CE3B244A49B0BEE3E3C506D5566F74EE185D4085D38E715BC42C16378978C0028283B948420120596263C58F8A842C138E728C2B455ADBDA5794C3084BB3CD8948A6EA0D9C75ED04014523C60B1290105D0BC08573861E0B2DC3B8238C2854A72794D81F73607DCD81F73607DC42141C325382D77115A4345ACCB26C0FB8A7DA65681416F6A3786178196279C0761078C7AC0A2BBC29B9D6BF9B4BF58FD23427F61830704AF6A42027C20F5ACFBE185A816273267D3CA2CFC3E266F0F48B33821B57CD87C43C8D40501DE1953E87DAA7E630B1F0B03D8CB28FA17F2322A75C1E5657A7771AE1055A29F866C4FB9B03EE6C0FB9B03EE6C4FB94D2037740A3E0EE6E9A4DD34F11EE9A4DD34F11EE9A4DD34FD94B84050832598396D168B2FD52BC1CA133645268F60985D9D62E134ECE3DF74D6B8B47181EDB76405ACB2B16F06354068F38C70E85B979B3C2B27B3165FA1AD3168E3D86B6E961814BE256273807871A848D7C44B2C85885D0C5DA485085D2C558AE83459679A1C0F1656B1BBB0AE10E6248C80CD8D2F621446A8143CE574D03DC72598F26280AB419B063B54A0A6A16AF8CA2E81D8F0D08E397623400B5781117D870C6948B57C587029358EAA1C11E4CB39D392E2F083297E25F479253440236A19BB1EA0D37DF0BC88C312FA8322B4394D464C2F3D1E51CF0891E342C578525205313C908BB35CE33065C8F60B16539016BF11F5A6C2B9317CBE7B19D7D9A038C3D45BC20D44BAE72B8596010B459FAFB2CEEBD9054980F6344F9C61C1883C4BFD9DD349BA69FB3BC690095A8003405B2F381472CA969273065D8F87ECEEFCA2188EB98023FD982809E55919843489057D87995C399D9B372ECA10A0608A62E6C999264F093C435664DEF44DCF543A74A600501CAF38E88088A0CD83A4B03C10CE823FD8716D011B282669CA1CA05B21D69CCE64C90047CA0ADAF4817981729729E444D4E09E5D96B3728D12A1D43C536AD9CC5F0967772C5A8713CBB376D5D97EB81BA124A0D75598A975E1E91008823823304FA072C5072126EBAA0E66B5F885982B0A3265C36E9D890B8A2627D4CBDE15DD19A57BA986A880648E232EF58BEA1BADBCD0817D4050064138C3C40B16DBC30EC04F08688AB6F06105D2052535FDADD349BA69FB28372522B203382D77F0280D3E92F33CE0F03B16FB16E98F4F5DEB471A8C00D4EF387009985AC25B68796046508608780BC0B84380E41DE89262485F2E27840C8BEC4F2AE8DAAA1799CFB01C66AD84A4BCCE714F04DD82470E39879728B9FB7094C11CA39DCDCA5B003398B5393280D3E92D833A817542E6C4D9860C380BC0B86703C8A3DD10CE2F0B85DB30385C614815CA1785B3273945BAF01E728B3EC935466A678F60194D4514602F02E64BA5693AF0D3E4D83452073EC645DD680ADA38760781A8C91CE264B50AEADCEB6C92173EB3AFD42B49EE3A2055C8C8848286066B68AA4ECE39AC2F2A9545004F31597B44C8B85CC713E1A88E26E5274C6295E8C3203867141CF0C3D2344ACF9BAF66B0828F15A9C1985D25AD874B021F17B1055F944518766A555E5E678264FECEE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4DD34F11EE9A4F8AA749D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E74DCE9B9D373A6E7C153A4FFFD9, N'Eazi Warehouse', NULL, N'#374151', NULL, NULL, 1, CAST(N'2022-06-21T15:11:06.717' AS DateTime))
SET IDENTITY_INSERT [dbo].[tblSetting] OFF
GO
SET IDENTITY_INSERT [dbo].[tblTransfer] ON 

INSERT [dbo].[tblTransfer] ([TransferId], [TransferNumber], [TransferDate], [Reference], [FromWarehouse], [ToWarehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (4, N'T-002', CAST(N'2022-05-30' AS Date), N'Ref', 1, 1, NULL, N'De', 0, NULL, NULL, 1, CAST(N'2022-05-30T16:07:41.123' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblTransfer] ([TransferId], [TransferNumber], [TransferDate], [Reference], [FromWarehouse], [ToWarehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (8, N'T-005', CAST(N'2022-06-01' AS Date), N'T-Ref', 1, 3, NULL, N'Details', 0, NULL, NULL, 1, CAST(N'2022-06-01T15:13:03.833' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblTransfer] ([TransferId], [TransferNumber], [TransferDate], [Reference], [FromWarehouse], [ToWarehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (9, N'T-009', CAST(N'2022-06-01' AS Date), N'Ref', 1, 3, NULL, N'Details', 0, NULL, NULL, 1, CAST(N'2022-06-01T15:37:16.830' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblTransfer] ([TransferId], [TransferNumber], [TransferDate], [Reference], [FromWarehouse], [ToWarehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (12, N'T-0010', CAST(N'2022-06-01' AS Date), N'Ref', 3, 1, NULL, NULL, 0, NULL, NULL, 1, CAST(N'2022-06-01T16:23:29.440' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblTransfer] ([TransferId], [TransferNumber], [TransferDate], [Reference], [FromWarehouse], [ToWarehouse], [Attachment], [Details], [draft], [QRCode], [BarCode], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (13, N'T-0013', CAST(N'2022-06-16' AS Date), N'T-Ref1', 1, 3, NULL, NULL, 0, N'/Uploading/QRCode/T-0013.jpg', N'/Uploading/BarCode/T-0013.jpg', 1, CAST(N'2022-06-16T16:59:20.743' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblTransfer] OFF
GO
SET IDENTITY_INSERT [dbo].[tblTransferItem] ON 

INSERT [dbo].[tblTransferItem] ([TransferItemId], [TransferId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [ItemUsedQuantity], [ItemNetQuantity], [VNumber]) VALUES (23, 4, 1, NULL, 5, NULL, 1, CAST(N'2022-05-30T16:08:13.877' AS DateTime), NULL, NULL, NULL, 5, 3, 2, NULL)
INSERT [dbo].[tblTransferItem] ([TransferItemId], [TransferId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [ItemUsedQuantity], [ItemNetQuantity], [VNumber]) VALUES (26, 8, 1, NULL, 5, NULL, 1, CAST(N'2022-06-01T15:13:03.860' AS DateTime), NULL, NULL, NULL, 4, 0, 5, N'CI-004')
INSERT [dbo].[tblTransferItem] ([TransferItemId], [TransferId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [ItemUsedQuantity], [ItemNetQuantity], [VNumber]) VALUES (27, 9, 1, NULL, 4, NULL, 1, CAST(N'2022-06-01T15:37:16.887' AS DateTime), NULL, NULL, NULL, 3, 0, 4, N'CI-002')
INSERT [dbo].[tblTransferItem] ([TransferItemId], [TransferId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [ItemUsedQuantity], [ItemNetQuantity], [VNumber]) VALUES (30, 12, 1, NULL, 5, NULL, 1, CAST(N'2022-06-01T16:23:29.447' AS DateTime), NULL, NULL, NULL, 5, 0, 5, N'CI-005')
INSERT [dbo].[tblTransferItem] ([TransferItemId], [TransferId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [ItemUsedQuantity], [ItemNetQuantity], [VNumber]) VALUES (31, 13, 1, NULL, 4, NULL, 1, CAST(N'2022-06-16T16:59:20.750' AS DateTime), NULL, NULL, NULL, 3, 0, 4, N'CI-002')
SET IDENTITY_INSERT [dbo].[tblTransferItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUnit] ON 

INSERT [dbo].[tblUnit] ([UnitId], [Name], [Code], [BaseUnit], [Operator], [OperationValue], [Formula], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'A', N'dz', N'Piece (pc)', N'-', 11, N'Piece (pc) - 11= (dz)', 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblUnit] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUser] ON 

INSERT [dbo].[tblUser] ([UserId], [Name], [Username], [Password], [Email], [Warehouse], [Phone], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'Admin', N'admin', N'YWRtaW4=', N'admin@gmail.com', NULL, N'03000000000', 1, 1, NULL, 1, CAST(N'2022-06-03T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[tblUser] ([UserId], [Name], [Username], [Password], [Email], [Warehouse], [Phone], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (2, N'Asad', N'asadbilalarif', N'YXNhZA==', N'asad@gmail.com', NULL, N'03210000000', 2, 1, CAST(N'2022-05-19T00:00:00.000' AS DateTime), 1, CAST(N'2022-06-06T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[tblUser] ([UserId], [Name], [Username], [Password], [Email], [Warehouse], [Phone], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (4, N'Bilal', N'bilal', N'YmlsYWwx', N'bilal95007@gmail.com', NULL, N'03330000000', 1, 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblUser] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUserWarehouse] ON 

INSERT [dbo].[tblUserWarehouse] ([UserWarehouseId], [UserId], [WarehouseId]) VALUES (1, 1, 1)
INSERT [dbo].[tblUserWarehouse] ([UserWarehouseId], [UserId], [WarehouseId]) VALUES (2, 1, 3)
INSERT [dbo].[tblUserWarehouse] ([UserWarehouseId], [UserId], [WarehouseId]) VALUES (4, 2, 1)
SET IDENTITY_INSERT [dbo].[tblUserWarehouse] OFF
GO
SET IDENTITY_INSERT [dbo].[tblWarehouse] ON 

INSERT [dbo].[tblWarehouse] ([WarehouseId], [Name], [Code], [Phone], [Email], [Logo], [Address], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'Warehouse 1', N'100', N'03210000000', N'warehouse1@gmail.com', N'\Uploading\5f11c471f0f419303616a1fe.jpg', N'1', 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[tblWarehouse] ([WarehouseId], [Name], [Code], [Phone], [Email], [Logo], [Address], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (3, N'Warehouse 2', N'10002', N'03010000000', N'warehouse2@gmail.com', NULL, N'warehouse2 Lahore Pakistan', 1, CAST(N'2022-05-31T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-31T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblWarehouse] OFF
GO
ALTER TABLE [dbo].[tblAccessLevel]  WITH CHECK ADD  CONSTRAINT [FK_AccessManu] FOREIGN KEY([MenuId])
REFERENCES [dbo].[tblMenu] ([MenuId])
GO
ALTER TABLE [dbo].[tblAccessLevel] CHECK CONSTRAINT [FK_AccessManu]
GO
ALTER TABLE [dbo].[tblAdjustment]  WITH CHECK ADD  CONSTRAINT [AdjustmentWarehouse] FOREIGN KEY([Warehouse])
REFERENCES [dbo].[tblWarehouse] ([WarehouseId])
GO
ALTER TABLE [dbo].[tblAdjustment] CHECK CONSTRAINT [AdjustmentWarehouse]
GO
ALTER TABLE [dbo].[tblAdjustmentItem]  WITH CHECK ADD  CONSTRAINT [AdjustmentAdjustment] FOREIGN KEY([AdjustmentId])
REFERENCES [dbo].[tblAdjustment] ([AdjustmentId])
GO
ALTER TABLE [dbo].[tblAdjustmentItem] CHECK CONSTRAINT [AdjustmentAdjustment]
GO
ALTER TABLE [dbo].[tblAdjustmentItem]  WITH CHECK ADD  CONSTRAINT [AdjustmentItem] FOREIGN KEY([ItemId])
REFERENCES [dbo].[tblItem] ([ItemId])
GO
ALTER TABLE [dbo].[tblAdjustmentItem] CHECK CONSTRAINT [AdjustmentItem]
GO
ALTER TABLE [dbo].[tblAlertQty]  WITH CHECK ADD  CONSTRAINT [FK_tblAlertQty_tblItem] FOREIGN KEY([ItemId])
REFERENCES [dbo].[tblItem] ([ItemId])
GO
ALTER TABLE [dbo].[tblAlertQty] CHECK CONSTRAINT [FK_tblAlertQty_tblItem]
GO
ALTER TABLE [dbo].[tblCheckin]  WITH CHECK ADD  CONSTRAINT [CheckinContact] FOREIGN KEY([Contact])
REFERENCES [dbo].[tblContact] ([ContactId])
GO
ALTER TABLE [dbo].[tblCheckin] CHECK CONSTRAINT [CheckinContact]
GO
ALTER TABLE [dbo].[tblCheckin]  WITH CHECK ADD  CONSTRAINT [CheckinWarehouse] FOREIGN KEY([Warehouse])
REFERENCES [dbo].[tblWarehouse] ([WarehouseId])
GO
ALTER TABLE [dbo].[tblCheckin] CHECK CONSTRAINT [CheckinWarehouse]
GO
ALTER TABLE [dbo].[tblCheckinItem]  WITH CHECK ADD  CONSTRAINT [CheckinCheckin] FOREIGN KEY([CheckinId])
REFERENCES [dbo].[tblCheckin] ([CheckinId])
GO
ALTER TABLE [dbo].[tblCheckinItem] CHECK CONSTRAINT [CheckinCheckin]
GO
ALTER TABLE [dbo].[tblCheckinItem]  WITH CHECK ADD  CONSTRAINT [CheckinItem] FOREIGN KEY([ItemId])
REFERENCES [dbo].[tblItem] ([ItemId])
GO
ALTER TABLE [dbo].[tblCheckinItem] CHECK CONSTRAINT [CheckinItem]
GO
ALTER TABLE [dbo].[tblCheckout]  WITH CHECK ADD  CONSTRAINT [CheckoutContact] FOREIGN KEY([Contact])
REFERENCES [dbo].[tblContact] ([ContactId])
GO
ALTER TABLE [dbo].[tblCheckout] CHECK CONSTRAINT [CheckoutContact]
GO
ALTER TABLE [dbo].[tblCheckout]  WITH CHECK ADD  CONSTRAINT [CheckoutWarehouse] FOREIGN KEY([Warehouse])
REFERENCES [dbo].[tblWarehouse] ([WarehouseId])
GO
ALTER TABLE [dbo].[tblCheckout] CHECK CONSTRAINT [CheckoutWarehouse]
GO
ALTER TABLE [dbo].[tblCheckoutItem]  WITH CHECK ADD  CONSTRAINT [CheckoutCheckout] FOREIGN KEY([CheckoutId])
REFERENCES [dbo].[tblCheckout] ([CheckoutId])
GO
ALTER TABLE [dbo].[tblCheckoutItem] CHECK CONSTRAINT [CheckoutCheckout]
GO
ALTER TABLE [dbo].[tblCheckoutItem]  WITH CHECK ADD  CONSTRAINT [CheckoutItem] FOREIGN KEY([ItemId])
REFERENCES [dbo].[tblItem] ([ItemId])
GO
ALTER TABLE [dbo].[tblCheckoutItem] CHECK CONSTRAINT [CheckoutItem]
GO
ALTER TABLE [dbo].[tblEmailSetting]  WITH CHECK ADD  CONSTRAINT [FK_tblEmailSetting_tblUser] FOREIGN KEY([EditBy])
REFERENCES [dbo].[tblUser] ([UserId])
GO
ALTER TABLE [dbo].[tblEmailSetting] CHECK CONSTRAINT [FK_tblEmailSetting_tblUser]
GO
ALTER TABLE [dbo].[tblItem]  WITH CHECK ADD  CONSTRAINT [ItemCategory] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[tblCategory] ([CategoryId])
GO
ALTER TABLE [dbo].[tblItem] CHECK CONSTRAINT [ItemCategory]
GO
ALTER TABLE [dbo].[tblTransfer]  WITH CHECK ADD  CONSTRAINT [TransferFromWarehouse] FOREIGN KEY([FromWarehouse])
REFERENCES [dbo].[tblWarehouse] ([WarehouseId])
GO
ALTER TABLE [dbo].[tblTransfer] CHECK CONSTRAINT [TransferFromWarehouse]
GO
ALTER TABLE [dbo].[tblTransfer]  WITH CHECK ADD  CONSTRAINT [TransferToWarehouse] FOREIGN KEY([ToWarehouse])
REFERENCES [dbo].[tblWarehouse] ([WarehouseId])
GO
ALTER TABLE [dbo].[tblTransfer] CHECK CONSTRAINT [TransferToWarehouse]
GO
ALTER TABLE [dbo].[tblTransferItem]  WITH CHECK ADD  CONSTRAINT [TransferItem] FOREIGN KEY([ItemId])
REFERENCES [dbo].[tblItem] ([ItemId])
GO
ALTER TABLE [dbo].[tblTransferItem] CHECK CONSTRAINT [TransferItem]
GO
ALTER TABLE [dbo].[tblTransferItem]  WITH CHECK ADD  CONSTRAINT [TransferTransfer] FOREIGN KEY([TransferId])
REFERENCES [dbo].[tblTransfer] ([TransferId])
GO
ALTER TABLE [dbo].[tblTransferItem] CHECK CONSTRAINT [TransferTransfer]
GO
ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [FK_tblUser_tblRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[tblRole] ([RoleId])
GO
ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [FK_tblUser_tblRole]
GO
ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [FK_tblUser_tblWarehouse] FOREIGN KEY([Warehouse])
REFERENCES [dbo].[tblWarehouse] ([WarehouseId])
GO
ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [FK_tblUser_tblWarehouse]
GO
ALTER TABLE [dbo].[tblUserWarehouse]  WITH CHECK ADD  CONSTRAINT [FK_tblUserWarehouse_tblUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[tblUser] ([UserId])
GO
ALTER TABLE [dbo].[tblUserWarehouse] CHECK CONSTRAINT [FK_tblUserWarehouse_tblUser]
GO
ALTER TABLE [dbo].[tblUserWarehouse]  WITH CHECK ADD  CONSTRAINT [FK_tblUserWarehouse_tblWarehouse] FOREIGN KEY([WarehouseId])
REFERENCES [dbo].[tblWarehouse] ([WarehouseId])
GO
ALTER TABLE [dbo].[tblUserWarehouse] CHECK CONSTRAINT [FK_tblUserWarehouse_tblWarehouse]
GO
/****** Object:  StoredProcedure [dbo].[AdjustmentNumber]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[AdjustmentNumber]
AS
BEGIN

declare @ID as int
declare @res as nvarchar(12)
set @ID=0
SELECT @ID=AdjustmentId FROM tblAdjustment where AdjustmentId=(SELECT max(AdjustmentId) FROM tblAdjustment);
IF  @ID IS NOT NULL
		begin
			set @ID=@ID+1
			set @res=('A-00'+CAST(@ID as nvarchar(12)))
		end
		ELSE
		begin
			set @ID=1
			set @res=('A-00'+CAST(@ID as nvarchar(12)))
		end
	    select @res as Invoicenumber
END;
GO
/****** Object:  StoredProcedure [dbo].[AdjustmentReportData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[AdjustmentReportData]
@searchValue varchar(Max)
As
begin
Declare @sql as nvarchar(Max);


--select DISTINCT AI.AdjustmentId as AdjustmentId1 ,A.*,W.Name as WarehouseName,U.Name as UserName from tblAdjustment as A 
--inner join tblAdjustmentItem AI on A.AdjustmentId=AI.AdjustmentId 
--inner join tblItem as I on AI.ItemId=I.ItemId 
--inner join tblWarehouse as W on A.Warehouse=W.WarehouseId inner join tblUser as U on A.CreatedBy=U.UserId


set @sql='select DISTINCT AI.AdjustmentId as AdjustmentId1 ,A.*,W.Name as WarehouseName,U.Name as UserName from tblAdjustment as A 
inner join tblAdjustmentItem AI on A.AdjustmentId=AI.AdjustmentId 
inner join tblItem as I on AI.ItemId=I.ItemId 
inner join tblWarehouse as W on A.Warehouse=W.WarehouseId inner join tblUser as U on A.CreatedBy=U.UserId
 '+@searchValue+''

exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[AdjustmentViewData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[AdjustmentViewData]
@Id int
As
begin
Declare @sql as nvarchar(Max);


select  A.*,W.Name as WarehouseName,W.Address as WarehouseAddress,W.Email as WarehouseEmail,W.Phone as WarehousePhone
,I.Name as ItemName,I.Unit as ItemUnit,Cat.Name as ItemCategory,AI.ItemQuantity as ItemQuantity from tblAdjustment as A 
inner join tblAdjustmentItem AI on A.AdjustmentId=AI.AdjustmentId 
inner join tblItem as I on AI.ItemId=I.ItemId 
inner join tblWarehouse as W on A.Warehouse=W.WarehouseId
inner join tblCategory as Cat on Cat.CategoryId=I.CategoryId  where A.AdjustmentId=@Id;


exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[CheckinNumber]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[CheckinNumber]
AS
BEGIN

declare @ID as int
declare @res as nvarchar(12)
set @ID=0
SELECT @ID=CheckinId FROM tblCheckin where CheckinId=(SELECT max(CheckinId) FROM tblCheckin);
IF  @ID IS NOT NULL
		begin
			set @ID=@ID+1
			set @res=('CI-00'+CAST(@ID as nvarchar(12)))
		end
		ELSE
		begin
			set @ID=1
			set @res=('CI-00'+CAST(@ID as nvarchar(12)))
		end
	    select @res as Invoicenumber
END;
GO
/****** Object:  StoredProcedure [dbo].[CheckinReportData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[CheckinReportData]
@searchValue varchar(Max)
As
begin
Declare @sql as nvarchar(Max);


--select DISTINCT CII.CheckintId ,CI.*,W.Name as WarehouseName,C.Name as ContactName,U.Name as UserName from tblCheckin as CI 
--inner join tblCheckinItem CII on CI.CheckinId=CII.CheckinId 
--inner join tblItem as I on CII.ItemId=I.ItemId inner join tblContact as C on CI.Contact=C.ContactId
--inner join tblWarehouse as W on CI.Warehouse=W.WarehouseId inner join tblUser as U on CI.CreatedBy=U.UserId


set @sql='select DISTINCT CII.CheckinId ,CI.*,W.Name as WarehouseName,C.Name as ContactName,U.Name as UserName from tblCheckin as CI 
inner join tblCheckinItem CII on CI.CheckinId=CII.CheckinId 
inner join tblItem as I on CII.ItemId=I.ItemId inner join tblContact as C on CI.Contact=C.ContactId
inner join tblWarehouse as W on CI.Warehouse=W.WarehouseId inner join tblUser as U on CI.CreatedBy=U.UserId
 '+@searchValue+''

exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[CheckinViewData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[CheckinViewData]
@Id int
As
begin
Declare @sql as nvarchar(Max);


select  CI.*,W.Name as WarehouseName,W.Address as WarehouseAddress,W.Email as WarehouseEmail,W.Phone as WarehousePhone
,I.Name as ItemName,I.Unit as ItemUnit,Cat.Name as ItemCategory,CII.ItemQuantity as ItemQuantity,C.Name as ContactName,C.Email as ContactEmail,C.Phone as ContactPhone from tblCheckin as CI 
inner join tblCheckinItem CII on CI.CheckinId=CII.CheckinId 
inner join tblItem as I on CII.ItemId=I.ItemId 
inner join tblWarehouse as W on CI.Warehouse=W.WarehouseId 
inner join tblCategory as Cat on Cat.CategoryId=I.CategoryId 
inner join tblContact as C on C.ContactId=CI.Contact where CI.CheckinId=@Id;


exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[CheckoutNumber]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[CheckoutNumber]
AS
BEGIN

declare @ID as int
declare @res as nvarchar(12)
set @ID=0
SELECT @ID=CheckoutId FROM tblCheckout where CheckoutId=(SELECT max(CheckoutId) FROM tblCheckout);
IF  @ID IS NOT NULL
		begin
			set @ID=@ID+1
			set @res=('CO-00'+CAST(@ID as nvarchar(12)))
		end
		ELSE
		begin
			set @ID=1
			set @res=('CO-00'+CAST(@ID as nvarchar(12)))
		end
	    select @res as Invoicenumber
END;
GO
/****** Object:  StoredProcedure [dbo].[CheckoutReportData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[CheckoutReportData]
@searchValue varchar(Max)
As
begin
Declare @sql as nvarchar(Max);


--select DISTINCT COI.CheckoutId ,CO.*,W.Name as WarehouseName,C.Name as ContactName,U.Name as UserName from tblCheckout as CO 
--inner join tblCheckoutItem COI on CO.CheckoutId=COI.CheckoutId 
--inner join tblItem as I on COI.ItemId=I.ItemId inner join tblContact as C on CO.Contact=C.ContactId
--inner join tblWarehouse as W on CO.Warehouse=W.WarehouseId inner join tblUser as U on CO.CreatedBy=U.UserId


set @sql='select DISTINCT COI.CheckoutId ,CO.*,W.Name as WarehouseName,C.Name as ContactName,U.Name as UserName from tblCheckout as CO 
inner join tblCheckoutItem COI on CO.CheckoutId=COI.CheckoutId 
inner join tblItem as I on COI.ItemId=I.ItemId inner join tblContact as C on CO.Contact=C.ContactId
inner join tblWarehouse as W on CO.Warehouse=W.WarehouseId inner join tblUser as U on CO.CreatedBy=U.UserId
 '+@searchValue+''

exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[CheckoutViewData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[CheckoutViewData]
@Id int
As
begin
Declare @sql as nvarchar(Max);


select  CO.*,W.Name as WarehouseName,W.Address as WarehouseAddress,W.Email as WarehouseEmail,W.Phone as WarehousePhone
,I.Name as ItemName,I.Unit as ItemUnit,Cat.Name as ItemCategory,COI.ItemQuantity as ItemQuantity,C.Name as ContactName,C.Email as ContactEmail,C.Phone as ContactPhone from tblCheckout as CO 
inner join tblCheckoutItem COI on CO.CheckoutId=COI.CheckoutId 
inner join tblItem as I on COI.ItemId=I.ItemId 
inner join tblWarehouse as W on CO.Warehouse=W.WarehouseId 
inner join tblCategory as Cat on Cat.CategoryId=I.CategoryId 
inner join tblContact as C on C.ContactId=CO.Contact where CO.CheckoutId=@Id;


exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[GetAdjustmentItemData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetAdjustmentItemData]
@CheckinItemItemId int
As
begin
Declare @sql as nvarchar(Max);


select AI.ItemId,AI.AdjustmentItemId as FTailId,AI.ItemNetQuantity,I.Name,A.AdjustmentNumber as Number  from tblAdjustmentItem as AI inner join tblItem as I on AI.ItemId=I.ItemId
inner join tblAdjustment as A on A.AdjustmentId=AI.AdjustmentId
where AI.AdjustmentItemId=@CheckinItemItemId

end




GO
/****** Object:  StoredProcedure [dbo].[GetCheckinItemData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetCheckinItemData]
@CheckinItemItemId int
As
begin
Declare @sql as nvarchar(Max);


select CII.ItemId,CII.CheckinItemId as FTailId,CII.ItemNetQuantity,I.Name,CI.CheckinNumber as Number from tblCheckinItem as CII inner join tblItem as I on CII.ItemId=I.ItemId
inner join tblCheckin as CI on CI.CheckinId=CII.CheckinId
where CII.CheckinItemId=@CheckinItemItemId

end




GO
/****** Object:  StoredProcedure [dbo].[GetCheckinList]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetCheckinList]
@ItemId int,
@WarehouseId int
As
begin
Declare @sql as nvarchar(Max);


select CII.CheckinItemId as FTailId ,CI.CheckinNumber as Number,CII.ItemNetQuantity  from tblCheckinItem as CII inner join tblCheckin as CI on CII.CheckinId=CI.CheckinId
where CII.ItemId=@ItemId and CI.Warehouse=@WarehouseId and CII.ItemNetQuantity>0 and CI.draft=0
UNION
select TI.TransferItemId as FTailId,T.TransferNumber as Number,TI.ItemNetQuantity from tblTransferItem as TI inner join tblTransfer as T on TI.TransferId=T.TransferId
where TI.ItemId=@ItemId and T.FromWarehouse=@WarehouseId and TI.ItemNetQuantity>0 and T.draft=0
UNION
select AI.AdjustmentItemId as FTailId,A.AdjustmentNumber as Number,AI.ItemNetQuantity from tblAdjustmentItem as AI inner join tblAdjustment as A on AI.AdjustmentId=A.AdjustmentId
where AI.ItemId=@ItemId and A.Warehouse=@WarehouseId and AI.ItemNetQuantity>0 and A.draft=0

end




GO
/****** Object:  StoredProcedure [dbo].[GetItemAlertValue]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetItemAlertValue]
@Id int,
@res int output
As
begin

set @res= (select Alertonlowstock from tblItem where ItemId=@Id)

select @res;
end

--exec GetItemAlertValue 1
GO
/****** Object:  StoredProcedure [dbo].[GetTCheckinList]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[GetTCheckinList]
@ItemId int,
@WarehouseId int
As
begin
Declare @sql as nvarchar(Max);


select CII.CheckinItemId as FTailId ,CI.CheckinNumber as Number,CII.ItemNetQuantity  from tblCheckinItem as CII inner join tblCheckin as CI on CII.CheckinId=CI.CheckinId
where CII.ItemId=@ItemId and CI.Warehouse=@WarehouseId and CII.ItemNetQuantity>0 and CI.draft=0
UNION
select AI.AdjustmentItemId as FTailId,A.AdjustmentNumber as Number,AI.ItemNetQuantity from tblAdjustmentItem as AI inner join tblAdjustment as A on AI.AdjustmentId=A.AdjustmentId
where AI.ItemId=@ItemId and A.Warehouse=@WarehouseId and AI.ItemNetQuantity>0 and A.draft=0

end




GO
/****** Object:  StoredProcedure [dbo].[GetTransferItemData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetTransferItemData]
@TransferItemId int
As
begin
Declare @sql as nvarchar(Max);


select TI.ItemId,TI.TransferItemId as FTailId,TI.ItemNetQuantity,I.Name,T.TransferNumber as Number from tblTransferItem as TI inner join tblItem as I on TI.ItemId=I.ItemId 
inner join tblTransfer as T on T.TransferId=TI.TransferId
where TI.TransferItemId=@TransferItemId

end






GO
/****** Object:  StoredProcedure [dbo].[ItemStockLedgerDetailReportData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ItemStockLedgerDetailReportData]
@ItemId int,
@WarehouseId int
As
begin



select CI.CheckinNumber as Number, I.ItemId as ItemId,W.WarehouseId as WarehouseId, Cat.Name as CategoryName,I.Name as ItemName,CII.ItemNetQuantity as ItemNetQuantity ,W.Name as WarehouseName from tblCheckin as CI 
inner join tblCheckinItem as CII on CI.CheckinId=CII.CheckinId inner join tblItem as I on CII.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId inner join tblWarehouse as W on CI.Warehouse=W.WarehouseId where I.ItemId=@ItemId and W.WarehouseId=@WarehouseId

union

select T.TransferNumber as Number,I.ItemId as ItemId,W.WarehouseId as WarehouseId, Cat.Name as CategoryName,I.Name as ItemName,TI.ItemNetQuantity as ItemNetQuantity,W.Name as WarehouseName from tblTransfer as T 
inner join tblTransferItem as TI on T.TransferId=TI.TransferId inner join tblItem as I on TI.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId inner join tblWarehouse as W on T.ToWarehouse=W.WarehouseId where I.ItemId=@ItemId and W.WarehouseId=@WarehouseId

union

select A.AdjustmentNumber as Number,I.ItemId as ItemId,W.WarehouseId as WarehouseId, Cat.Name as CategoryName,I.Name as ItemName,AI.ItemNetQuantity as ItemNetQuantity,W.Name as WarehouseName from tblAdjustment as A 
inner join tblAdjustmentItem as AI on A.AdjustmentId=AI.AdjustmentId inner join tblItem as I on AI.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId inner join tblWarehouse as W on A.Warehouse=W.WarehouseId where I.ItemId=@ItemId and W.WarehouseId=@WarehouseId


end
GO
/****** Object:  StoredProcedure [dbo].[ItemStockLedgerReportData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ItemStockLedgerReportData]
@searchValue nvarchar(Max),
@TsearchValue nvarchar(Max),
@AsearchValue nvarchar(Max)
As
begin
Declare @sql as nvarchar(Max);

--select ItemId,WarehouseId,CategoryName,ItemName,sum(ItemNetQuantity) as TQty,WarehouseName from(

--select I.ItemId as ItemId,W.WarehouseId as WarehouseId, Cat.Name as CategoryName,I.Name as ItemName,CII.ItemNetQuantity as ItemNetQuantity ,W.Name as WarehouseName from tblCheckin as CI 
--inner join tblCheckinItem as CII on CI.CheckinId=CII.CheckinId inner join tblItem as I on CII.ItemId= I.ItemId 
--inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId inner join tblWarehouse as W on CI.Warehouse=W.WarehouseId 

--union

--select I.ItemId as ItemId,W.WarehouseId as WarehouseId, Cat.Name as CategoryName,I.Name as ItemName,TI.ItemNetQuantity as ItemNetQuantity,W.Name as WarehouseName from tblTransfer as T 
--inner join tblTransferItem as TI on T.TransferId=TI.TransferId inner join tblItem as I on TI.ItemId= I.ItemId 
--inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId inner join tblWarehouse as W on T.ToWarehouse=W.WarehouseId 

--union

--select I.ItemId as ItemId,W.WarehouseId as WarehouseId, Cat.Name as CategoryName,I.Name as ItemName,AI.ItemNetQuantity as ItemNetQuantity,W.Name as WarehouseName from tblAdjustment as A 
--inner join tblAdjustmentItem as AI on A.AdjustmentId=AI.AdjustmentId inner join tblItem as I on AI.ItemId= I.ItemId 
--inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId inner join tblWarehouse as W on A.Warehouse=W.WarehouseId 
--) as Z group by ItemId,WarehouseId,CategoryName,ItemName,WarehouseName

set @sql='select ItemId,WarehouseId,CategoryName,ItemName,sum(ItemNetQuantity) as TQty,WarehouseName from(

select I.ItemId as ItemId,W.WarehouseId as WarehouseId, Cat.Name as CategoryName,I.Name as ItemName,CII.ItemNetQuantity as ItemNetQuantity ,W.Name as WarehouseName from tblCheckin as CI 
inner join tblCheckinItem as CII on CI.CheckinId=CII.CheckinId inner join tblItem as I on CII.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId inner join tblWarehouse as W on CI.Warehouse=W.WarehouseId '+@searchValue+'

union

select I.ItemId as ItemId,W.WarehouseId as WarehouseId, Cat.Name as CategoryName,I.Name as ItemName,TI.ItemNetQuantity as ItemNetQuantity,W.Name as WarehouseName from tblTransfer as T 
inner join tblTransferItem as TI on T.TransferId=TI.TransferId inner join tblItem as I on TI.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId inner join tblWarehouse as W on T.ToWarehouse=W.WarehouseId '+@TsearchValue+'

union

select I.ItemId as ItemId,W.WarehouseId as WarehouseId, Cat.Name as CategoryName,I.Name as ItemName,AI.ItemNetQuantity as ItemNetQuantity,W.Name as WarehouseName from tblAdjustment as A 
inner join tblAdjustmentItem as AI on A.AdjustmentId=AI.AdjustmentId inner join tblItem as I on AI.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId inner join tblWarehouse as W on A.Warehouse=W.WarehouseId  '+@AsearchValue+'
) as Z group by ItemId,WarehouseId,CategoryName,ItemName,WarehouseName'

exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[ItemSumCalculate]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ItemSumCalculate]
@Id int
As
begin

select sum(ItemNetQuantity) as TQty from(

select I.ItemId as ItemId, Cat.Name as CategoryName,I.Name as ItemName,CII.ItemNetQuantity as ItemNetQuantity from tblCheckin as CI 
inner join tblCheckinItem as CII on CI.CheckinId=CII.CheckinId inner join tblItem as I on CII.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId  where I.ItemId=@Id

union

select I.ItemId as ItemId, Cat.Name as CategoryName,I.Name as ItemName,TI.ItemNetQuantity as ItemNetQuantity from tblTransfer as T 
inner join tblTransferItem as TI on T.TransferId=TI.TransferId inner join tblItem as I on TI.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId  where I.ItemId=@Id

union

select I.ItemId as ItemId, Cat.Name as CategoryName,I.Name as ItemName,AI.ItemNetQuantity as ItemNetQuantity from tblAdjustment as A 
inner join tblAdjustmentItem as AI on A.AdjustmentId=AI.AdjustmentId inner join tblItem as I on AI.ItemId= I.ItemId 
inner join tblCategory as Cat on I.CategoryId=Cat.CategoryId  where I.ItemId=@Id
) as Z group by ItemId,CategoryName,ItemName


end
GO
/****** Object:  StoredProcedure [dbo].[TransferReportData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[TransferReportData]
@searchValue varchar(Max)
As
begin
Declare @sql as nvarchar(Max);


--select DISTINCT TI.TransferId ,T.*,FW.Name as FromWarehouseName,TW.Name as ToWarehouseName,U.Name as UserName from tblTransfer as T 
--inner join tblTransferItem TI on T.TransferId=TI.TransferId 
--inner join tblItem as I on TI.ItemId=I.ItemId
--inner join tblWarehouse as FW on T.FromWarehouse=FW.WarehouseId 
--inner join tblWarehouse as TW on T.FromWarehouse=TW.WarehouseId
--inner join tblUser as U on T.CreatedBy=U.UserId


set @sql='select DISTINCT TI.TransferId ,T.*,FW.Name as FromWarehouseName,TW.Name as ToWarehouseName,U.Name as UserName from tblTransfer as T 
inner join tblTransferItem TI on T.TransferId=TI.TransferId 
inner join tblItem as I on TI.ItemId=I.ItemId
inner join tblWarehouse as FW on T.FromWarehouse=FW.WarehouseId 
inner join tblWarehouse as TW on T.FromWarehouse=TW.WarehouseId
inner join tblUser as U on T.CreatedBy=U.UserId
 '+@searchValue+''

exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[TransferViewData]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[TransferViewData]
@Id int
As
begin
Declare @sql as nvarchar(Max);


select  T.*,FW.Name as FWarehouseName,FW.Address as FWarehouseAddress,FW.Email as FWarehouseEmail,FW.Phone as FWarehousePhone
,TW.Name as TWarehouseName,TW.Address as TWarehouseAddress,TW.Email as TWarehouseEmail,TW.Phone as TWarehousePhone
,I.Name as ItemName,I.Unit as ItemUnit,Cat.Name as ItemCategory,TI.ItemQuantity as ItemQuantity from tblTransfer as T 
inner join tblTransferItem as TI on T.TransferId=TI.TransferId 
inner join tblItem as I on TI.ItemId=I.ItemId 
inner join tblWarehouse as FW on T.FromWarehouse=FW.WarehouseId 
inner join tblWarehouse as TW on TW.WarehouseId=T.ToWarehouse
inner join tblCategory as Cat on Cat.CategoryId=I.CategoryId  where T.TransferId=@Id;


exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[TransfrNumber]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[TransfrNumber]
AS
BEGIN

declare @ID as int
declare @res as nvarchar(12)
set @ID=0
SELECT @ID=TransferId FROM tblTransfer where TransferId=(SELECT max(TransferId) FROM tblTransfer);
IF  @ID IS NOT NULL
		begin
			set @ID=@ID+1
			set @res=('T-00'+CAST(@ID as nvarchar(12)))
		end
		ELSE
		begin
			set @ID=1
			set @res=('T-00'+CAST(@ID as nvarchar(12)))
		end
	    select @res as Invoicenumber
END;
GO
/****** Object:  StoredProcedure [dbo].[WarehouseAccess]    Script Date: 06/21/2022 3:23:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[WarehouseAccess]
@SearchValue nvarchar(max)
As
begin
Declare @sql as nvarchar(Max);


--select * from tblWarehouse where isActive=1 ;

set @sql='select * from tblWarehouse where isActive=1 
 '+@searchValue+''

exec (@sql)
end
GO
USE [master]
GO
ALTER DATABASE [Inventories] SET  READ_WRITE 
GO
