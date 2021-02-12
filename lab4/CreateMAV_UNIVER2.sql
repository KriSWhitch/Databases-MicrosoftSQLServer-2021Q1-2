use master;
go
create database MAV_UNIVERTMP on primary
( name = N'MAV_UNIVER_mdf', filename = N'C:\UNIVER',
 size = 5120Kb, maxsize=10240Kb, filegrowth=1024Kb),
( name = N'MAV_UNIVER_ndf', filename = N'C:\UNIVER',
 size = 5120Kb,maxsize=10240Kb, filegrowth=10%),
filegroup G1
( name = N'MAV_UNIVER11', filename = N'C:\UNIVER',
 size = 10240Kb, maxsize=15360kb, filegrowth=1024kb),
( name = N'MAV_UNIVER12', filename = N'C:\UNIVER',
 size = 2048Kb, maxsize=5120Kb, filegrowth=1024kb),
filegroup G2
( name = N'MAV_UNIVER21', filename = N'C:\UNIVER',
 size = 5120Kb, maxsize=10240Kb, filegrowth=1024kb),
( name = N'MAV_UNIVER22', filename = N'C:\UNIVER',
 size = 2048Kb, maxsize=5120Kb, filegrowth=1024kb)
log on
( name = N'MAV_UNIVER_log', filename=N'C:\UNIVER',
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
)on g1;
go

Create table Subjects
(
	Дисциплина nvarchar(20) primary key,
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
