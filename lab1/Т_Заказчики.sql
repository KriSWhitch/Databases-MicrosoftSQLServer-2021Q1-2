USE [Муковозчик_Продажи]
GO

/****** Object:  Table [dbo].[Заказчики]    Script Date: 02.02.2021 9:17:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Заказчики](
	[Наименование_Фирмы] [nvarchar](20) NOT NULL,
	[Адрес] [nvarchar](50) NULL,
	[Расчетный_счет] [nvarchar](15) NULL,
 CONSTRAINT [PK_Заказчики] PRIMARY KEY CLUSTERED 
(
	[Наименование_Фирмы] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


