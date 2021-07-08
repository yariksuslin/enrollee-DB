
--1)������� ��������������� ������� applicant,  ���� �������� id ��������������� ���������, id �����������, 
--����� ������ ������������ (������� itog) � ��������������� ������� �� id ��������������� ���������, � ����� �� �������� ����� ������ ����
SELECT TOP 25000 * INTO applicant
FROM
(SELECT pe.program_id, pe.enrollee_id, SUM(result) as itog
FROM program_enrollee pe
INNER JOIN program_subject ps ON pe.program_id = ps.program_id
INNER JOIN enrollee_subject es ON ps.subject_id = es.subject_id and pe.enrollee_id = es.enrollee_id
GROUP BY pe.program_id, pe.enrollee_id) sub_table 
ORDER BY program_id,itog DESC; --sql server �� ������������ �������� ������ �� ������ ������������ � ��������������� ����, ������� � ����������� ����������� "SELECT TOP 25000 * INTO new_table FROM old_table ORDER BY old_table_field"

--2)�� ������� applicant, ��������� �� ���������� ����, ������� ������, ���� ���������� �� ��������� ��������������� ��������� �� ������ ������������ ����� ���� �� �� ������ ��������

DELETE a
FROM applicant a
INNER JOIN program_subject ps ON a.program_id = ps.program_id
INNER JOIN enrollee_subject es ON ps.subject_id = es.subject_id AND a.enrollee_id = es.enrollee_id
WHERE result < min_result;

--3)�������� �������� ����� ������������ � ������� applicant �� �������� �������������� ������ �� ����������

UPDATE a
SET itog = itog + sum_bonus
FROM applicant a
INNER JOIN (SELECT ea.enrollee_id, SUM(bonus) as sum_bonus
FROM enrollee_achievement ea
INNER JOIN achievement a ON ea.achievement_id = a.achievement_id
GROUP BY ea.enrollee_id) t ON a.enrollee_id = t.enrollee_id;

--4)��������� ��� ���������� �������������� ������, ����������� �� ������ ��������������� ��������� ����� ��������� �� � ������� �������� ��������� ������, ���������� ������� ����� ������� applicant_order �� ������ ������� applicant. 
--��� �������� ������� ������ ����� ������������� ������� �� id ��������������� ���������, ����� �� �������� ��������� �����. � ������� applicant �������.
SELECT TOP 25000 * INTO applicant_order 
FROM applicant
ORDER BY program_id, itog DESC;

DROP TABLE applicant;

--5)�������� � ������� applicant_order ����� ������� str_id ������ ����
ALTER TABLE applicant_order ADD str_id INT ;

--6)�������� ���������, ������� ���������� ������ ��� ������ ��������������� ���������(str_id).

UPDATE ao
SET str_id = sub_table.str_id2
FROM applicant_order ao
INNER JOIN
(SELECT *,ROW_NUMBER() OVER (PARTITION BY program_id ORDER BY program_id) as str_id2
FROM applicant_order) sub_table ON ao.enrollee_id = sub_table.enrollee_id AND ao.program_id = sub_table.program_id;

--7)������� ������� student,  � ������� �������� ������������, ������� ����� ���� ������������� � ����������  � ������������ � ������ ������. ���������� ������������� ������� � ���������� ������� �� �������� ��������, � ����� �� �������� ��������� �����.
SELECT TOP 25000 * INTO student
FROM
(SELECT name_program,name_enrollee,itog
FROM program p 
INNER JOIN applicant_order ao ON p.program_id = ao.program_id
INNER JOIN enrollee e ON ao.enrollee_id = e.enrollee_id
WHERE str_id <= plann) sub_tab
ORDER BY name_program,itog DESC;

--8)� ������� student �����, ��� ��������� ����� ������ �� ��� ��������� � ����� ��������� �� ���� �� ���.
--������� � ������� ���������, ������� ������������ ������� �� ���������, �� ������� ����� �� ������ (�������, ��� �� ���� ���������� ����� ��� ������� �� ������).

ALTER TABLE student ADD status TEXT; -- ������� ������� � ������� ����� �������� ������ ������������

UPDATE student -- ������ ������ '��������' ��� ������� �������
SET status = '��������'
WHERE status IS NULL;

CREATE VIEW daria_id
AS
SELECT p.program_id --������ ���� ������� �� ������� ��������� ��������� ����� i plan
FROM program p 
INNER JOIN
(SELECT name_program,name_enrollee
FROM student 
WHERE name_enrollee = '��������� �����') sub_t 
ON p.name_program = sub_t.name_program;

CREATE VIEW second_chance_students --������ ��� ����� ��������� ����������� �����, ���� ��������� ����� ��������� �������� ���������
AS
SELECT ao.program_id,ao.enrollee_id,itog 
FROM program p 
INNER JOIN applicant_order ao ON p.program_id = ao.program_id
WHERE ao.program_id IN(SELECT program_id FROM daria_id)
AND str_id = plann + 1;

INSERT INTO student(name_program,name_enrollee,itog,status) --������ �������� ���������, ��� ��������, ��� ����� ��� �� ���������, � ������ ��� '� ��������'
SELECT name_program,name_enrollee,itog, '� ��������'
FROM program p 
INNER JOIN second_chance_students scs ON p.program_id = scs.program_id
INNER JOIN enrollee e ON scs.enrollee_id = e.enrollee_id;






















