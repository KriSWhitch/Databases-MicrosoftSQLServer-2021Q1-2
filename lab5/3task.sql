use [MAV_UNIVERTMP];
SELECT [Auditorium].�����_���������, [Auditorium_Type].���_���������
	From Auditorium_Type, Auditorium
	Where Auditorium.���_��� = Auditorium_Type.���_���������;

use [MAV_UNIVERTMP];
SELECT T2.�����_���������, T1.���_���������
	From Auditorium_Type as T1, Auditorium as T2
	Where T2.���_��� = T1.���_���������
	And T1.���_��������� like '%���%';