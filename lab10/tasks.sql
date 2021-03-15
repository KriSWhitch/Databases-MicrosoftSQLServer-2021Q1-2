use MAV_UNIVERTMP;
-- task 1
exec SP_HELPINDEX AUDITORIUM;
exec SP_HELPINDEX AUDITORIUM_TYPE;
exec SP_HELPINDEX FACULTY;
exec SP_HELPINDEX GROUPS;
exec SP_HELPINDEX PROFESSION;
exec SP_HELPINDEX PULPIT;
exec SP_HELPINDEX STUDENT;
exec SP_HELPINDEX SUBJECTS;
exec SP_HELPINDEX TEACHER;

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
			values(floor(20000*rand()), 'строка');
		IF(@i%100 = 0) print @i;
		SET @i = @i + 1;
	END;

SELECT * FROM #EXPLRE where TIND between 1500 and 2500 order by TIND
checkpoint; --фиксация БД
DBCC DROPCLEANBUFFERS; --очистить буферный кэш
CREATE clustered index #EXPLRE_CL on #EXPLRE(TIND asc);-- task 2CREATE table #EX
( 
	TKEY int,
	CC int identity(1, 1),
	TF varchar(100)
);
set nocount on;
 declare @i int = 0;
 while @i < 20000 -- добавление в таблицу 20000 строк
 begin
 INSERT #EX(TKEY, TF) values(floor(30000*RAND()), 'строка ');
 set @i = @i + 1;
 end;

 SELECT count(*)[количество строк] from #EX;
 SELECT * from #EX
 CREATE index #EX_NONCLU on #EX(TKEY, CC) SELECT * from #EX where TKEY > 1500 and CC < 4500;
 SELECT * from #EX order by TKEY, CC SELECT * from #EX where TKEY = 556 and CC > 3 -- task 3 CREATE index #EX_TKEY_X on #EX(TKEY)INCLUDE (CC) SELECT CC from #EX where TKEY>15000 -- task 4SELECT TKEY from #EX where TKEY between 5000 and 19999;
SELECT TKEY from #EX where TKEY>15000 and TKEY < 20000
SELECT TKEY from #EX where TKEY=17000CREATE index #EX_WHERE on #EX(TKEY) where (TKEY>=15000 and TKEY < 20000); -- task 5CREATE index #EX_TKEY ON #EX(TKEY);SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id= ii.object_id and ss.index_id = ii.index_id
WHERE name is not null;

INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;

ALTER index #EX_TKEY on #EX reorganize;ALTER index #EX_TKEY on #EX rebuild with (online = off);-- task 6DROP index #EX_TKEY on #EX;
CREATE index #EX_TKEY on #EX(TKEY)
	with (fillfactor = 65);
-- После добавления строк в таблицу #EX можно оценить уровень фрагментации:
 INSERT top(50)percent INTO #EX(TKEY, TF)
 SELECT TKEY, TF FROM #EX;

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
 FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
 OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss JOIN sys.indexes ii
 ON ss.object_id= ii.object_id and ss.index_id = ii.index_id
 WHERE name is not null;
