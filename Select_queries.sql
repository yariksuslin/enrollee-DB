
--������� ���������� ������������, ������� ��� �� ������� ��������, ������������, ����������� � ������� �������� ������ �� �������� ���, ���������� ������������� �� �������� �������� � ���������� �������
SELECT name_subject, COUNT(result) AS ����������,MAX(result) AS ��������,MIN(result) AS �������,ROUND(AVG(CAST(result AS float)),1) AS �������
FROM subject s
INNER JOIN enrollee_subject es ON s.subject_id = es.subject_id
GROUP BY name_subject
ORDER BY name_subject;

--������� ��������������� ���������, ��� ������� ����������� ���� ��� �� ������� �������� ������ ��� ����� 40 ������.���������� ������������� �� �������� ���������.
SELECT name_program
FROM program
WHERE name_program NOT IN(SELECT name_program
FROM program p 
INNER JOIN program_subject ps ON p.program_id = ps.program_id
WHERE min_result < 40)
ORDER BY name_program;

--������� ��������������� ���������, �� ������� ��� ����������� ���������� ������� ������������ � �����������
SELECT name_program
FROM program p
INNER JOIN program_subject ps ON p.program_id = ps.program_id
INNER JOIN subject s ON ps.subject_id = s.subject_id
WHERE name_subject =('����������') OR name_subject =('�����������')
GROUP BY name_program
HAVING COUNT(ps.subject_id) = 2;

--������� �������� ��������������� ��������� � ������� ��� ������������, ������� �������� ��������� �� ��� ��������������� ���������, �� �� ����� ���� ��������� �� ���. 
--��� ����������� ����� ��������� �� ������ ��� ���������� ��������� ���, ����������� ��� ����������� �� ��� ��������������� ���������, ������ ������������ �����.
SELECT name_program, name_enrollee
FROM enrollee e
INNER JOIN program_enrollee pe ON e.enrollee_id = pe.enrollee_id
INNER JOIN program p ON pe.program_id = p.program_id
INNER JOIN program_subject ps ON p.program_id  = ps.program_id 
INNER JOIN enrollee_subject es ON ps.subject_id = es.subject_id AND e.enrollee_id  = es.enrollee_id
WHERE result < min_result
GROUP BY name_program,name_enrollee;

--������� ��������  ���������, ����������� �� ��������� "���������� ��������" � �� ����� ���������� ������. ��� ���� ���������� ������: 
--1. �������������� ����� �� ����������,
--2. ���������, ��� � ����������� �� �� ������ �������� ��� (������������ �� ����� �����������) ��� ������ ������, ��� ��������� �� ��� ���������.

--������ ������������� ������� ����� ������� ����� ������������, ������� �������� ������� � ������� ���������� "���"
CREATE VIEW bonuses_for_enrollee 
AS
SELECT e.name_enrollee, SUM(bonus) AS sum_bonus
FROM enrollee e
INNER JOIN enrollee_achievement ea ON e.enrollee_id = ea.enrollee_id
INNER JOIN achievement a ON ea.achievement_id = a.achievement_id
WHERE name_achievement LIKE '%���%'
GROUP BY e.name_enrollee;

--������ �������������, ������� ������� �������� ���������, ��� �����������, ����� ��� ����� �� ��� ��������� ����������� ��� ����������� �� ��������� ���������� ��������, ����� 
--��� �������� ���� ����� ������ ��� ����������� ���.
CREATE VIEW prog_enrol_sum_result 
AS
SELECT name_program,name_enrollee,SUM(result) as sum_result
FROM enrollee e
INNER JOIN program_enrollee pe ON e.enrollee_id = pe.enrollee_id
INNER JOIN program p ON pe.program_id = p.program_id
INNER JOIN program_subject ps ON p.program_id = ps.program_id 
INNER JOIN enrollee_subject es ON ps.subject_id = es.subject_id AND e.enrollee_id = es.enrollee_id
WHERE name_program = '���������� ��������' AND result > min_result 
GROUP BY name_program,name_enrollee
HAVING COUNT(es.subject_id) = 3;

-- ������� �������� ���������, ��� �����������, � ���� � ���� ���� ���������� �� ���������� �� � ������ ���� �� ��� ������ ��������
SELECT name_program, pesr.name_enrollee, 
CASE WHEN sum_bonus IS NULL THEN sum_result
ELSE sum_bonus + sum_result
END AS total_ball
FROM prog_enrol_sum_result pesr
LEFT JOIN bonuses_for_enrollee bfe ON pesr.name_enrollee = bfe.name_enrollee;






