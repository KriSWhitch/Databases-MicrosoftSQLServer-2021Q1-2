use [MAV_UNIVERTMP];
SELECT [Auditorium].Номер_аудитории, [Auditorium_Type].Тип_Аудитории
	From Auditorium_Type Cross Join Auditorium
	Where Auditorium.Тип_ауд = Auditorium_Type.Тип_Аудитории;