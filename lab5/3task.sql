use [MAV_UNIVERTMP];
SELECT [Auditorium].Номер_аудитории, [Auditorium_Type].Тип_Аудитории
	From Auditorium_Type, Auditorium
	Where Auditorium.Тип_ауд = Auditorium_Type.Тип_Аудитории;

use [MAV_UNIVERTMP];
SELECT T2.Номер_аудитории, T1.Тип_Аудитории
	From Auditorium_Type as T1, Auditorium as T2
	Where T2.Тип_ауд = T1.Тип_Аудитории
	And T1.Тип_Аудитории like '%мал%';