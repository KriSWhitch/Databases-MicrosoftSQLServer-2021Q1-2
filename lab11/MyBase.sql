USE [MAV_MyBase];
-- ������ � ����������� ����������� � ����� ������ � �������������� �������
DECLARE @ad varchar(100), @num int;
DECLARE AdvertsCursor CURSOR LOCAL DYNAMIC SCROLL
FOR SELECT [���������_������].[��������_��������], count([���������_������].[��������_��������]) FROM [���������_������] GROUP BY [���������_������].[��������_��������];
OPEN AdvertsCursor;
	FETCH AdvertsCursor into @ad,@num;
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			print + cast(@num as varchar(3)) + ' ������� �� �������� "' + rtrim(@ad) + '"';
			FETCH AdvertsCursor INTO @ad, @num;
		END;
	CLOSE AdvertsCursor;
GO