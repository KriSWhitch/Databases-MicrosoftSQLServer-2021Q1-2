use [MAV_UNIVERTMP];
GO
-- task 1
DROP FUNCTION [COUNT_STUDENTS];
GO

CREATE FUNCTION [COUNT_STUDENTS](@f varchar(20)) returns int as 
BEGIN
	declare @rc int = 0;
	set @rc = (SELECT count(STUDENT.IDSTUDENT) [Кол-во студентов] FROM [STUDENT] inner join [GROUPS] 
		ON [STUDENT].[IDGROUP] = [GROUPS].[IDGROUP] inner join [FACULTY]
		ON [GROUPS].[FACULTY]  = [FACULTY].[FACULTY] WHERE [FACULTY].FACULTY like @f GROUP BY [FACULTY].FACULTY);
		return @rc;
END;
DECLARE @ff int = dbo.[COUNT_STUDENTS]('Л%');
print 'Количество студентов: ' + cast(@ff as varchar(50));
GO
-- task 2
DROP FUNCTION FSUBJECTS;
GO

CREATE FUNCTION FSUBJECTS(@p varchar(20)) returns varchar(300)
AS
BEGIN
	declare @dis varchar(20);
	declare @d varchar(300)= 'Дисциплины: ';
	declare Subjects CURSOR LOCAL
	for select SUBJECTS.SUBJECTS from SUBJECTS
	where SUBJECTS.PULPIT = @p;
	open Subjects;
	fetch Subjects into @dis; 
	while @@fetch_status = 0
	begin
		set @d = @d + rtrim(@dis) + ', ';
		FETCH Subjects into @dis;
	end;
	return @d;
END; 
GO

SELECT PULPIT.PULPIT, dbo.FSUBJECTS(PULPIT.PULPIT) FROM PULPIT;
GO

 -- task 3
DROP FUNCTION FFACPUL;
GO

CREATE FUNCTION FFACPUL(@f varchar(50), @p varchar(50)) returns table
AS RETURN
	SELECT [FACULTY].[FACULTY], [PULPIT].[PULPIT] FROM  [FACULTY] left outer join [PULPIT]
	ON [FACULTY].[FACULTY] = [PULPIT].[FACULTY] WHERE [FACULTY].[FACULTY] = ISNULL(@f, [FACULTY].[FACULTY]) and [PULPIT].[PULPIT] = ISNULL(@p, [PULPIT].[PULPIT]);
GO

SELECT * FROM dbo.FFACPUL(NULL,NULL);
SELECT * FROM dbo.FFACPUL('ЛХФ',NULL);
SELECT * FROM dbo.FFACPUL(NULL,'ЛВ');
SELECT * FROM dbo.FFACPUL('ЛХФ','ЛВ');
GO
-- task 4
CREATE FUNCTION FCTEACHER(@p varchar(50)) returns int
AS BEGIN
	declare @rc int =(SELECT count(*) from [TEACHER] WHERE [TEACHER].[PULPIT] = ISNULL(@p, [TEACHER].[PULPIT]));
	return @rc;
END;
GO

SELECT [PULPIT].[PULPIT], dbo.FCTEACHER([PULPIT].[PULPIT]) [Кол-во преподавателей] FROM [PULPIT];
SELECT dbo.FCTEACHER(NULL) [Всего преподавателей];
GO
-- task 6
DROP function FACULTY_REPORT;
GO
CREATE function FACULTY_REPORT(@c int) returns @fr table
 ( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп] int,
 [Количество студентов] int, [Количество специальностей] int )
as begin
 declare cc CURSOR static for
 select FACULTY from FACULTY
 where dbo.[COUNT_STUDENTS](FACULTY) > @c;
 declare @f varchar(30);
 open cc;
 fetch cc into @f;
 while @@fetch_status = 0
 begin
 insert @fr values( @f, (select count(PULPIT)from PULPIT where FACULTY = @f),
 (select count(IDGROUP)from GROUPS where FACULTY = @f), dbo.[COUNT_STUDENTS](@f),
 (select count(PROFESSION)from PROFESSION where FACULTY = @f) );
 fetch cc into @f;
 end;
 return;
end;
GO

SELECT * FROM FACULTY_REPORT(10);