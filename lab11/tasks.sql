USE [MAV_UNIVERTMP];
GO

-- task 1
DECLARE @ds varchar(50), @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR 
FOR SELECT [SUBJECTS].SUBJECT_NAME FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like '����';
OPEN ISITSubjects;
	FETCH ISITSubjects into @ds;
	PRINT '���������� �� ������� ����: ';
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @d = @d + rtrim(@ds) + ', ';
			FETCH ISITSubjects INTO @ds;
		END;
	PRINT @d;
CLOSE ISITSubjects;
DEALLOCATE ISITSubjects;
GO

-- task 2
-- ��������� ������
DECLARE @ds varchar(50), @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR LOCAL
FOR SELECT [SUBJECTS].SUBJECT_NAME FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like '����';
OPEN ISITSubjects;
	FETCH ISITSubjects into @ds;
	PRINT '���������� �� ������� ����: ';
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @d = @d + rtrim(@ds) + ', ';
			FETCH ISITSubjects INTO @ds;
		END;
	PRINT @d;
GO
-- ���������� ������ ( ������� �������� � ��������, �������� ����� �� ���������)
DECLARE @ds varchar(50), @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR GLOBAL
FOR SELECT [SUBJECTS].SUBJECT_NAME FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like '����';
OPEN ISITSubjects;
	FETCH ISITSubjects into @ds;
	PRINT '���������� �� ������� ����: ';
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @d = @d + rtrim(@ds) + ', ';
			FETCH ISITSubjects INTO @ds;
		END;
	PRINT @d;
CLOSE ISITSubjects;
DEALLOCATE ISITSubjects;
GO

-- task 3
-- ���� ������������ ������� � ���, ��� ������ �����-�� ������ ����� ��� ����
-- ��� ����������� ������� ���� ����� ����� � ������� �� ���������
-- ������������ ������ ����� �� ��������� ������ ������� �� �������� ��� 
-- ��������� ������������ �������
DECLARE @ds varchar(50), @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR LOCAL STATIC -- STATIC/DYNAMIC
FOR SELECT [SUBJECTS].SUBJECT_NAME FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like '����';
OPEN ISITSubjects;
PRINT '���������� ����� : '+cast(@@CURSOR_ROWS as varchar(5));
INSERT [SUBJECTS](SUBJECT_NAME, SUBJECTS, PULPIT)
		values('�������', '��', '����');
PRINT '���������� ����� : '+cast(@@CURSOR_ROWS as varchar(5));
DELETE [SUBJECTS] WHERE [SUBJECT_NAME] = '�������';
PRINT '���������� ����� : '+cast(@@CURSOR_ROWS as varchar(5));
	FETCH ISITSubjects into @ds;
	PRINT '���������� �� ������� ����: ';
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @d = @d + rtrim(@ds) + ', ';
			FETCH ISITSubjects INTO @ds;
		END;
	PRINT @d;
GO

-- task 4
-- ������ � ����������� ����������� � ����� ������ � �������������� �������
DECLARE @ds int, @d varchar(100);
DECLARE ISITSubjects CURSOR LOCAL DYNAMIC SCROLL
FOR SELECT ROW_NUMBER() over(ORDER BY [SUBJECTS].[SUBJECT_NAME]), [SUBJECTS].[SUBJECT_NAME] FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like '����';
OPEN ISITSubjects;
	FETCH ISITSubjects into @ds,@d;
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			print '������: ' + cast(@ds as varchar(3)) + '. ' + rtrim(@d);
			FETCH ISITSubjects INTO @ds, @d;
		END;
	CLOSE ISITSubjects;
GO

-- task 5
DECLARE @ds int, @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR LOCAL DYNAMIC
FOR SELECT ROW_NUMBER() over(ORDER BY [SUBJECTS].[SUBJECT_NAME]), [SUBJECTS].[SUBJECT_NAME] FROM [SUBJECTS] 
WHERE [SUBJECTS].PULPIT like '����' FOR UPDATE;
	OPEN ISITSubjects;
	FETCH ISITSubjects into @ds,@d;
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			print '������: ' + cast(@ds as varchar(3)) + '. ' + rtrim(@d);
			FETCH ISITSubjects INTO @ds, @d;
		END;
	CLOSE ISITSubjects;

	OPEN ISITSubjects;

	FETCH ISITSubjects INTO @ds,@d;
	DELETE [SUBJECTS] WHERE CURRENT OF ISITSubjects;

	WHILE @@FETCH_STATUS = 0
		BEGIN 
			print '������: ' + cast(@ds as varchar(3)) + '. ' + rtrim(@d);
			FETCH ISITSubjects INTO @ds, @d;
		END;

	CLOSE ISITSubjects;
GO

-- task 6
-- part 1
INSERT [PROGRESS] (IDSTUDENT, NOTE)
	values(1000, 2),
	(1001, 3),
	(1003, 1);

DECLARE @id int, @pr int;
DECLARE PROGRESS_CUR CURSOR LOCAL DYNAMIC
FOR SELECT [PROGRESS].[IDSTUDENT], [PROGRESS].[NOTE] FROM [PROGRESS] 
WHERE [PROGRESS].[NOTE] < 4 FOR UPDATE;
	OPEN PROGRESS_CUR;
	PRINT '���������� ����� : '+ cast(@@CURSOR_ROWS as varchar(5));
	FETCH PROGRESS_CUR INTO @id,@pr;
		WHILE @@FETCH_STATUS = 0
		BEGIN 
			DELETE [PROGRESS] WHERE CURRENT OF PROGRESS_CUR;
			FETCH PROGRESS_CUR INTO @id, @pr;
		END;
		PRINT '���������� ����� : '+ cast(@@CURSOR_ROWS as varchar(5));
	CLOSE PROGRESS_CUR;
GO

-- part 2
DECLARE @id int, @pr int;
DECLARE PROGRESS_CUR CURSOR LOCAL DYNAMIC
FOR SELECT [PROGRESS].[IDSTUDENT], [PROGRESS].[NOTE] FROM [PROGRESS] WHERE [PROGRESS].[IDSTUDENT] = 1001 FOR UPDATE;
	OPEN PROGRESS_CUR;
	PRINT '������ �������� � ������� 1001 �� �������: ';
	FETCH PROGRESS_CUR INTO @id,@pr;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			FETCH PROGRESS_CUR INTO @id, @pr;
			print '�������: ' + cast(@id as varchar(3)) + ' ����� ������ ' + rtrim(@pr);
		END;
	CLOSE PROGRESS_CUR;
	OPEN PROGRESS_CUR;
	PRINT '������ �������� � ������� 1001 ����� �������: ';
	FETCH PROGRESS_CUR INTO @id,@pr;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			FETCH PROGRESS_CUR INTO @id, @pr;
			IF (@pr < 9) UPDATE [PROGRESS] SET [NOTE] = [NOTE] + 1;
			ELSE UPDATE [PROGRESS] SET [NOTE] = [NOTE] - 1;
			PRINT '�������: ' + cast(@id as varchar(3)) + ' ����� ������ ' + rtrim(@pr);
		END;
	CLOSE PROGRESS_CUR;
GO