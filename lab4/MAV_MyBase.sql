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
CREATE TABLE [dbo].[Заказчики](
	[Название_фирмы] [nvarchar](30) NOT NULL,
	[Банковские_реквизиты] [nvarchar](30) NULL,
	[Телефон] [nvarchar](20) NULL,
	[Контактное_лицо] [nvarchar](30) NULL,
 CONSTRAINT [PK_Заказчики] PRIMARY KEY CLUSTERED 
(
	[Название_фирмы] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Телепередачи](
	[Название_передачи] [nvarchar](30) NOT NULL,
	[Рейтинг_передачи] [int] NULL,
	[Стоимость_рекламы_в_минуту] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Телепередачи] PRIMARY KEY CLUSTERED 
(
	[Название_передачи] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Рекламные_заказы](
	[Номер_рекламы] [int] NOT NULL,
	[Название_передачи] [nvarchar](30) NULL,
	[Длительность_рекламы_в_минутах] [nvarchar](15) NULL,
	[Дата] [date] NULL,
	[Заказчик] [nvarchar](30) NULL,
 CONSTRAINT [PK_Рекламные_заказы] PRIMARY KEY CLUSTERED 
(
	[Номер_рекламы] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Рекламные_заказы]  WITH CHECK ADD  CONSTRAINT [FK_Рекламные_заказы_Заказчики] FOREIGN KEY([Заказчик])
REFERENCES [dbo].[Заказчики] ([Название_фирмы])
GO

ALTER TABLE [dbo].[Рекламные_заказы] CHECK CONSTRAINT [FK_Рекламные_заказы_Заказчики]
GO

ALTER TABLE [dbo].[Рекламные_заказы]  WITH CHECK ADD  CONSTRAINT [FK_Рекламные_заказы_Телепередачи] FOREIGN KEY([Название_передачи])
REFERENCES [dbo].[Телепередачи] ([Название_передачи])
GO

ALTER TABLE [dbo].[Рекламные_заказы] CHECK CONSTRAINT [FK_Рекламные_заказы_Телепередачи]
GO



use [MAV_MyBase]

INSERT INTO [Заказчики]
           ([Название_фирмы]
           ,[Банковские_реквизиты]
           ,[Телефон]
           ,[Контактное_лицо])
     VALUES
		   ('Activision',523484,+375293441323,'Андрей'),
		   ('Ряженка',413484,+375293441323,'Александр'),
		   ('Coca-Cola',513484,+375293441323,'Евгений');
GO

INSERT INTO [Телепередачи]
           ([Название_передачи]
           ,[Рейтинг_передачи]
           ,[Стоимость_рекламы_в_минуту])
     VALUES
           ('Викинги',8,5),
		   ('Братья стребковы',7,7),
		   ('1+1',5,8),
		   ('Тор',10,6),
		   ('Завтра',7,9);
GO

INSERT INTO [Рекламные_заказы]
           ([Номер_рекламы]
           ,[Название_передачи]
           ,[Длительность_рекламы_в_минутах]
           ,[Дата]
           ,[Заказчик])
     VALUES
           (1,'Викинги',5,'2021-02-11','Coca-Cola'),
		   (2,'Братья стребковы',5,'2021-02-11','Coca-Cola'),
		   (3,'1+1',5,'2021-02-11','Activision'),
		   (4,'Тор',5,'2021-02-11','Coca-Cola'),
		   (5,'Братья стребковы',5,'2021-02-11','Activision'),
		   (6,'Завтра',5,'2021-02-11','Ряженка');
GO
