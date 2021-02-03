USE [MAV_MyBase]
GO

/****** Object:  Table [dbo].[Рекламные_заказы]    Script Date: 03.02.2021 22:23:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Рекламные_заказы](
	[Номер_рекламы] [int] NOT NULL,
	[Название_передачи] [nvarchar](30) NULL,
	[Вид_рекламы] [nvarchar](15) NULL,
	[Длительность_рекламы_в_минутах] [nvarchar](15) NULL,
	[Дата] [date] NULL,
	[Заказчик] [nvarchar](30) NULL,
 CONSTRAINT [PK_Рекламные_заказы] PRIMARY KEY CLUSTERED 
(
	[Номер_рекламы] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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


