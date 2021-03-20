USE [MAV_MyBase];
-- Работа с несколькими переменными в одной строке с использованием курсора
DECLARE @ad varchar(100), @num int;
DECLARE AdvertsCursor CURSOR LOCAL DYNAMIC SCROLL
FOR SELECT [Рекламные_Заказы].[Название_передачи], count([Рекламные_заказы].[Название_передачи]) FROM [Рекламные_заказы] GROUP BY [Рекламные_Заказы].[Название_передачи];
OPEN AdvertsCursor;
	FETCH AdvertsCursor into @ad,@num;
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			print + cast(@num as varchar(3)) + ' Заказов на передачу "' + rtrim(@ad) + '"';
			FETCH AdvertsCursor INTO @ad, @num;
		END;
	CLOSE AdvertsCursor;
GO