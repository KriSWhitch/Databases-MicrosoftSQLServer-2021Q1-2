use MAV_UNIVERTMP;

-- task 1
DECLARE @i int = 1,
		@c char(1) = 'a',
		@b varchar(4) = 'BSTU',
		@d datetime = 2021-12-27,
		@t time = '12:03:12',
		@si smallint,
		@ti tinyint,
		@n numeric(12,5) = 12.313443;
SET @si = 5;
SET @ti = 3;
SELECT TOP(1) @i = AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM;
SELECT @i; SELECT @c;
SELECT @b; SELECT @d;
print 't = '+cast(@t as varchar(20));
print 'si = '+cast(@si as varchar(20));
print 'ti = '+cast(@ti as varchar(20));
print 'n = '+cast(@n as varchar(20));

-- task 2
use MAV_UNIVERTMP;
DECLARE @TotalCapacity int = (SELECT SUM(AUDITORIUM_CAPACITY) FROM AUDITORIUM);
IF @TotalCapacity > 200
BEGIN
DECLARE @NumOfAud numeric(12,2) = (SELECT COUNT(AUDITORIUM.AUDITORIUM) FROM AUDITORIUM),
@AvgCapacityOfAud numeric(12,2) = (SELECT AVG(AUDITORIUM_CAPACITY) FROM AUDITORIUM);
DECLARE @NumOfAudWhereCapacityLowerThanAvg int = (SELECT COUNT(AUDITORIUM.AUDITORIUM) FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_CAPACITY < @AvgCapacityOfAud);
DECLARE @PercentOfLowerAud numeric(12,2) = (@NumOfAudWhereCapacityLowerThanAvg *100/@NumOfAud);
SELECT @NumOfAud '���������� ���������', @AvgCapacityOfAud '������� ����������� ���������',
@NumOfAudWhereCapacityLowerThanAvg '���-�� ��������� ��� ����������� < AVG',
@PercentOfLowerAud '������� ��������� ��� ����������� < AVG, %';
END
ELSE (SELECT @TotalCapacity '����� ����������� ���������');

-- task 3
use MAV_UNIVERTMP;
print '����� ������������ �����: ' + cast(@@ROWCOUNT as varchar(24)) + CHAR(13) +
'������ SQL Server: ' + cast(@@VERSION as varchar(118)) + CHAR(13) +
'������������� ��������: ' + cast(@@SPID as varchar(16)) + CHAR(13) +
'��� �������: ' + cast(@@SERVERNAME as varchar(16)) + CHAR(13) +
'������� ����������� ����������: ' + cast(@@TRANCOUNT as varchar(16)) + CHAR(13) +
'�������� ���������� ���������� �����: ' + cast(@@FETCH_STATUS as varchar(16)) + CHAR(13) +
'����������� ������� ���������: ' + cast(@@NESTLEVEL as varchar(16)) + CHAR(13) +
'��� ��������� ������: ' + cast(@@ERROR as varchar(16)) + CHAR(13);

-- task 4
DECLARE @z float, @x int = 3, @t int = 5;
IF (@t>@x) SET @z = power(sin(@t),2);
ELSE IF (@t<@x) SET @z = 4*(@t+@x);
ELSE IF (@t=@x) SET @z = 1-exp(@x-2);
print 'z: ' + cast(@z as varchar(24));

SET @x = 3;
SET @t = 1;
IF (@t>@x) SET @z = power(sin(@t),2);
ELSE IF (@t<@x) SET @z = 4*(@t+@x);
ELSE IF (@t=@x) SET @z = 1-exp(@x-2);
print 'z: ' + cast(@z as varchar(24));

SET @x = 1;
SET @t = 1;
IF (@t>@x) SET @z = power(sin(@t),2);
ELSE IF (@t<@x) SET @z = 4*(@t+@x);
ELSE IF (@t=@x) SET @z = 1-exp(@x-2);
print 'z: ' + cast(@z as varchar(24));

DECLARE @NameArray varchar(64) = (SELECT STUDENT.NAME FROM STUDENT);

-- task 6
SELECT CASE
	WHEN PROGRESS.NOTE > 6 then '������'
	WHEN PROGRESS.NOTE < 4 then '�����'
	ELSE '�����������������'
END [������], count(*)[����������] FROM PROGRESS
GROUP BY CASE 
	WHEN PROGRESS.NOTE > 6 then '������'
	WHEN PROGRESS.NOTE < 4 then '�����'
	ELSE '�����������������'
END;

-- task 7
DROP table #tmpTable;
CREATE table #tmpTable (TIND int, TFIELD varchar(100));
SET NOCOUNT ON ;
DECLARE @i int=0;
WHILE @i<100
	BEGIN
		INSERT #tmpTable(TIND,TFIELD)
			values(floor(300*rand()), '������');
		IF(@i % 10 = 0) print @i;
		SET @i = @i+1;
	END;
SELECT * FROM #tmpTable;

-- task 8
DECLARE @i int=1;
WHILE @i<100
	BEGIN
		print @i;
		IF(@i % 50 = 0) RETURN;
		SET @i = @i+1;
	END;

-- task 9

-- Verify that the stored procedure does not already exist.  
IF OBJECT_ID ( 'usp_GetErrorInfo', 'P' ) IS NOT NULL   
    DROP PROCEDURE usp_GetErrorInfo;  
GO  
  
-- Create procedure to retrieve error information.  
CREATE PROCEDURE usp_GetErrorInfo  
AS  
SELECT  
    ERROR_NUMBER() AS [����� ������]  
    ,ERROR_SEVERITY() AS [������� ��������� ������]  
    ,ERROR_STATE() AS [����� ������]
    ,ERROR_PROCEDURE() AS [��� ���������]  
    ,ERROR_LINE() AS [������ �� ������� ������]  
    ,ERROR_MESSAGE() AS [��������� �� ������];  
GO  
  
BEGIN TRY  
    -- Generate divide-by-zero error.  
    SELECT 1/0;  
END TRY  
BEGIN CATCH  
    -- Execute error retrieval routine.  
    EXECUTE usp_GetErrorInfo;  
END CATCH;   