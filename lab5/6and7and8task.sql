use [MAV_UNIVERTMP];
SELECT  isNULL (Pulpit.Кафедра, '***')[Кафедра], isNULL (Teacher.ФИО, '***')[ФИО]
	From Pulpit left outer join Teacher
	On Teacher.Кафедра = Pulpit.Кафедра
go

use [MAV_UNIVERTMP];
SELECT  isNULL (Pulpit.Кафедра, '***')[Кафедра], isNULL (Teacher.ФИО, '***')[ФИО]
	From Teacher right outer join Pulpit
	On Teacher.Кафедра = Pulpit.Кафедра
go

use [MAV_UNIVERTMP];
SELECT  isNULL (Pulpit.Кафедра, '***')[Кафедра], isNULL (Teacher.ФИО, '***')[ФИО]
	From Teacher full outer join Pulpit
	On Teacher.Кафедра = Pulpit.Кафедра
go

use [MAV_UNIVERTMP];
SELECT  isNULL (Pulpit.Кафедра, '***')[Кафедра], isNULL (Teacher.ФИО, '***')[ФИО]
	From Pulpit full outer join Teacher
	On Teacher.Кафедра = Pulpit.Кафедра
go

