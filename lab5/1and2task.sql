use [MAV_UNIVERTMP];
SELECT [Auditorium].�����_���������, [Auditorium_Type].���_���������
	From Auditorium_Type Inner Join Auditorium
	On Auditorium.���_��� = Auditorium_Type.���_���������;

use [MAV_UNIVERTMP];
SELECT [Auditorium].�����_���������, [Auditorium_Type].���_���������
	From Auditorium_Type Inner Join Auditorium
	On Auditorium.���_��� = Auditorium_Type.���_���������
	And Auditorium_Type.���_��������� like '%���%';