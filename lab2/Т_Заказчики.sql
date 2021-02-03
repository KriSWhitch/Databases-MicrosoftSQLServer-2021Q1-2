USE [MAV_MyBase]
GO

/****** Object:  Table [dbo].[Заказчики]    Script Date: 03.02.2021 22:22:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Заказчики](
	[Название_фирмы] [nvarchar](30) NOT NULL,
	[Банковские_реквизиты] [nvarchar](30) NULL,
	[Телефон] [nvarchar](20) NULL,
	[Контактное_лицо] [nvarchar](30) NULL,
 CONSTRAINT [PK_Заказчики] PRIMARY KEY CLUSTERED 
(
	[Название_фирмы] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


