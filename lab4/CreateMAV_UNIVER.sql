Create database MAV_UNIVERTMP;

use MAV_UNIVERTMP;

Create table Groups
(
	Номер_группы int primary key,
	Количество_студентов_в_группе int,
);

Create table Student
(
	Номер_зачётки int primary key, 
	ФИО nvarchar(50), 
	Группа int constraint FK_Студент_Группа references Groups(Номер_группы),
);

Create table Profession
(
	Специальность nvarchar(30) primary key,
);

Create table Faculty
(
	Факультет char(10) primary key,
);

Create table Pulpit
(
	Кафедра char(10) not null constraint PK_Кафедра primary key(Кафедра),
	Факультет char(10) NOT NULL constraint FK_Кафедра_Факультет foreign key(Факультет) references Faculty(Факультет),
);

Create table Teacher
(
	ID int primary key,
	ФИО nvarchar(50),
);

Create table Subjects
(
	Дисциплина nvarchar(20) primary key,
);

Create Table Auditorium_Type
(
	Тип_Аудитории nvarchar(20) primary key,
);

Create table Auditorium
(
	Тип_ауд nvarchar(20) not null
		constraint FK_Аудитория_Тип_Аудитории
		references Auditorium_Type(Тип_Аудитории),
	Номер_аудитории nvarchar(10),
);
