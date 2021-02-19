use master;
go
create database MAV_UNIVERTMP on primary
( name = N'MAV_UNIVER_mdf', filename = N'D:\UNIVER\MAV_UNIVER_mdf.mdf',
 size = 5120Kb, maxsize=10240Kb, filegrowth=1024Kb),
( name = N'MAV_UNIVER_ndf', filename = N'D:\UNIVER\MAV_UNIVER_ndf.ndf',
 size = 5120Kb,maxsize=10240Kb, filegrowth=10%),
filegroup G1
( name = N'MAV_UNIVER11', filename = N'D:\UNIVER\MAV_UNIVER11.ndf',
 size = 10240Kb, maxsize=15360kb, filegrowth=1024kb),
( name = N'MAV_UNIVER12', filename = N'D:\UNIVER\MAV_UNIVER12.ndf',
 size = 2048Kb, maxsize=5120Kb, filegrowth=1024kb),
filegroup G2
( name = N'MAV_UNIVER21', filename = N'D:\UNIVER\MAV_UNIVER21.ndf',
 size = 5120Kb, maxsize=10240Kb, filegrowth=1024kb),
( name = N'MAV_UNIVER22', filename = N'D:\UNIVER\MAV_UNIVER22.ndf',
 size = 2048Kb, maxsize=5120Kb, filegrowth=1024kb)
log on
( name = N'MAV_UNIVER_log', filename=N'D:\UNIVER\MAV_UNIVER_log.ldf',
 size=5120Kb, maxsize=UNLIMITED, filegrowth=1024kb) 
 go

use MAV_UNIVERTMP;
Create table Groups
(
	Номер_группы int primary key,
	Количество_студентов_в_группе int,
) on G1;
go

Create table Student
(
	Номер_зачётки int primary key, 
	ФИО nvarchar(50), 
	Группа int constraint FK_Студент_Группа references Groups(Номер_группы),
) on [Primary];
go

Create table Profession
(
	Специальность nvarchar(30) primary key,
) on [Primary];
go

Create table Faculty
(
	Факультет char(10) primary key,
) on [Primary];
go

Create table Pulpit
(
	Кафедра char(10) not null constraint PK_Кафедра primary key(Кафедра),
	Факультет char(10) NOT NULL constraint FK_Кафедра_Факультет foreign key(Факультет) references Faculty(Факультет),
) on g1;
go

Create table Teacher
(
	ID int primary key,
	ФИО nvarchar(50),
	Кафедра char(10) not null constraint FK_Учитель_Кафедра foreign key(Кафедра) references Pulpit(Кафедра),
)on g1;
go

Create table Subjects
(
	Дисциплина nvarchar(20) primary key,
	Кафедра char(10) constraint FK_Предмет_Кафедра foreign key(Кафедра) references Pulpit(Кафедра),
) on g1;
go

Create Table Auditorium_Type
(
	Тип_Аудитории nvarchar(20) primary key,
) on [Primary];
go

Create table Auditorium
(
	Тип_ауд nvarchar(20) not null
		constraint FK_Аудитория_Тип_Аудитории
		references Auditorium_Type(Тип_Аудитории),
	Номер_аудитории nvarchar(10),
) on g2;
go

Create Table Progress
(
	Номер_записи int primary key,
	Студент int constraint FK_Прогресс_Студенты foreign key(Студент) references Student(Номер_зачётки),
	Дисциплина nvarchar(20) constraint FK_Прогресс_Дисциплина foreign key(Дисциплина) references Subjects(Дисциплина),
	Оценка int,
) on [Primary];
go

use [MAV_UNIVERTMP];
INSERT into [Auditorium_Type] (Тип_Аудитории)
	Values('Маленькая'),
	('Большая'),
	('Средняя');
go
use [MAV_UNIVERTMP];
INSERT into [Auditorium] (Тип_ауд, Номер_аудитории)
	Values('Маленькая', '412-3'),
	('Большая', '212-3'),
	('Средняя', '112-3'),
	('Маленькая', '412-4'),
	('Большая', '212-4'),
	('Средняя', '112-4'),
	('Маленькая', '412-2'),
	('Большая', '212-2'),
	('Средняя', '112-2'),
	('Маленькая', '412-1'),
	('Большая', '212-1'),
	('Средняя', '112-1');
go

use [MAV_UNIVERTMP];
INSERT into Groups(Номер_группы, Количество_студентов_в_группе)
	Values(1, 31),
	(2, 30),
	(3, 20);
go

use [MAV_UNIVERTMP];
INSERT into Student(Номер_зачётки, ФИО, Группа)
	Values(1, 'МАВ', 1),
	(2, 'САВ', 2),
	(3, 'ЕАК', 3),
	(4, 'ФАС', 1),
	(5, 'КУМ', 2),
	(6, 'ТУА', 3),
	(7, 'ТИЦ', 1),
	(8, 'ШЛВ', 2),
	(9, 'АВС', 3),
	(10, 'АГС', 1),
	(11, 'ЛАМ', 2),
	(12, 'НОП', 3);
go

use [MAV_UNIVERTMP];
INSERT into Faculty(Факультет)
	Values('ФИТ'),
	('ТОВ');
go

use [MAV_UNIVERTMP];
INSERT into Pulpit(Кафедра, Факультет)
	Values('ИСИТ','ФИТ'),
	('Физики','ФИТ'),
	('Химии','ТОВ');
go

use [MAV_UNIVERTMP];
INSERT into Subjects(Кафедра, Дисциплина)
	Values('ИСИТ','ООП'),
	('Физики','Физика');
go

use [MAV_UNIVERTMP];
INSERT into Progress(Номер_записи, Студент, Дисциплина, Оценка)
	Values(1, 1,'ООП', 6),
	(2, 2,'Физика', 7),
	(3, 3,'ООП', 6),
	(4, 1,'Физика', 8),
	(5, 2,'ООП', 7),
	(6, 3,'Физика', 6),
	(7, 4,'ООП', 6),
	(8, 4,'Физика', 6);
go

use [MAV_UNIVERTMP];
INSERT into Teacher(ID, ФИО, Кафедра)
	Values(1, 'ПНВ', 'ИСИТ'),
	(2, 'ПСЦ', 'ИСИТ'),
	(3, 'НОФ', 'Физики');
go
