use MAV_UNIVERTMP;
-- task 1
-- � ������� ��������� ��������� SP_HELPINDEX ����� �������� �������� ��������, ��������� � �������� ��������
exec SP_HELPINDEX AUDITORIUM;
exec SP_HELPINDEX AUDITORIUM_TYPE;
exec SP_HELPINDEX FACULTY;
exec SP_HELPINDEX GROUPS;
exec SP_HELPINDEX PROFESSION;
exec SP_HELPINDEX PULPIT;
exec SP_HELPINDEX STUDENT;
exec SP_HELPINDEX SUBJECTS;
exec SP_HELPINDEX TEACHER;

-- ������ � ��� ������ ���� ������, ����������� �������� ����� � ������������ �������, ��� ��� ��� ���� ������ ������������ � ���� ����������������� ��������� ������ ������.

CREATE table #EXPLRE
( 
	TIND int,
	TFIELD varchar(100)
);

set nocount on;
DECLARE @i int = 0;
WHILE @i < 1000
	BEGIN 
		INSERT #EXPLRE(TIND, TFIELD)
			values(floor(20000*rand()), '������');
		IF(@i%100 = 0) print @i;
		SET @i = @i + 1;
	END;

SELECT * FROM #EXPLRE where TIND between 1500 and 2500 order by TIND -- �� ������������� ������� ��������� ������� 0,017. ����� ������������� ������� 0,003
checkpoint; --�������� ��
DBCC DROPCLEANBUFFERS; --�������� �������� ���
-- ���������������� ������� ��������� ����������� � ������������ �� ���������� ������������� ��������. � ������� ����� ���� ������ ���� ���������������� ������.
-- Display Estimated Execution Plan
CREATE clustered index #EXPLRE_CL on #EXPLRE(TIND asc);
DROP index #EXPLRE_CL on #EXPLRE;
GO;

-- task 2
-- ������������������ ������� �� ������ �� ���������� ������� ����� � �������.
CREATE table #EX
( 
	TKEY int,
	CC int identity(1, 1),
	TF varchar(100)
);
set nocount on;
 declare @i int = 0;
 while @i < 20000 -- ���������� � ������� 20000 �����
 begin
 INSERT #EX(TKEY, TF) values(floor(30000*RAND()), '������ ');
 set @i = @i + 1;
 end;

 SELECT count(*)[���������� �����] from #EX;
 SELECT * from #EX -- ��������� ������� 0,07
 -- MSS ��������� ��������� ������� �� ���������� �������� � ����� ������� ���������� ����������.
 CREATE index #EX_NONCLU on #EX(TKEY, CC)
 -- ���� ������ �� ����������� ������������� �� ��� ����������, �� ��� ����������
 -- ����� ������� #EX, � ��� ����� ���������, ��������� ����� ��������� ��������:
 SELECT * from #EX where TKEY > 1500 and CC < 4500; -- ��������� ������� 0,07
 SELECT * from #EX order by TKEY, CC -- ��������� ������� 1,4
 -- ��, ���� ���� �� ���� �� ������������� �������� ������������� (������ ���� ��������), �� ����������� �������� ������. ��� ����� ���������, �������� ������:
 SELECT * from #EX where TKEY = 15 and CC > 3 -- ��������� ������� 0,007
 GO;

 -- task 3
 -- ������������������ ������ �������� ������� ��������� �������� � ������ ��������� ������ �������� ������ ��� ���������� ��������������� ��������.
 CREATE index #EX_TKEY_X on #EX(TKEY)INCLUDE (CC) -- ������ �������� �������� ������� ��
 DROP index #EX_TKEY_X on #EX;
 SELECT CC from #EX where TKEY>15000 -- 0,034 ��������� �������
GO;
 -- task 4
SELECT TKEY from #EX where TKEY between 5000 and 19999; -- 0,034 ��������� ������� � �������� � 0,78 ��� �������
SELECT TKEY from #EX where TKEY>15000 and TKEY < 20000 -- 0,013 ��������� ������� � �������� � 0,78 ��� �������
SELECT TKEY from #EX where TKEY=17000 -- 0,0032 ��������� ������� � �������� � 0,78 ��� �������

CREATE index #EX_WHERE on #EX(TKEY) where (TKEY>=15000 and TKEY < 20000);
DROP index #EX_WHERE on #EX; 
DROP index #EX_TKEY_X on #EX; 
DROP index #EX_NONCLU on #EX;
GO;

-- task 5
CREATE index #EX_TKEY ON #EX(TKEY);
-- ������������ 
SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id= ii.object_id and ss.index_id = ii.index_id
WHERE name is not null; -- ��������� ������� 3,4 

INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX; -- ��� ������� 0,64 � 0,81 � ��������

ALTER index #EX_TKEY on #EX reorganize; -- ������������� ����������� ������������ �� ������ ������
ALTER index #EX_TKEY on #EX rebuild with (online = off); -- ����������� ���������� ���� ������������ �� ����
DROP index #EX_TKEY ON #EX;
GO;

-- task 6
DROP index #EX_TKEY on #EX;
CREATE index #EX_TKEY on #EX(TKEY) with (fillfactor = 65); -- �������� FILLFACTOR ��������� ������� ���������� ��������� ������� ������� ������.
-- ����� ���������� ������ ������������ � 65% ���������� �����������
-- ����� ���������� ����� � ������� #EX ����� ������� ������� ������������:
 INSERT top(50)percent INTO #EX(TKEY, TF)
 SELECT TKEY, TF FROM #EX;

SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
 FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
 OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss JOIN sys.indexes ii
 ON ss.object_id= ii.object_id and ss.index_id = ii.index_id
 WHERE name is not null;
 GO;