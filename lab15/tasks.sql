use [MAV_UNIVERTMP];
GO

-- task 1
CREATE TABLE TR_AUDIT (
	ID int identity,
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')), -- dml-оператор
	TRNAME varchar(50), -- триггер
	CC varchar(300)
)

DROP TRIGGER TRIG_TEACHER_INS;
GO

CREATE TRIGGER TRIG_TEACHER_INS on [TEACHER] after INSERT AS 
DECLARE @a1 varchar(20), @a2 varchar(30), @a3 varchar(30), @in varchar(300);

print 'Операция вставки';
set @a1 = (SELECT TEACHER FROM INSERTED);
set @a2 = (SELECT TEACHER_NAME FROM INSERTED);
set @a3 = (SELECT PULPIT FROM INSERTED);
set @in = @a1 + ' ' + cast(@a2 as varchar(20)) + ' ' + cast(@a3 as varchar(20));
insert into TR_AUDIT(STMT, TRNAME, CC) values ('INS', 'TRIG_TEACHER_INS', @in);
return;
GO

insert into TEACHER(TEACHER, TEACHER_NAME, PULPIT) values ('МАВ', 'Муковозчик А. В.', 'ИСиТ');
select * from TR_AUDIT;
GO

-- task 2

DROP TRIGGER TRIG_TEACHER_DEL;
GO

CREATE TRIGGER TRIG_TEACHER_DEL on [TEACHER] after DELETE AS 
DECLARE @a1 varchar(20), @in varchar(300);

print 'Операция удаления';
set @a1 = (SELECT TEACHER FROM DELETED);
set @in = @a1;
insert into TR_AUDIT(STMT, TRNAME, CC) values ('DEL', 'TRIG_TEACHER_DEL', @in);
return;
GO

DELETE TEACHER WHERE TEACHER like 'МАВ%';
select * from TR_AUDIT;
GO

-- task 3

DROP TRIGGER TRIG_TEACHER_UPD;
GO

CREATE TRIGGER TRIG_TEACHER_UPD on [TEACHER] FOR UPDATE AS 
DECLARE @a1 varchar(20), @a2 varchar(30), @a3 varchar(30), @b1 varchar(20), @b2 varchar(30), @b3 varchar(30), @in varchar(300);

print 'Операция обновления';
set @a1 = (SELECT TEACHER FROM DELETED);
set @a2 = (SELECT TEACHER_NAME FROM DELETED);
set @a3 = (SELECT PULPIT FROM DELETED);
set @b1 = (SELECT TEACHER FROM INSERTED);
set @b2 = (SELECT TEACHER_NAME FROM INSERTED);
set @b3 = (SELECT PULPIT FROM INSERTED);
set @in = 'BEFORE: ' + @a1 + ' ' + cast(@a2 as varchar(20)) + ' ' + cast(@a3 as varchar(20)) + 'AFTER: ' + @b1 + ' ' + cast(@b2 as varchar(20)) + ' ' + cast(@b3 as varchar(20));
insert into TR_AUDIT(STMT, TRNAME, CC) values ('UPD', 'TRIG_TEACHER_UPD', @in);
return;
GO

UPDATE TEACHER SET TEACHER = 'МАВ<3' WHERE TEACHER like 'МАВ%';
select * from TR_AUDIT;
GO

-- task 4

create trigger TRIG_Teacher on TEACHER after INSERT, DELETE, UPDATE
as declare @a1 varchar(20), @a2 varchar(30), @a3 varchar(30), @in varchar(300);
declare @ins int = (select count(*) from inserted),
 @del int = (select count(*) from deleted);
if @ins > 0 and @del = 0
begin
 print 'Событие: INSERT';
 set @a1 = (select TEACHER from INSERTED);
 set @a2 = (select TEACHER_NAME from INSERTED);
 set @a3 = (select PULPIT from INSERTED);
 set @in = @a1+' '+cast(@a2 as varchar(20))+' '+cast(@a3 as varchar(20));
 insert into TR_AUDIT(STMT, TRNAME,CC) values('INS', 'TRIG_Teacher', @in);
end;
else
if @ins = 0 and @del > 0 
begin
 print 'Событие: DELETE';
 set @a1 = (select TEACHER from deleted);
 set @a2 = (select TEACHER_NAME from deleted);
 set @a3 = (select PULPIT from deleted);
 set @in = @a1+' '+cast(@a2 as varchar(20))+' '+cast(@a3 as varchar(20));
 insert into TR_AUDIT(STMT, TRNAME,CC) values('DEL', 'TRIG_Teacher', @in);
end;
else
if @ins > 0 and @del > 0
begin
 print 'Событие: UPDATE';
 set @a1 = (select TEACHER from inserted);
 set @a2 = (select TEACHER_NAME from inserted);
 set @a3 = (select PULPIT from inserted);
 set @in = @a1+' '+cast(@a2 as varchar(20))+' '+cast(@a3 as varchar(20));
 set @a1 = (select TEACHER from deleted);
 set @a2 = (select TEACHER_NAME from deleted);
 set @a3 = (select PULPIT from deleted);
 set @in = @a1+' '+cast(@a2 as varchar(20))+' '+cast(@a3 as
varchar(20))+' '+@in;
 insert into TR_AUDIT(STMT, TRNAME,CC) values('UPD', 'TRIG_Teacher', @in);
end;
return; 
GO

insert into TEACHER(TEACHER, TEACHER_NAME, PULPIT) values ('МАВ', 'Муковозчик А. В.', 'ИСиТ');
select * from TR_AUDIT;

DELETE TEACHER WHERE TEACHER like 'МАВ%';
select * from TR_AUDIT;

DELETE TEACHER WHERE TEACHER like 'МАВ<3%';
select * from TR_AUDIT;

UPDATE TEACHER SET TEACHER = 'МАВ<3' WHERE TEACHER like 'МАВ%';
select * from TR_AUDIT;
GO
-- task 5, 6

create trigger AUD_AFTER_UPDA on TEACHER after UPDATE
 as print 'AUD_AFTER_UPDATE_A';
return;
go
create trigger AUD_AFTER_UPDB on TEACHER after UPDATE
 as print 'AUD_AFTER_UPDATE_B';
return;
go
create trigger AUD_AFTER_UPDC on TEACHER after UPDATE
 as print 'AUD_AFTER_UPDATE_C';
return;
go 

select t.name, e.type_desc
 from sys.triggers t join sys.trigger_events e
 on t.object_id = e.object_id
 where OBJECT_NAME(t.parent_id)= 'TEACHER' and
 e.type_desc = 'UPDATE' ; 
 go
 -- task 7, 8
 CREATE TRIGGER FAC_INSTED_OF ON FACULTY instead of DELETE as raiserror('Удаление запрещено!', 10, 1);
 return;
 GO
 delete from FACULTY where FACULTY = 'ИСиТ';
 GO
 -- task 9
 create trigger DDL_PRODAJI on database
 for DDL_DATABASE_LEVEL_EVENTS as
 declare @t varchar(50)= EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
 declare @t1 varchar(50)= EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
 declare @t2 varchar(50)= EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');
 if @t1 = 'FACULTY'
begin
 print 'Тип события: '+@t;
 print 'Имя объекта: '+@t1;
 print 'Тип объекта: '+@t2;
 raiserror(N'операции с таблицей FACULTY запрещены', 16, 1);
 rollback;
 end;

 alter table FACULTY add XXX int;
