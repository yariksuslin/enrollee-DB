
--Вывести количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и среднее значение баллов по предмету ЕГЭ, Информация отсортирована по названию предмета в алфавитном порядке
SELECT name_subject, COUNT(result) AS Количество,MAX(result) AS Максимум,MIN(result) AS Минимум,ROUND(AVG(CAST(result AS float)),1) AS Среднее
FROM subject s
INNER JOIN enrollee_subject es ON s.subject_id = es.subject_id
GROUP BY name_subject
ORDER BY name_subject;

--Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам.Информация отсортирована по названию программы.
SELECT name_program
FROM program
WHERE name_program NOT IN(SELECT name_program
FROM program p 
INNER JOIN program_subject ps ON p.program_id = ps.program_id
WHERE min_result < 40)
ORDER BY name_program;

--Вывести образовательные программы, на которые для поступления необходимы предмет «Информатика» и «Математика»
SELECT name_program
FROM program p
INNER JOIN program_subject ps ON p.program_id = ps.program_id
INNER JOIN subject s ON ps.subject_id = s.subject_id
WHERE name_subject =('Математика') OR name_subject =('Информатика')
GROUP BY name_program
HAVING COUNT(ps.subject_id) = 2;

--Вывести название образовательной программы и фамилию тех абитуриентов, которые подавали документы на эту образовательную программу, но не могут быть зачислены на нее. 
--Эти абитуриенты имеют результат по одному или нескольким предметам ЕГЭ, необходимым для поступления на эту образовательную программу, меньше минимального балла.
SELECT name_program, name_enrollee
FROM enrollee e
INNER JOIN program_enrollee pe ON e.enrollee_id = pe.enrollee_id
INNER JOIN program p ON pe.program_id = p.program_id
INNER JOIN program_subject ps ON p.program_id  = ps.program_id 
INNER JOIN enrollee_subject es ON ps.subject_id = es.subject_id AND e.enrollee_id  = es.enrollee_id
WHERE result < min_result
GROUP BY name_program,name_enrollee;

--Вывести название  программы, поступивших на программу "Прикладная механика" и их общее количество баллов. При этом необходимо учесть: 
--1. дополнительные баллы за достижения,
--2. проверить, что у поступающих ни по одному предмету ЕГЭ (необходимому по этому направлению) нет баллов меньше, чем требуется на эту программу.

--создал представление которое будет хранить имена абитуриентов, которые получили награду в которой содержится "ГТО"
CREATE VIEW bonuses_for_enrollee 
AS
SELECT e.name_enrollee, SUM(bonus) AS sum_bonus
FROM enrollee e
INNER JOIN enrollee_achievement ea ON e.enrollee_id = ea.enrollee_id
INNER JOIN achievement a ON ea.achievement_id = a.achievement_id
WHERE name_achievement LIKE '%ГТО%'
GROUP BY e.name_enrollee;

--создал представление, которое выведет название программы, имя абитуриента, сумму его балов по трём предметам необходимым для поступления на программу Прикладная механика, чтобы 
--все предметы были сданы больше чем минимальный бал.
CREATE VIEW prog_enrol_sum_result 
AS
SELECT name_program,name_enrollee,SUM(result) as sum_result
FROM enrollee e
INNER JOIN program_enrollee pe ON e.enrollee_id = pe.enrollee_id
INNER JOIN program p ON pe.program_id = p.program_id
INNER JOIN program_subject ps ON p.program_id = ps.program_id 
INNER JOIN enrollee_subject es ON ps.subject_id = es.subject_id AND e.enrollee_id = es.enrollee_id
WHERE name_program = 'Прикладная механика' AND result > min_result 
GROUP BY name_program,name_enrollee
HAVING COUNT(es.subject_id) = 3;

-- выберет название программы, имя абитуриента, и если у него есть достижения то приплюсует их к общему балу за три сданых предмета
SELECT name_program, pesr.name_enrollee, 
CASE WHEN sum_bonus IS NULL THEN sum_result
ELSE sum_bonus + sum_result
END AS total_ball
FROM prog_enrol_sum_result pesr
LEFT JOIN bonuses_for_enrollee bfe ON pesr.name_enrollee = bfe.name_enrollee;






