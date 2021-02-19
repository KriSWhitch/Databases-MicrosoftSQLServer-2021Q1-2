use [MAV_UNIVERTMP];
SELECT [Auditorium].Номер_аудитории, [Auditorium_Type].Тип_Аудитории
	From Auditorium_Type Inner Join Auditorium
	On Auditorium.Тип_ауд = Auditorium_Type.Тип_Аудитории;

use [MAV_UNIVERTMP];
SELECT [Auditorium].Номер_аудитории, [Auditorium_Type].Тип_Аудитории
	From Auditorium_Type Inner Join Auditorium
	On Auditorium.Тип_ауд = Auditorium_Type.Тип_Аудитории
	And Auditorium_Type.Тип_Аудитории like '%мал%';