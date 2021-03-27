USE [MAV_UNIVERTMP];
-- task 1
-- Транзакция − это механизм базы данных, позволяющий таким образом объединять несколько операторов, изменяющих
-- базу данных, чтобы при выполнении этой совокупности операторов они или все выполнились или все не выполнились.
-- 1) атомарность (операторы изменения БД, включенные в транзакцию, либо выполнятся все, либо не выполнится ни один); 
-- 2) согласованность (транзакция должна фиксировать новое согласованное состояние БД);
-- 3) изолированность (отсутствие взаимного влияния параллельных транзакций на результаты их выполнения); 
-- 4) долговечность (изменения в БД, выполненные и зафиксированные транзакцией, могут быть отменены только с помощью новой транзакции).
set nocount on;
drop table ExampleTable; 
declare @c int, @flag char = 'c'; -- commit или rollback?
SET IMPLICIT_TRANSACTIONS ON -- включ. режим неявной транзакции
CREATE table ExampleTable(K int); -- начало транзакции
	INSERT ExampleTable values(1), (2), (3);
	SET @c = (SELECT count(*) FROM ExampleTable);
	PRINT 'количество строк в таблице X: ' +cast(@c as varchar(3));
	if @flag = 'c' commit; -- завершение транзакции: фиксация
	else rollback; -- завершение транзакции: откат
SET IMPLICIT_TRANSACTIONS OFF; -- выключ. режим неявной транзакции

if exists(select * from SYS.OBJECTS -- таблица X есть?
where OBJECT_ID= object_id(N'DBO.ExampleTable'))
print 'таблица X есть';
else print 'таблицы X нет'
GO;

-- task 2

begin try 
	begin tran
		insert [STUDENT]([IDSTUDENT], [IDGROUP], [NAME]) 
		values (555, 1, 'Mukovozchik A.V.'),
		(555, 1, 'Mukovozchik A.V.');
		commit tran;
	end try
	begin catch 
		print 'ошибка: ' + case
		when error_number() = 2627 and patindex('%PK_STUDENT%', error_message()) > 0
		then 'дублирование студента '
		else 'неизвестная ошибка ' + CHAR(13) + cast(error_number() as varchar(5)) + '. ' + error_message()
		end;
		if @@TRANCOUNT > 0 rollback tran;
	end catch;
GO;

-- task 3

-- может быть использован оператор SAVE TRANSACTION, формирующий контрольную точку транзакции
declare @point varchar(32);
begin try
	begin tran
	set @point = 'p0'; save tran @point;
	print 'пройден чек-поинт 0' + CHAR(13);
	set @point = 'p1'; save tran @point;
	print 'пройден чек-поинт 1' + CHAR(13);
	insert [STUDENT]([IDSTUDENT], [IDGROUP], [NAME]) 
		values (556, 1, 'Mukovozchik A.V.');
	set @point = 'p2'; save tran @point;
	print 'пройден чек-поинт 2' + CHAR(13);
	insert [STUDENT]([IDSTUDENT], [IDGROUP], [NAME]) 
		values (556, 1, 'Mukovozchik A.V.');
	commit tran;
end try
begin catch 
	print 'ошибка: ' + case
	when error_number() = 2627 and patindex('%PK_STUDENT%', error_message()) > 0
	then 'дублирование студента '
	else 'неизвестная ошибка ' + CHAR(13) + cast(error_number() as varchar(5)) + '. ' + error_message() + CHAR(13)
	end;
	if @@TRANCOUNT > 0
		begin 
			print 'контрольная точка: ' + @point;
			rollback tran @point;
		end;
end catch;
GO;

-- task 4

--- B --
begin transaction
select @@SPID
insert [STUDENT]([IDGROUP], [NAME], [STAMP]) 
	values (1, 'Кишкурно Д.В.', default);
select @@SPID,'insert Студент' 'результат',* from STUDENT
where [STUDENT].[NAME] like 'К%';
update [STUDENT] set [NAME] = 'Карпенкин Д.В.'
where [NAME] = 'Кишкурно Д.В.';
select @@SPID,'insert Студент' 'результат',* from STUDENT
where [STUDENT].[NAME] like 'К%';

set	transaction isolation level READ UNCOMMITTED
begin transaction
-------------------------- t1 ------------------
select @@SPID,'insert Студент' 'результат',* from STUDENT
where [STUDENT].[NAME] like 'К%';
select @@SPID,'update Студент' 'результат', [NAME], [IDGROUP] 
from [STUDENT] where [NAME] like 'К%';
commit;
-------------------------- t2 --------------------
rollback;
GO;

-- task 5

-- A ---
set transaction isolation level READ COMMITTED
begin transaction
select * from [STUDENT] where [NAME] like 'К%';
--- B ---
begin transaction
-------------------------- t1 ------------------
 update [STUDENT] set [NAME] = 'Крученок Д.В.'
 where [NAME] like 'Карпенкин%'

-------------------------- t2 -----------------
select 'update Студент' 'результат', *
from [STUDENT] where [NAME] like 'Крученок Д.В.';
rollback;
GO;

-- task 6
delete [STUDENT] where [NAME] = 'Кишкурно Д.В.';

-- A ---
set transaction isolation level REPEATABLE READ
begin transaction
select * from [STUDENT] where [NAME] like 'К%';
--- B ---
begin transaction
-------------------------- t1 --------------------
insert [STUDENT]([IDGROUP], [NAME], [STAMP]) 
	values (1, 'Кишкурно Д.В.', default);
commit;
-------------------------- t2 -----------------
select case
when [NAME] = 'Кишкурно Д.В.' then 'insert Заказы' else ' '
end 'результат', [NAME] from [STUDENT] where [NAME] like 'К%';
commit;

GO;

-- task 7
-- A ---
set transaction isolation level SERIALIZABLE
begin transaction
delete [STUDENT] where [NAME] like 'Карпенкин%';
insert [STUDENT]([IDGROUP], [NAME], [STAMP]) 
	values (1, 'Карпенкн Д.В.', default);
 update [STUDENT] set [NAME] = 'Кишкурно Д.В.' where [NAME] = 'Карпенкн Д.В.';
 select * from [STUDENT] where [NAME] = 'Карпенкн Д.В.';
 -------------------------- t2 ------------------
commit tran;
 --- B ---
begin transaction
delete [STUDENT] where [NAME] = 'Карпенкн Д.В.';
insert [STUDENT]([IDGROUP], [NAME], [STAMP]) 
	values (1, 'Карпенкн Д.В.', default);
 update [STUDENT] set [NAME] = 'Кишкурно Д.В.' where [NAME] = 'Карпенкн Д.В.';
 select * from [STUDENT] where [NAME] = 'Кишкурно Д.В.';
-------------------------- t1 -----------------
select * from [STUDENT] where [NAME] = 'Кишкурно Д.В.';
commit;
select * from [STUDENT] where [NAME] = 'Кишкурно Д.В.';

GO;

-- task 8
begin tran -- внешняя транзакция
	insert [STUDENT]([IDGROUP], [NAME], [STAMP]) values (1, 'Карпенкн Д.В.', default);
	begin tran -- внутренняя транзакция
		update [STUDENT] set [NAME] = 'Кишкурно Д.В.' where [NAME] like 'Карпенкин%';
		commit; -- внутренняя транзакция
	if @@TRANCOUNT > 0 
	begin
		print 'exception';
		rollback; -- внешняя транзакция
	end;
select (select count(*) from [STUDENT] where [NAME] = 'Кишкурно Д.В.') 'Студенты'