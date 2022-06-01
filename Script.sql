USE [master]
GO
/****** Object:  Database [Inventories]    Script Date: 01/06/2022 5:51:09 pm ******/
CREATE DATABASE [Inventories]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Inventories', FILENAME = N'C:\Eazisols\Data\Inventories.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Inventories_log', FILENAME = N'C:\Eazisols\Data\Inventories_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
/****** Object:  Table [dbo].[tblAccessLevel]    Script Date: 01/06/2022 5:51:09 pm ******/
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
/****** Object:  Table [dbo].[tblAdjustment]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblAdjustmentItem]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblCategory]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblCheckin]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblCheckinItem]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblCheckout]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblCheckoutItem]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblContact]    Script Date: 01/06/2022 5:51:10 pm ******/
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
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditBy] [int] NULL,
	[EditDate] [datetime] NULL,
	[isActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblItem]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblMenu]    Script Date: 01/06/2022 5:51:10 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMenu](
	[MenuId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
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
/****** Object:  Table [dbo].[tblRole]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblTempPath]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblTransfer]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblTransferItem]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblUnit]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblUser]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  Table [dbo].[tblWarehouse]    Script Date: 01/06/2022 5:51:10 pm ******/
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

INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (312, NULL, NULL, NULL, 2, 1, 1, CAST(N'2022-06-01T16:19:15.663' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.663' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (313, NULL, NULL, NULL, 3, 1, 1, CAST(N'2022-06-01T16:19:15.690' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.690' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (314, NULL, NULL, NULL, 4, 1, 1, CAST(N'2022-06-01T16:19:15.690' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.690' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (315, NULL, NULL, NULL, 5, 1, 1, CAST(N'2022-06-01T16:19:15.693' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.693' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (316, NULL, NULL, NULL, 6, 1, 1, CAST(N'2022-06-01T16:19:15.693' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.693' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (317, NULL, NULL, NULL, 7, 1, 1, CAST(N'2022-06-01T16:19:15.697' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.697' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (318, NULL, NULL, NULL, 8, 1, 1, CAST(N'2022-06-01T16:19:15.697' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.697' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (319, NULL, NULL, NULL, 9, 1, 1, CAST(N'2022-06-01T16:19:15.700' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.700' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (320, NULL, NULL, NULL, 10, 1, 1, CAST(N'2022-06-01T16:19:15.700' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.700' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (321, NULL, NULL, NULL, 11, 1, 1, CAST(N'2022-06-01T16:19:15.703' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.703' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (322, NULL, NULL, NULL, 12, 1, 1, CAST(N'2022-06-01T16:19:15.707' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.707' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (323, NULL, NULL, NULL, 13, 1, 1, CAST(N'2022-06-01T16:19:15.707' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.707' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (324, NULL, NULL, NULL, 14, 1, 1, CAST(N'2022-06-01T16:19:15.707' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.707' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (325, NULL, NULL, NULL, 15, 1, 1, CAST(N'2022-06-01T16:19:15.710' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.710' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (326, NULL, NULL, NULL, 16, 1, 1, CAST(N'2022-06-01T16:19:15.710' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.710' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (327, NULL, NULL, NULL, 17, 1, 1, CAST(N'2022-06-01T16:19:15.713' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.713' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (328, NULL, NULL, NULL, 18, 1, 1, CAST(N'2022-06-01T16:19:15.713' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.713' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (329, NULL, NULL, NULL, 19, 1, 1, CAST(N'2022-06-01T16:19:15.717' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.717' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (330, NULL, NULL, NULL, 20, 1, 1, CAST(N'2022-06-01T16:19:15.717' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.717' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (331, NULL, NULL, NULL, 21, 1, 1, CAST(N'2022-06-01T16:19:15.720' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.720' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (332, NULL, NULL, NULL, 22, 1, 1, CAST(N'2022-06-01T16:19:15.720' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.720' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (333, NULL, NULL, NULL, 23, 1, 1, CAST(N'2022-06-01T16:19:15.723' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.723' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (334, NULL, NULL, NULL, 24, 1, 1, CAST(N'2022-06-01T16:19:15.723' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.723' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (335, NULL, NULL, NULL, 25, 1, 1, CAST(N'2022-06-01T16:19:15.723' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.723' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[tblAccessLevel] ([AccessId], [EditAccess], [DeleteAccess], [CreateAccess], [MenuId], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive]) VALUES (336, NULL, NULL, NULL, 26, 1, 1, CAST(N'2022-06-01T16:19:15.727' AS DateTime), 1, CAST(N'2022-06-01T16:19:15.727' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[tblAccessLevel] OFF
GO
SET IDENTITY_INSERT [dbo].[tblAdjustment] ON 

INSERT [dbo].[tblAdjustment] ([AdjustmentId], [AdjustmentNumber], [AdjustmentDate], [Reference], [Type], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'A-001', CAST(N'2022-05-25' AS Date), N'Ref', N'Damage', 1, N'\Uploading\Tracking XML Developer Guide.pdf', N'Details', 0, 1, CAST(N'2022-05-25T14:18:41.377' AS DateTime), 1, CAST(N'2022-05-25T14:18:41.377' AS DateTime), NULL)
INSERT [dbo].[tblAdjustment] ([AdjustmentId], [AdjustmentNumber], [AdjustmentDate], [Reference], [Type], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (3, N'A-002', CAST(N'2022-06-01' AS Date), N'A-Ref', N'Addition', 1, NULL, N'Details', NULL, 1, CAST(N'2022-06-01T15:13:34.017' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblAdjustment] ([AdjustmentId], [AdjustmentNumber], [AdjustmentDate], [Reference], [Type], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (4, N'A-004', CAST(N'2022-06-01' AS Date), N'Ref', N'Addition', 3, NULL, N'Details', NULL, 1, CAST(N'2022-06-01T15:36:49.190' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblAdjustment] OFF
GO
SET IDENTITY_INSERT [dbo].[tblAdjustmentItem] ON 

INSERT [dbo].[tblAdjustmentItem] ([AdjustmentItemId], [AdjustmentId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (3, 1, 1, 1, 1, N'Dozen', 1, CAST(N'2022-05-25T14:18:41.393' AS DateTime), NULL, NULL, NULL, 0, 1)
INSERT [dbo].[tblAdjustmentItem] ([AdjustmentItemId], [AdjustmentId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (5, 3, 1, 1, 6, N'Piece', 1, CAST(N'2022-06-01T15:13:34.040' AS DateTime), NULL, NULL, NULL, 0, 6)
INSERT [dbo].[tblAdjustmentItem] ([AdjustmentItemId], [AdjustmentId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (6, 4, 1, 1, 10, N'Piece', 1, CAST(N'2022-06-01T15:36:49.243' AS DateTime), NULL, NULL, NULL, 0, 10)
SET IDENTITY_INSERT [dbo].[tblAdjustmentItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCategory] ON 

INSERT [dbo].[tblCategory] ([CategoryId], [Name], [Code], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'A', N'100', 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCheckin] ON 

INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (3, N'CI-002', CAST(N'2022-05-27' AS Date), N'Ref', 1, 1, NULL, NULL, 0, 1, CAST(N'2022-05-27T17:07:54.970' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (4, N'CI-004', CAST(N'2022-05-27' AS Date), N'Ref', 1, 1, NULL, NULL, 0, 1, CAST(N'2022-05-27T18:15:33.817' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (5, N'CI-005', CAST(N'2022-06-01' AS Date), N'CI-Ref', 1, 3, NULL, N'Deteils', 0, 1, CAST(N'2022-06-01T15:11:27.997' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckin] ([CheckinId], [CheckinNumber], [CheckinDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (6, N'CI-006', CAST(N'2022-06-01' AS Date), N'CI-Ref', 1, 3, NULL, N'Details', 0, 1, CAST(N'2022-06-01T15:35:50.437' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblCheckin] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCheckinItem] ON 

INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (3, 3, 1, 1, 10, N'Piece', 1, CAST(N'2022-05-27T17:07:55.027' AS DateTime), NULL, NULL, NULL, 6, 4)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (4, 4, 1, 1, 15, N'Piece', 1, CAST(N'2022-05-27T18:15:33.830' AS DateTime), NULL, NULL, NULL, 10, 5)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (5, 5, 1, 1, 10, N'Piece', 1, CAST(N'2022-06-01T15:11:28.073' AS DateTime), NULL, NULL, NULL, 10, 0)
INSERT [dbo].[tblCheckinItem] ([CheckinItemId], [CheckinId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [ItemUsedQuantity], [ItemNetQuantity]) VALUES (6, 6, 1, 1, 10, N'Piece', 1, CAST(N'2022-06-01T15:35:50.493' AS DateTime), NULL, NULL, NULL, 6, 4)
SET IDENTITY_INSERT [dbo].[tblCheckinItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCheckout] ON 

INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'CO-001', CAST(N'2022-05-25' AS Date), N'Ref', 1, 1, N'\Uploading\Tracking RESTful Developer Guide.pdf', N'Details', 0, 1, CAST(N'2022-05-25T13:05:40.043' AS DateTime), 1, CAST(N'2022-05-25T13:05:40.043' AS DateTime), NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (5, N'CO-002', CAST(N'2022-05-27' AS Date), N'Ref', 1, 1, NULL, NULL, 0, 1, CAST(N'2022-05-30T15:05:29.800' AS DateTime), 1, CAST(N'2022-05-30T15:05:30.113' AS DateTime), NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (9, N'CO-006', CAST(N'2022-05-30' AS Date), N'Ref', 1, 1, NULL, N'Det', 0, 1, CAST(N'2022-05-30T19:51:36.783' AS DateTime), 1, CAST(N'2022-05-30T19:51:36.783' AS DateTime), NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (10, N'CO-0010', CAST(N'2022-06-01' AS Date), N'CO-Ref', 1, 3, NULL, N'Details', 0, 1, CAST(N'2022-06-01T15:12:21.667' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblCheckout] ([CheckoutId], [CheckoutNumber], [CheckoutDate], [Reference], [Contact], [Warehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (11, N'CO-0011', CAST(N'2022-06-01' AS Date), N'CO-Ref', 1, 3, NULL, N'Details', 0, 1, CAST(N'2022-06-01T15:36:21.707' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblCheckout] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCheckoutItem] ON 

INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (3, 1, 1, 1, 1, N'Dozen', 1, CAST(N'2022-05-25T13:05:40.070' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (4, 1, 1, 1, 1, N'Piece', 1, CAST(N'2022-05-25T13:05:40.070' AS DateTime), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (10, 5, 1, NULL, 2, NULL, 1, CAST(N'2022-05-30T15:05:58.650' AS DateTime), NULL, NULL, NULL, 3, N'C')
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (14, 9, 1, NULL, 3, NULL, 1, CAST(N'2022-05-30T19:51:36.920' AS DateTime), NULL, NULL, NULL, 23, NULL)
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (15, 10, 1, NULL, 5, NULL, 1, CAST(N'2022-06-01T15:12:21.737' AS DateTime), NULL, NULL, NULL, 5, N'CI-005')
INSERT [dbo].[tblCheckoutItem] ([CheckoutItemId], [CheckoutId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [VNumber]) VALUES (16, 11, 1, NULL, 6, NULL, 1, CAST(N'2022-06-01T15:36:21.760' AS DateTime), NULL, NULL, NULL, 6, N'CI-006')
SET IDENTITY_INSERT [dbo].[tblCheckoutItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblContact] ON 

INSERT [dbo].[tblContact] ([ContactId], [Name], [Email], [Phone], [Details], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'Asad', N'asad@gmail.com', N'03210000000', N'Contact Info', 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblContact] OFF
GO
SET IDENTITY_INSERT [dbo].[tblItem] ON 

INSERT [dbo].[tblItem] ([ItemId], [Name], [Code], [CategoryId], [Unit], [BarcodeSymbology], [RackLocation], [SKU], [Details], [Alertonlowstock], [TrackQuantity], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'Chair', N'100', 1, N'Kilogram', N'CODE128', N'Left', NULL, N'Good', 5, 1, 1, CAST(N'2022-05-23T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-23T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[tblItem] ([ItemId], [Name], [Code], [CategoryId], [Unit], [BarcodeSymbology], [RackLocation], [SKU], [Details], [Alertonlowstock], [TrackQuantity], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (3, N'Table', N'1001', 1, N'Kilogram', N'EAN-13', N'Left', NULL, N'details', 9, 1, 1, CAST(N'2022-06-01T00:00:00.000' AS DateTime), 1, CAST(N'2022-06-01T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblMenu] ON 

INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (2, N'Dashboard', N'Home', N'Index', 0, 0, N'fe fe-home', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Dashboard')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (3, N'User Management', N'User', N'', 1, 0, N'fa fa-users', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'UM')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (4, N'Users', N'User', N'Users', 0, 3, N'fa fa-user', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Users')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (5, N'Permissions', N'User', N'RolesPermission', 0, 3, N'fa fa-key', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Roles')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (6, N'Setup', NULL, NULL, 1, 0, N'fa fa-code', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Setup')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (7, N'Contacts', N'Contact', N'Contacts', 0, 6, N'fa fa-address-book', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Contacts')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (8, N'Categories', N'Category', N'Categories', 0, 6, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Categories')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (9, N'Units', N'Unit', N'Units', 0, 6, N'fa fa-microchip', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Units')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (10, N'Warehouses', N'Warehouse', N'Warehouses', 0, 6, N'fa fa-warehouse', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Warehouses')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (11, N'Items', N'Item', N'Items', 0, 6, N'fa fa-heart', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Items')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (12, N'Transfer', NULL, NULL, 1, 0, N'fa fa-truck', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Transfer')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (13, N'Transfers', N'Transfer', N'Transfers', 0, 12, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Transfers')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (14, N'Checkin', NULL, NULL, 1, 0, N'fa fa-arrow-left', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Checkin')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (15, N'Checkins', N'Checkin', N'Checkins', 0, 14, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Checkins')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (16, N'Checkout', NULL, NULL, 1, 0, N'fa fa-arrow-right', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Checkout')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (17, N'Checkouts', N'Checkout', N'Checkouts', 0, 16, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Checkouts')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (18, N'Adjustment', NULL, NULL, 1, 0, N'fa fa-adjust', NULL, NULL, NULL, NULL, NULL, NULL, 0, N'Adjustment')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (19, N'Adjustments', N'Adjustment', N'Adjustments', 0, 18, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Adjustments')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (20, N'Reports', N'', N'', 1, 0, N'fa fa-file', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'Reports')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (21, N'Total Records', N'Report', N'TotalRecord', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'TotalRecord')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (22, N'Checkin Report', N'Report', N'CheckinReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'CheckinReport')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (23, N'Checkout Report', N'Report', N'CheckoutReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'CheckoutReport')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (24, N'Transfer Report', N'Report', N'TransferReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'TransferReport')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (25, N'Adjustment Report', N'Report', N'AdjustmentReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'AdjustmentReport')
INSERT [dbo].[tblMenu] ([MenuId], [Name], [ControllerName], [ActionName], [isParent], [ParentId], [FontAwesome], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [DeletedBy], [DeletedDate], [isActive], [ElementId]) VALUES (26, N'Item Stock Ledger Report', N'Report', N'ItemStockLedgerReport', 0, 20, N'fa fa-link', NULL, NULL, NULL, NULL, NULL, NULL, 1, N'ItemStockLedgerReport')
SET IDENTITY_INSERT [dbo].[tblMenu] OFF
GO
SET IDENTITY_INSERT [dbo].[tblRole] ON 

INSERT [dbo].[tblRole] ([RoleId], [Role], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'Admin', 1, CAST(N'2022-05-19T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-19T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[tblRole] ([RoleId], [Role], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (2, N'Employee', 1, CAST(N'2022-06-01T00:00:00.000' AS DateTime), 1, CAST(N'2022-06-01T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblRole] OFF
GO
SET IDENTITY_INSERT [dbo].[tblTransfer] ON 

INSERT [dbo].[tblTransfer] ([TransferId], [TransferNumber], [TransferDate], [Reference], [FromWarehouse], [ToWarehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (4, N'T-002', CAST(N'2022-05-30' AS Date), N'Ref', 1, 1, NULL, N'De', 0, 1, CAST(N'2022-05-30T16:07:41.123' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblTransfer] ([TransferId], [TransferNumber], [TransferDate], [Reference], [FromWarehouse], [ToWarehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (8, N'T-005', CAST(N'2022-06-01' AS Date), N'T-Ref', 1, 3, NULL, N'Details', 0, 1, CAST(N'2022-06-01T15:13:03.833' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblTransfer] ([TransferId], [TransferNumber], [TransferDate], [Reference], [FromWarehouse], [ToWarehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (9, N'T-009', CAST(N'2022-06-01' AS Date), N'Ref', 1, 3, NULL, N'Details', 0, 1, CAST(N'2022-06-01T15:37:16.830' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblTransfer] ([TransferId], [TransferNumber], [TransferDate], [Reference], [FromWarehouse], [ToWarehouse], [Attachment], [Details], [draft], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (12, N'T-0010', CAST(N'2022-06-01' AS Date), N'Ref', 3, 1, NULL, NULL, 0, 1, CAST(N'2022-06-01T16:23:29.440' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblTransfer] OFF
GO
SET IDENTITY_INSERT [dbo].[tblTransferItem] ON 

INSERT [dbo].[tblTransferItem] ([TransferItemId], [TransferId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [ItemUsedQuantity], [ItemNetQuantity], [VNumber]) VALUES (23, 4, 1, NULL, 5, NULL, 1, CAST(N'2022-05-30T16:08:13.877' AS DateTime), NULL, NULL, NULL, 5, 3, 2, NULL)
INSERT [dbo].[tblTransferItem] ([TransferItemId], [TransferId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [ItemUsedQuantity], [ItemNetQuantity], [VNumber]) VALUES (26, 8, 1, NULL, 5, NULL, 1, CAST(N'2022-06-01T15:13:03.860' AS DateTime), NULL, NULL, NULL, 4, 0, 5, N'CI-004')
INSERT [dbo].[tblTransferItem] ([TransferItemId], [TransferId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [ItemUsedQuantity], [ItemNetQuantity], [VNumber]) VALUES (27, 9, 1, NULL, 4, NULL, 1, CAST(N'2022-06-01T15:37:16.887' AS DateTime), NULL, NULL, NULL, 3, 0, 4, N'CI-002')
INSERT [dbo].[tblTransferItem] ([TransferItemId], [TransferId], [ItemId], [ItemWeight], [ItemQuantity], [ItemUnit], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive], [CheckinItemId], [ItemUsedQuantity], [ItemNetQuantity], [VNumber]) VALUES (30, 12, 1, NULL, 5, NULL, 1, CAST(N'2022-06-01T16:23:29.447' AS DateTime), NULL, NULL, NULL, 5, 0, 5, N'CI-005')
SET IDENTITY_INSERT [dbo].[tblTransferItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUnit] ON 

INSERT [dbo].[tblUnit] ([UnitId], [Name], [Code], [BaseUnit], [Operator], [OperationValue], [Formula], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'A', N'dz', N'Piece (pc)', N'-', 11, N'Piece (pc) - 11= (dz)', 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblUnit] OFF
GO
SET IDENTITY_INSERT [dbo].[tblUser] ON 

INSERT [dbo].[tblUser] ([UserId], [Name], [Username], [Password], [Email], [Warehouse], [Phone], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (1, N'Admin', N'admin', N'YWRtaW4=', N'admin@gmail.com', NULL, N'03000000000', 1, 1, NULL, 1, CAST(N'2022-05-19T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[tblUser] ([UserId], [Name], [Username], [Password], [Email], [Warehouse], [Phone], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (2, N'Asad', N'asadbilalarif', N'YXNhZA==', N'asad@gmail.com', NULL, N'03210000000', 1, 1, CAST(N'2022-05-19T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-19T00:00:00.000' AS DateTime), 1)
INSERT [dbo].[tblUser] ([UserId], [Name], [Username], [Password], [Email], [Warehouse], [Phone], [RoleId], [CreatedBy], [CreatedDate], [EditBy], [EditDate], [isActive]) VALUES (4, N'Bilal', N'bilal', N'YmlsYWwx', N'bilal95007@gmail.com', NULL, N'03330000000', 1, 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-05-20T00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[tblUser] OFF
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
/****** Object:  StoredProcedure [dbo].[AdjustmentNumber]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[AdjustmentReportData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[AdjustmentViewData]    Script Date: 01/06/2022 5:51:10 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[AdjustmentViewData]
@Id int
As
begin
Declare @sql as nvarchar(Max);


select  A.*,W.Name as WarehouseName,W.Address as WarehouseAddress,W.Email as WarehouseEmail,W.Phone as WarehousePhone
,I.Name as ItemName,AI.ItemQuantity as ItemQuantity from tblAdjustment as A 
inner join tblAdjustmentItem AI on A.AdjustmentId=AI.AdjustmentId 
inner join tblItem as I on AI.ItemId=I.ItemId 
inner join tblWarehouse as W on A.Warehouse=W.WarehouseId where A.AdjustmentId=@Id;


exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[CheckinNumber]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[CheckinReportData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[CheckinViewData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
,I.Name as ItemName,CII.ItemQuantity as ItemQuantity,C.Name as ContactName,C.Email as ContactEmail,C.Phone as ContactPhone from tblCheckin as CI 
inner join tblCheckinItem CII on CI.CheckinId=CII.CheckinId 
inner join tblItem as I on CII.ItemId=I.ItemId 
inner join tblWarehouse as W on CI.Warehouse=W.WarehouseId 
inner join tblContact as C on C.ContactId=CI.Contact where CI.CheckinId=@Id;


exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[CheckoutNumber]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[CheckoutReportData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[CheckoutViewData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
,I.Name as ItemName,COI.ItemQuantity as ItemQuantity,C.Name as ContactName,C.Email as ContactEmail,C.Phone as ContactPhone from tblCheckout as CO 
inner join tblCheckoutItem COI on CO.CheckoutId=COI.CheckoutId 
inner join tblItem as I on COI.ItemId=I.ItemId 
inner join tblWarehouse as W on CO.Warehouse=W.WarehouseId 
inner join tblContact as C on C.ContactId=CO.Contact where CO.CheckoutId=@Id;


exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[GetAdjustmentItemData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[GetCheckinItemData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[GetCheckinList]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[GetTCheckinList]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[GetTransferItemData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[ItemStockLedgerDetailReportData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[ItemStockLedgerReportData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[TransferReportData]    Script Date: 01/06/2022 5:51:10 pm ******/
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
/****** Object:  StoredProcedure [dbo].[TransferViewData]    Script Date: 01/06/2022 5:51:10 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[TransferViewData]
@Id int
As
begin
Declare @sql as nvarchar(Max);


select  T.*,FW.Name as FWarehouseName,FW.Address as FWarehouseAddress,FW.Email as FWarehouseEmail,FW.Phone as FWarehousePhone
,TW.Name as TWarehouseName,TW.Address as TWarehouseAddress,TW.Email as TWarehouseEmail,TW.Phone as TWarehousePhone
,I.Name as ItemName,TI.ItemQuantity as ItemQuantity from tblTransfer as T 
inner join tblTransferItem as TI on T.TransferId=TI.TransferId 
inner join tblItem as I on TI.ItemId=I.ItemId 
inner join tblWarehouse as FW on T.FromWarehouse=FW.WarehouseId 
inner join tblWarehouse as TW on TW.WarehouseId=T.ToWarehouse where T.TransferId=@Id;


exec (@sql)
end
GO
/****** Object:  StoredProcedure [dbo].[TransfrNumber]    Script Date: 01/06/2022 5:51:10 pm ******/
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
USE [master]
GO
ALTER DATABASE [Inventories] SET  READ_WRITE 
GO
