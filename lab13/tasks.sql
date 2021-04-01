use [MAV_UNIVERTMP];
GO;

-- task 1
DROP PROCEDURE dbo.PSUBJECT;
CREATE PROCEDURE PSUBJECT AS SELECT [SUBJECTS].[SUBJECTS] ���, [SUBJECTS].[SUBJECT_NAME] ����������, [SUBJECTS].[PULPIT] ������� FROM [SUBJECTS];
EXEC PSUBJECT;
GO;

-- task2
ALTER PROCEDURE PSUBJECT @p varchar(20), @c int output
AS BEGIN
	DECLARE @f int = (SELECT count(*) FROM [SUBJECTS]);
	SELECT [SUBJECTS].[SUBJECTS] ���, [SUBJECTS].[SUBJECT_NAME] ����������, [SUBJECTS].[PULPIT] ������� FROM [SUBJECTS] WHERE [SUBJECTS].[PULPIT] = @p;
	set @c = @@ROWCOUNT;
	return @f;
END;
declare @k int = 0, @r int = 0, @pp varchar(20) = '����';
exec @k = PSUBJECT @p = @pp,  @c = @r output;
print '���-�� ���������: ' +cast(@k as varchar(4));
print '���-�� ��������� �� �������� ������� - '+ @pp + ': ' +cast(@r as varchar(4));
GO;
-- task 3
ALTER PROCEDURE PSUBJECT @p varchar(20)
AS BEGIN
	DECLARE @f int = (SELECT count(*) FROM [SUBJECTS]);
	SELECT [SUBJECTS].[SUBJECTS] ���, [SUBJECTS].[SUBJECT_NAME] ����������, [SUBJECTS].[PULPIT] ������� FROM [SUBJECTS] WHERE [SUBJECTS].[PULPIT] = @p;
END;
DROP TABLE #SUBJECTS;
CREATE TABLE #SUBJECTS([SUBJECTS] char(10), [SUBJECT_NAME] varchar(100), [PULPIT] char(20));
INSERT #SUBJECTS exec PSUBJECT @p = '����';
SELECT * FROM #SUBJECTS;
GO;

-- task 4
CREATE PROCEDURE PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10)
AS BEGIN TRY
	insert into [AUDITORIUM] ([AUDITORIUM].[AUDITORIUM], [AUDITORIUM].[AUDITORIUM_NAME], [AUDITORIUM].[AUDITORIUM_CAPACITY], [AUDITORIUM].[AUDITORIUM_TYPE])
		values(@a, @n, @c, @t);
		return 1;
	END TRY
	BEGIN CATCH
		print '����� ������: ' +cast(error_number() as varchar(6));
		print '���������: ' + error_message();
		print '�������: ' +cast(error_severity() as varchar(6));
		if ERROR_PROCEDURE() is not null print '��� ���������: ' + error_procedure();
		return -1;
	END CATCH;
DELETE AUDITORIUM WHERE [AUDITORIUM].[AUDITORIUM] = '403-5';
EXEC PAUDITORIUM_INSERT '403-5', '��������� �������', 50, '��';
GO;

-- task 5
CREATE PROCEDURE SUBJECT_REPORT @p char(10)
AS BEGIN TRY
		 declare @rs int = 0;
		 declare @sub char(10), @res varchar(1000)= ' ';
		 declare SubCur CURSOR for
		 select [SUBJECTS].[SUBJECTS] from [SUBJECTS] where [SUBJECTS].[PULPIT] = @p;
		 if not exists(select [SUBJECTS].[SUBJECTS] from [SUBJECTS] where [SUBJECTS].[PULPIT] = @p) raiserror('������ � ����������', 11, 1);
		 else 
			open SubCur;
			fetch SubCur into @sub;
			print '���������� �� ������� ' +@p +': ';
			set @res = @res + RTRIM(@sub)
			set @rs = @rs + 1;
			if (@@FETCH_STATUS = 0) fetch SubCur into @sub;
			while @@FETCH_STATUS = 0
			begin
				set @res = @res + ',' + RTRIM(@sub);
				set @rs = @rs + 1;
				fetch SubCur into @sub;
			end;
			print @res;
			close SubCur;
			deallocate SubCur;
			return @rs;
	END TRY
	BEGIN CATCH
		print '����� ������: ' +cast(error_number() as varchar(6));
		print '���������: ' + error_message();
		print '�������: ' +cast(error_severity() as varchar(6));
		if ERROR_PROCEDURE() is not null print '��� ���������: ' + error_procedure();
		return @rs;
	END CATCH;
EXEC SUBJECT_REPORT '����';
GO;

-- task 6
CREATE PROCEDURE PAUDITORIUM_INSERTX @a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(50)
AS BEGIN TRY
	set transaction isolation level SERIALIZABLE
	begin tran
	insert into [AUDITORIUM_TYPE] ([AUDITORIUM_TYPE].[AUDITORIUM_TYPE], [AUDITORIUM_TYPE].[AUDITORIUM_TYPENAME])
		values (@t, @tn);
	insert into [AUDITORIUM] ([AUDITORIUM].[AUDITORIUM], [AUDITORIUM].[AUDITORIUM_NAME], [AUDITORIUM].[AUDITORIUM_CAPACITY], [AUDITORIUM].[AUDITORIUM_TYPE])
		values(@a, @n, @c, @t);
	commit tran;
	return 1;
	END TRY
	BEGIN CATCH
		print '����� ������: ' +cast(error_number() as varchar(6));
		print '���������: ' + error_message();
		print '�������: ' +cast(error_severity() as varchar(6));
		if ERROR_PROCEDURE() is not null print '��� ���������: ' + error_procedure();
		if @@trancount > 0 rollback tran ;
		return -1;
	END CATCH;
DELETE AUDITORIUM WHERE [AUDITORIUM].[AUDITORIUM] = '403-5';
DELETE [AUDITORIUM_TYPE] WHERE [AUDITORIUM_TYPE].[AUDITORIUM_TYPENAME] = '���������� �������';
EXEC PAUDITORIUM_INSERTX '403-5', '��������� �������', 50, '��-�', '���������� �������';
GO;