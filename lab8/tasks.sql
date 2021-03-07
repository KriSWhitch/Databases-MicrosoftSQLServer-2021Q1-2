use MAV_UNIVERTMP;
-- task 1
/*
CREATE VIEW [�������������] AS SELECT TEACHER [���], TEACHER_NAME [��� �������������],
GENDER [���], PULPIT [�������]
FROM TEACHER;
*/
SELECT * FROM [�������������];

-- task 2
/*
CREATE VIEW [���������� ������] AS SELECT FACULTY.FACULTY_NAME[���������], count(PULPIT.PULPIT) [���������� ������]
FROM FACULTY inner join PULPIT
ON FACULTY.FACULTY = PULPIT.FACULTY GROUP BY FACULTY.FACULTY_NAME;
*/
SELECT * FROM [���������� ������];

-- task 3
/*
CREATE VIEW [���������] AS SELECT * FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE like '��%';
*/
SELECT * FROM [���������];
INSERT [���������] values('232-4', '��', 80, '232-4');

-- task 4
/*
CREATE VIEW [���������� ���������] AS SELECT * FROM AUDITORIUM WHERE AUDITORIUM.AUDITORIUM_TYPE like '��%' WITH CHECK OPTION;
*/
INSERT [���������� ���������] values('212-4', '��', 80, '212-4');
INSERT [���������� ���������] values('202-4', '��', 80, '202-4');

-- task 5
/*
CREATE VIEW [����������] AS SELECT TOP 20
PULPIT[�������], SUBJECT_NAME[�������� ����������], SUBJECTS [���]
FROM SUBJECTS ORDER BY PULPIT;
*/
SELECT * FROM [����������];

-- task 6
/*
ALTER VIEW [���������� ������] WITH SCHEMABINDING 
AS SELECT FACULTY.FACULTY_NAME[���������], count(PULPIT.PULPIT) [���������� ������]
FROM DBO.FACULTY inner join DBO.PULPIT
ON FACULTY.FACULTY = PULPIT.FACULTY GROUP BY FACULTY.FACULTY_NAME;
*/
SELECT * FROM [���������� ������];


