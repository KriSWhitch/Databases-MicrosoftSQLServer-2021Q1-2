use [MAV_UNIVERTMP];
SELECT  isNULL (Pulpit.�������, '***')[�������], isNULL (Teacher.���, '***')[���]
	From Pulpit left outer join Teacher
	On Teacher.������� = Pulpit.�������
go

use [MAV_UNIVERTMP];
SELECT  isNULL (Pulpit.�������, '***')[�������], isNULL (Teacher.���, '***')[���]
	From Teacher right outer join Pulpit
	On Teacher.������� = Pulpit.�������
go

use [MAV_UNIVERTMP];
SELECT  isNULL (Pulpit.�������, '***')[�������], isNULL (Teacher.���, '***')[���]
	From Teacher full outer join Pulpit
	On Teacher.������� = Pulpit.�������
go

use [MAV_UNIVERTMP];
SELECT  isNULL (Pulpit.�������, '***')[�������], isNULL (Teacher.���, '***')[���]
	From Pulpit full outer join Teacher
	On Teacher.������� = Pulpit.�������
go

