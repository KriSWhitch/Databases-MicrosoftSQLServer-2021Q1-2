USE [MAV_UNIVERTMP];
GO

-- task 1
DECLARE @ds varchar(50), @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR 
FOR SELECT [SUBJECTS].SUBJECT_NAME FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like 'ИСиТ';
OPEN ISITSubjects;
	FETCH ISITSubjects into @ds;
	PRINT 'Дисциплины на кафедре ИСиТ: ';
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
-- Локальный курсор
DECLARE @ds varchar(50), @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR LOCAL
FOR SELECT [SUBJECTS].SUBJECT_NAME FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like 'ИСиТ';
OPEN ISITSubjects;
	FETCH ISITSubjects into @ds;
	PRINT 'Дисциплины на кафедре ИСиТ: ';
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @d = @d + rtrim(@ds) + ', ';
			FETCH ISITSubjects INTO @ds;
		END;
	PRINT @d;
GO
-- Глобальный курсор ( требует закрытия и отчистки, является таким по стандарту)
DECLARE @ds varchar(50), @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR GLOBAL
FOR SELECT [SUBJECTS].SUBJECT_NAME FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like 'ИСиТ';
OPEN ISITSubjects;
	FETCH ISITSubjects into @ds;
	PRINT 'Дисциплины на кафедре ИСиТ: ';
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
-- Суть статического курсора в том, что выбрав какой-то список строк для него
-- при последующем измении этих строк набор в курсоре не изменится
-- Динамический курсор будет же обновлять данные которые он содержит при 
-- изменении родительской таблицы
DECLARE @ds varchar(50), @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR LOCAL STATIC -- STATIC/DYNAMIC
FOR SELECT [SUBJECTS].SUBJECT_NAME FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like 'ИСиТ';
OPEN ISITSubjects;
PRINT 'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5));
INSERT [SUBJECTS](SUBJECT_NAME, SUBJECTS, PULPIT)
		values('Алексей', 'АЛ', 'ИСиТ');
PRINT 'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5));
DELETE [SUBJECTS] WHERE [SUBJECT_NAME] = 'Алексей';
PRINT 'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5));
	FETCH ISITSubjects into @ds;
	PRINT 'Дисциплины на кафедре ИСиТ: ';
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @d = @d + rtrim(@ds) + ', ';
			FETCH ISITSubjects INTO @ds;
		END;
	PRINT @d;
GO

-- task 4
-- Работа с несколькими переменными в одной строке с использованием курсора
DECLARE @ds int, @d varchar(100);
DECLARE ISITSubjects CURSOR LOCAL DYNAMIC SCROLL
FOR SELECT ROW_NUMBER() over(ORDER BY [SUBJECTS].[SUBJECT_NAME]), [SUBJECTS].[SUBJECT_NAME] FROM [SUBJECTS] WHERE [SUBJECTS].PULPIT like 'ИСиТ';
OPEN ISITSubjects;
	FETCH ISITSubjects into @ds,@d;
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			print 'Строка: ' + cast(@ds as varchar(3)) + '. ' + rtrim(@d);
			FETCH ISITSubjects INTO @ds, @d;
		END;
	CLOSE ISITSubjects;
GO

-- task 5
DECLARE @ds int, @d varchar(1000) = '';
DECLARE ISITSubjects CURSOR LOCAL DYNAMIC
FOR SELECT ROW_NUMBER() over(ORDER BY [SUBJECTS].[SUBJECT_NAME]), [SUBJECTS].[SUBJECT_NAME] FROM [SUBJECTS] 
WHERE [SUBJECTS].PULPIT like 'ИСиТ' FOR UPDATE;
	OPEN ISITSubjects;
	FETCH ISITSubjects into @ds,@d;
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			print 'Строка: ' + cast(@ds as varchar(3)) + '. ' + rtrim(@d);
			FETCH ISITSubjects INTO @ds, @d;
		END;
	CLOSE ISITSubjects;

	OPEN ISITSubjects;

	FETCH ISITSubjects INTO @ds,@d;
	DELETE [SUBJECTS] WHERE CURRENT OF ISITSubjects;

	WHILE @@FETCH_STATUS = 0
		BEGIN 
			print 'Строка: ' + cast(@ds as varchar(3)) + '. ' + rtrim(@d);
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
	PRINT 'Количество строк : '+ cast(@@CURSOR_ROWS as varchar(5));
	FETCH PROGRESS_CUR INTO @id,@pr;
		WHILE @@FETCH_STATUS = 0
		BEGIN 
			DELETE [PROGRESS] WHERE CURRENT OF PROGRESS_CUR;
			FETCH PROGRESS_CUR INTO @id, @pr;
		END;
		PRINT 'Количество строк : '+ cast(@@CURSOR_ROWS as varchar(5));
	CLOSE PROGRESS_CUR;
GO

-- part 2
DECLARE @id int, @pr int;
DECLARE PROGRESS_CUR CURSOR LOCAL DYNAMIC
FOR SELECT [PROGRESS].[IDSTUDENT], [PROGRESS].[NOTE] FROM [PROGRESS] WHERE [PROGRESS].[IDSTUDENT] = 1001 FOR UPDATE;
	OPEN PROGRESS_CUR;
	PRINT 'Оценки студента с номером 1001 до запроса: ';
	FETCH PROGRESS_CUR INTO @id,@pr;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			FETCH PROGRESS_CUR INTO @id, @pr;
			print 'Студент: ' + cast(@id as varchar(3)) + ' имеет оценку ' + rtrim(@pr);
		END;
	CLOSE PROGRESS_CUR;
	OPEN PROGRESS_CUR;
	PRINT 'Оценки студента с номером 1001 после запроса: ';
	FETCH PROGRESS_CUR INTO @id,@pr;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			FETCH PROGRESS_CUR INTO @id, @pr;
			IF (@pr < 9) UPDATE [PROGRESS] SET [NOTE] = [NOTE] + 1;
			ELSE UPDATE [PROGRESS] SET [NOTE] = [NOTE] - 1;
			PRINT 'Студент: ' + cast(@id as varchar(3)) + ' имеет оценку ' + rtrim(@pr);
		END;
	CLOSE PROGRESS_CUR;
GO