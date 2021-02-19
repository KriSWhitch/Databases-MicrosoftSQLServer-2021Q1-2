use [MAV_UNIVERTMP];
SELECT  Student.ФИО, Progress.Оценка, Subjects.Дисциплина, Pulpit.Кафедра, [Оценка_студента] = 
	CASE
		when (Progress.Оценка = 6) then 'шесть'
		when (Progress.Оценка = 7) then 'семь'
		when (Progress.Оценка = 8) then 'восемь'
		else 'как оно сюда попало?'
	END
	From Progress,
	Subjects,
	Student,
	Pulpit
	where Progress.Студент = Student.Номер_зачётки and Progress.Дисциплина = Subjects.Дисциплина and Subjects.Кафедра = Pulpit.Кафедра and (Progress.Оценка between 6 and 8)
	Order By 
	(
		Case
		when (Progress.Оценка = 6) then 3
		when (Progress.Оценка = 7) then 1
		when (Progress.Оценка = 8) then 2
		END
	), Pulpit.Кафедра ASC, Subjects.Дисциплина ASC, Student.ФИО ASC;
go
