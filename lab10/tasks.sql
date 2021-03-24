use MAV_UNIVERTMP;
-- task 1
-- С помощью системной процедуры SP_HELPINDEX можно получить перечень индексов, связанных с заданной таблицей
exec SP_HELPINDEX AUDITORIUM;
exec SP_HELPINDEX AUDITORIUM_TYPE;
exec SP_HELPINDEX FACULTY;
exec SP_HELPINDEX GROUPS;
exec SP_HELPINDEX PROFESSION;
exec SP_HELPINDEX PULPIT;
exec SP_HELPINDEX STUDENT;
exec SP_HELPINDEX SUBJECTS;
exec SP_HELPINDEX TEACHER;

-- Индекс – это объект базы данных, позволяющий ускорить поиск в определенной таблице, так как при этом данные организуются в виде сбалансированного бинарного дерева поиска.

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

SELECT * FROM #EXPLRE where TIND between 1500 and 2500 order by TIND -- до использования индекса стоимость запроса 0,017. После использования индекса 0,003
checkpoint; --фиксация БД
DBCC DROPCLEANBUFFERS; --очистить буферный кэш
-- Кластеризованные индексы физически упорядочены в соответствии со значениями индексируемых столбцов. В таблице может быть только один кластеризованный индекс.
-- Display Estimated Execution Plan
CREATE clustered index #EXPLRE_CL on #EXPLRE(TIND asc);
DROP index #EXPLRE_CL on #EXPLRE;
GO;

-- task 2
-- Некластеризованные индексы не влияют на физический порядок строк в таблице.
CREATE table #EX
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
 SELECT * from #EX -- стоимость запроса 0,07
 -- MSS допускает создавать индексы по нескольким столбцам – такие индексы называются составными.
 CREATE index #EX_NONCLU on #EX(TKEY, CC)
 -- Этот индекс не применяется оптимизатором ни при фильтрации, ни при сортировке
 -- строк таблицы #EX, в чем можно убедиться, посмотрев планы следующих запросов:
 SELECT * from #EX where TKEY > 1500 and CC < 4500; -- стоимость запроса 0,07
 SELECT * from #EX order by TKEY, CC -- стоимость запроса 1,4
 -- Но, если хотя бы одно из индексируемых значений зафиксировать (задать одно значение), то оптимизатор применит индекс. Это можно проверить, выполнив запрос:
 SELECT * from #EX where TKEY = 15 and CC > 3 -- стоимость запроса 0,007
 GO;

 -- task 3
 -- Некластеризованный индекс покрытия запроса позволяет включить в состав индексной строки значения одного или нескольких неиндексируемых столбцов.
 CREATE index #EX_TKEY_X on #EX(TKEY)INCLUDE (CC) -- индекс включает значение столбца СС
 DROP index #EX_TKEY_X on #EX;
 SELECT CC from #EX where TKEY>15000 -- 0,034 стоимость запроса
GO;
 -- task 4
SELECT TKEY from #EX where TKEY between 5000 and 19999; -- 0,034 стоимость запроса с индексом и 0,78 без индекса
SELECT TKEY from #EX where TKEY>15000 and TKEY < 20000 -- 0,013 стоимость запроса с индексом и 0,78 без индекса
SELECT TKEY from #EX where TKEY=17000 -- 0,0032 стоимость запроса с индексом и 0,78 без индекса

CREATE index #EX_WHERE on #EX(TKEY) where (TKEY>=15000 and TKEY < 20000);
DROP index #EX_WHERE on #EX; 
DROP index #EX_TKEY_X on #EX; 
DROP index #EX_NONCLU on #EX;
GO;

-- task 5
CREATE index #EX_TKEY ON #EX(TKEY);
-- Фрагментация 
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
JOIN sys.indexes ii on ss.object_id= ii.object_id and ss.index_id = ii.index_id
WHERE name is not null; -- стоимость запроса 3,4 

INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX; -- без индекса 0,64 и 0,81 с индексом

ALTER index #EX_TKEY on #EX reorganize; -- реорганизация освобождает фрагментацию от лишних ссылок
ALTER index #EX_TKEY on #EX rebuild with (online = off); -- перестройка сбрасывает нашу фрагментацию до нуля
DROP index #EX_TKEY ON #EX;
GO;

-- task 6
DROP index #EX_TKEY on #EX;
CREATE index #EX_TKEY on #EX(TKEY) with (fillfactor = 65); -- Параметр FILLFACTOR указывает процент заполнения индексных страниц нижнего уровня.
-- после достижения уровня фрагментации в 65% запустится перестройка
-- после добавления строк в таблицу #EX можно оценить уровень фрагментации:
 INSERT top(50)percent INTO #EX(TKEY, TF)
 SELECT TKEY, TF FROM #EX;

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
 FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
 OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss JOIN sys.indexes ii
 ON ss.object_id= ii.object_id and ss.index_id = ii.index_id
 WHERE name is not null;
 GO;