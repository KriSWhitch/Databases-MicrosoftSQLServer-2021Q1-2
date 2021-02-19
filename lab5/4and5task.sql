use [MAV_UNIVERTMP];
SELECT  Student.���, Progress.������, Subjects.����������, Pulpit.�������, [������_��������] = 
	CASE
		when (Progress.������ = 6) then '�����'
		when (Progress.������ = 7) then '����'
		when (Progress.������ = 8) then '������'
		else '��� ��� ���� ������?'
	END
	From Progress,
	Subjects,
	Student,
	Pulpit
	where Progress.������� = Student.�����_������� and Progress.���������� = Subjects.���������� and Subjects.������� = Pulpit.������� and (Progress.������ between 6 and 8)
	Order By 
	(
		Case
		when (Progress.������ = 6) then 3
		when (Progress.������ = 7) then 1
		when (Progress.������ = 8) then 2
		END
	), Pulpit.������� ASC, Subjects.���������� ASC, Student.��� ASC;
go
