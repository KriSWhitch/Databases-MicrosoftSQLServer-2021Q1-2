use [MAV_UNIVERTMP];
SELECT [Auditorium].�����_���������, [Auditorium_Type].���_���������
	From Auditorium_Type Cross Join Auditorium
	Where Auditorium.���_��� = Auditorium_Type.���_���������;