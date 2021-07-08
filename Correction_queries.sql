
--1)Создать вспомогательную таблицу applicant,  куда включить id образовательной программы, id абитуриента, 
--сумму баллов абитуриентов (столбец itog) в отсортированном сначала по id образовательной программы, а потом по убыванию суммы баллов виде
SELECT TOP 25000 * INTO applicant
FROM
(SELECT pe.program_id, pe.enrollee_id, SUM(result) as itog
FROM program_enrollee pe
INNER JOIN program_subject ps ON pe.program_id = ps.program_id
INNER JOIN enrollee_subject es ON ps.subject_id = es.subject_id and pe.enrollee_id = es.enrollee_id
GROUP BY pe.program_id, pe.enrollee_id) sub_table 
ORDER BY program_id,itog DESC; --sql server не поддерживает создание таблиц на основе сущевствущих в отстортированом виде, поэтому я использовал конструкцию "SELECT TOP 25000 * INTO new_table FROM old_table ORDER BY old_table_field"

--2)Из таблицы applicant, созданной на предыдущем шаге, удалить записи, если абитуриент на выбранную образовательную программу не набрал минимального балла хотя бы по одному предмету

DELETE a
FROM applicant a
INNER JOIN program_subject ps ON a.program_id = ps.program_id
INNER JOIN enrollee_subject es ON ps.subject_id = es.subject_id AND a.enrollee_id = es.enrollee_id
WHERE result < min_result;

--3)Повысить итоговые баллы абитуриентов в таблице applicant на значения дополнительных баллов за достижения

UPDATE a
SET itog = itog + sum_bonus
FROM applicant a
INNER JOIN (SELECT ea.enrollee_id, SUM(bonus) as sum_bonus
FROM enrollee_achievement ea
INNER JOIN achievement a ON ea.achievement_id = a.achievement_id
GROUP BY ea.enrollee_id) t ON a.enrollee_id = t.enrollee_id;

--4)Поскольку при добавлении дополнительных баллов, абитуриенты по каждой образовательной программе могут следовать не в порядке убывания суммарных баллов, необходимо создать новую таблицу applicant_order на основе таблицы applicant. 
--При создании таблицы данные нужно отсортировать сначала по id образовательной программы, потом по убыванию итогового балла. А таблицу applicant удалить.
SELECT TOP 25000 * INTO applicant_order 
FROM applicant
ORDER BY program_id, itog DESC;

DROP TABLE applicant;

--5)Включить в таблицу applicant_order новый столбец str_id целого типа
ALTER TABLE applicant_order ADD str_id INT ;

--6)Создадим нумерацию, которая начинается заново для каждой образовательной программы(str_id).

UPDATE ao
SET str_id = sub_table.str_id2
FROM applicant_order ao
INNER JOIN
(SELECT *,ROW_NUMBER() OVER (PARTITION BY program_id ORDER BY program_id) as str_id2
FROM applicant_order) sub_table ON ao.enrollee_id = sub_table.enrollee_id AND ao.program_id = sub_table.program_id;

--7)Создать таблицу student,  в которую включить абитуриентов, которые могут быть рекомендованы к зачислению  в соответствии с планом набора. Информацию отсортирована сначала в алфавитном порядке по названию программ, а потом по убыванию итогового балла.
SELECT TOP 25000 * INTO student
FROM
(SELECT name_program,name_enrollee,itog
FROM program p 
INNER JOIN applicant_order ao ON p.program_id = ao.program_id
INNER JOIN enrollee e ON ao.enrollee_id = e.enrollee_id
WHERE str_id <= plann) sub_tab
ORDER BY name_program,itog DESC;

--8)В таблице student видно, что Степанова Дарья прошла на три программы и может поступить на одну из них.
--Добавим в таблицу студентов, которые потенциально пройдут на программы, на которые Дарья не пойдет (считаем, что на двух программах сразу она учиться не сможет).

ALTER TABLE student ADD status TEXT; -- добавим столбец в котором будет хранится статус поступающего

UPDATE student -- внесем статус 'Поступил' для каждого кортежа
SET status = 'Поступил'
WHERE status IS NULL;

CREATE VIEW daria_id
AS
SELECT p.program_id --узнаем айди програм на которые поступила Степанова Дарья i plan
FROM program p 
INNER JOIN
(SELECT name_program,name_enrollee
FROM student 
WHERE name_enrollee = 'Степанова Дарья') sub_t 
ON p.name_program = sub_t.name_program;

CREATE VIEW second_chance_students --узнаем для каких студентов освободится место, если Степанова Дарья откажется подавать документы
AS
SELECT ao.program_id,ao.enrollee_id,itog 
FROM program p 
INNER JOIN applicant_order ao ON p.program_id = ao.program_id
WHERE ao.program_id IN(SELECT program_id FROM daria_id)
AND str_id = plann + 1;

INSERT INTO student(name_program,name_enrollee,itog,status) --внесем название программы, имя студента, его общий бал на программу, и статус как 'В ожидании'
SELECT name_program,name_enrollee,itog, 'В ожидании'
FROM program p 
INNER JOIN second_chance_students scs ON p.program_id = scs.program_id
INNER JOIN enrollee e ON scs.enrollee_id = e.enrollee_id;






















