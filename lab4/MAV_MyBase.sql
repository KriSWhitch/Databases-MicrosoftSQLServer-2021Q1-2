USE [master]
GO

/****** Object:  Database [MAV_MyBase]    Script Date: 11.02.2021 11:48:19 ******/
CREATE DATABASE [MAV_MyBase] ON  PRIMARY 
( NAME = N'MAV_MyBase', FILENAME = N'C:\Base_students\' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB),
filegroup G1
( NAME = N'MAV_MyBase11', FILENAME = N'C:\Base_students\' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB),
filegroup G2
( NAME = N'MAV_MyBase21', FILENAME = N'C:\Base_students\' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB)
 LOG ON 
( NAME = N'MAV_MyBase_log', FILENAME = N'C:\Base_students\' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

use [MAV_MyBase]
CREATE TABLE [dbo].[���������](
	[��������_�����] [nvarchar](30) NOT NULL,
	[����������_���������] [nvarchar](30) NULL,
	[�������] [nvarchar](20) NULL,
	[����������_����] [nvarchar](30) NULL,
 CONSTRAINT [PK_���������] PRIMARY KEY CLUSTERED 
(
	[��������_�����] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[������������](
	[��������_��������] [nvarchar](30) NOT NULL,
	[�������_��������] [int] NULL,
	[���������_�������_�_������] [decimal](18, 2) NULL,
 CONSTRAINT [PK_������������] PRIMARY KEY CLUSTERED 
(
	[��������_��������] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[���������_������](
	[�����_�������] [int] NOT NULL,
	[��������_��������] [nvarchar](30) NULL,
	[������������_�������_�_�������] [nvarchar](15) NULL,
	[����] [date] NULL,
	[��������] [nvarchar](30) NULL,
 CONSTRAINT [PK_���������_������] PRIMARY KEY CLUSTERED 
(
	[�����_�������] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[���������_������]  WITH CHECK ADD  CONSTRAINT [FK_���������_������_���������] FOREIGN KEY([��������])
REFERENCES [dbo].[���������] ([��������_�����])
GO

ALTER TABLE [dbo].[���������_������] CHECK CONSTRAINT [FK_���������_������_���������]
GO

ALTER TABLE [dbo].[���������_������]  WITH CHECK ADD  CONSTRAINT [FK_���������_������_������������] FOREIGN KEY([��������_��������])
REFERENCES [dbo].[������������] ([��������_��������])
GO

ALTER TABLE [dbo].[���������_������] CHECK CONSTRAINT [FK_���������_������_������������]
GO



use [MAV_MyBase]

INSERT INTO [���������]
           ([��������_�����]
           ,[����������_���������]
           ,[�������]
           ,[����������_����])
     VALUES
		   ('Activision',523484,+375293441323,'������'),
		   ('�������',413484,+375293441323,'���������'),
		   ('Coca-Cola',513484,+375293441323,'�������');
GO

INSERT INTO [������������]
           ([��������_��������]
           ,[�������_��������]
           ,[���������_�������_�_������])
     VALUES
           ('�������',8,5),
		   ('������ ���������',7,7),
		   ('1+1',5,8),
		   ('���',10,6),
		   ('������',7,9);
GO

INSERT INTO [���������_������]
           ([�����_�������]
           ,[��������_��������]
           ,[������������_�������_�_�������]
           ,[����]
           ,[��������])
     VALUES
           (1,'�������',5,'2021-02-11','Coca-Cola'),
		   (2,'������ ���������',5,'2021-02-11','Coca-Cola'),
		   (3,'1+1',5,'2021-02-11','Activision'),
		   (4,'���',5,'2021-02-11','Coca-Cola'),
		   (5,'������ ���������',5,'2021-02-11','Activision'),
		   (6,'������',5,'2021-02-11','�������');
GO
