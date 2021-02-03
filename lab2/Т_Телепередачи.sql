USE [MAV_MyBase]
GO

/****** Object:  Table [dbo].[Телепередачи]    Script Date: 03.02.2021 22:23:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Телепередачи](
	[Название_передачи] [nvarchar](30) NOT NULL,
	[Рейтинг_передачи] [decimal](18, 2) NULL,
	[Стоимость_рекламы_в_минуту] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Телепередачи] PRIMARY KEY CLUSTERED 
(
	[Название_передачи] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


