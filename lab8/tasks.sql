use MAV_UNIVERTMP;
-- task 1
/*
CREATE VIEW [Преподаватель] AS SELECT TEACHER [Код], TEACHER_NAME [Имя преподавателя],
GENDER [Пол], PULPIT [Кафедра]
FROM TEACHER;
*/
SELECT * FROM [Преподаватель];

-- task 2
/*
CREATE VIEW [Количество кафедр] AS SELECT FACULTY.FACULTY_NAME[Факультет], count(PULPIT.PULPIT) [Количество кафедр]
FROM FACULTY inner join PULPIT
ON FACULTY.FACULTY = PULPIT.FACULTY GROUP BY FACULTY.FACULTY_NAME;
*/
SELECT * FROM [Количество кафедр];

-- task 3
/*
CREATE VIEW [Аудитории] AS SELECT * FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%';
*/
SELECT * FROM [Аудитории];
INSERT [Аудитории] values('232-4', 'ЛК', 80, '232-4');

-- task 4
/*
CREATE VIEW [Лекционные аудитории] AS SELECT * FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%' WITH CHECK OPTION;
*/
INSERT [Лекционные аудитории] values('212-4', 'ЛБ', 80, '212-4');
INSERT [Лекционные аудитории] values('202-4', 'ЛК', 80, '202-4');

-- task 5
/*
CREATE VIEW [Дисциплины] AS SELECT TOP 20
PULPIT[Кафедра], SUBJECT_NAME[Название дисциплины], SUBJECTS [Код]
FROM SUBJECTS ORDER BY PULPIT;
*/
SELECT * FROM [Дисциплины];

-- task 6
/*
ALTER VIEW [Количество кафедр] WITH SCHEMABINDING 
AS SELECT FACULTY.FACULTY_NAME[Факультет], count(PULPIT.PULPIT) [Количество кафедр]
FROM DBO.FACULTY inner join DBO.PULPIT
ON FACULTY.FACULTY = PULPIT.FACULTY GROUP BY FACULTY.FACULTY_NAME;
*/
SELECT * FROM [Количество кафедр];


