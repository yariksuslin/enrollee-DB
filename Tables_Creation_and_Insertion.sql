CREATE TABLE department (department_id INT PRIMARY KEY IDENTITY(1, 1),name_department VARCHAR(30)); --������������


INSERT INTO department (department_id, name_department)
VALUES (1, '���������� �����'),
       (2, '����� ������������ ����');


CREATE TABLE subject (subject_id INT PRIMARY KEY IDENTITY(1, 1), name_subject VARCHAR(30)); -- �������� 


INSERT INTO subject (subject_id, name_subject)
VALUES (1, '������� ����'),
       (2, '����������'),
       (3, '������'),
       (4, '�����������');


CREATE TABLE program --� ������� plann ������ ���� ������ ������������ �� ��������������� ���������
  (program_id INT PRIMARY KEY IDENTITY(1, 1),
                              name_program VARCHAR(50),
                                           department_id INT, plann INT,
   FOREIGN KEY (department_id) REFERENCES department (department_id) ON DELETE CASCADE);


INSERT INTO program (program_id, name_program, department_id, plann)
VALUES (1, '���������� ���������� � �����������', 2, 2),
       (2, '���������� � ������������ �����', 2, 1),
       (3, '���������� ��������', 1, 2),
       (4, '����������� � �������������', 1, 3);


CREATE TABLE enrollee (enrollee_id INT PRIMARY KEY IDENTITY(1, 1),name_enrollee VARCHAR(50)); --�����������


INSERT INTO enrollee (enrollee_id, name_enrollee)
VALUES (1, '������� �����'),
       (2, '�������� ����'),
       (3, '������� ����'),
       (4, '�������� ������'),
       (5, '����� ����'),
       (6, '��������� �����');


CREATE TABLE achievement (achievement_id INT PRIMARY KEY IDENTITY(1, 1),name_achievement VARCHAR(30),bonus INT); --������� �������� ��� ����������, ������� ����������� ��� ����������� � �����������, � ��������� �������(bonus) ����������� ���������� ������, ������� ����������� � ����� ������ �� ��������� ��� ��� ������� ������ ����� �����������
                                                         
                                                                        
INSERT INTO achievement (achievement_id, name_achievement, bonus)
VALUES (1, '������� ������', 5),
       (2, '���������� ������', 3),
       (3, '������� ������ ���', 3),
       (4, '���������� ������ ���', 1);


CREATE TABLE enrollee_achievement --� ������� ���������� ���������� � ���, ����� ���������� ����� �����������
   (enrollee_achiev_id INT PRIMARY KEY IDENTITY(1, 1),
   enrollee_id INT, achievement_id INT,
   FOREIGN KEY (enrollee_id) REFERENCES enrollee (enrollee_id) ON DELETE CASCADE,
   FOREIGN KEY (achievement_id) REFERENCES achievement (achievement_id) ON DELETE CASCADE);


INSERT INTO enrollee_achievement (enrollee_achiev_id, enrollee_id, achievement_id)
VALUES (1, 1, 2),
       (2, 1, 3),
       (3, 3, 1),
       (4, 4, 4),
       (5, 5, 1),
       (6, 5, 3);


CREATE TABLE program_subject --� ������� �������, ����� �������� ��� ���������� ��� ����������� �� ������ ���������, � ��������� �������(min_result) � ����������� ���� �� ������� �������� ��� ��������������� ���������
  (program_subject_id INT PRIMARY KEY IDENTITY(1, 1),
   program_id INT, subject_id INT, min_result INT,
   FOREIGN KEY (program_id) REFERENCES program (program_id) ON DELETE CASCADE,
   FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE);


INSERT INTO program_subject (program_subject_id, program_id, subject_id, min_result)
VALUES (1, 1, 1, 40),
       (2, 1, 2, 50),
       (3, 1, 4, 60),
       (4, 2, 1, 30),
       (5, 2, 2, 50),
       (6, 2, 4, 60),
       (7, 3, 1, 30),
       (8, 3, 2, 45),
       (9, 3, 3, 45),
       (10, 4, 1, 40),
       (11, 4, 2, 45),
       (12, 4, 3, 45);


CREATE TABLE program_enrollee --������� �������� ����������, �� ����� ��������������� ��������� ����� ��������� ����������
  (program_enrollee_id INT PRIMARY KEY IDENTITY(1, 1),
   program_id INT, enrollee_id INT,
   FOREIGN KEY (program_id) REFERENCES program (program_id) ON DELETE CASCADE,
   FOREIGN KEY (enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE);


INSERT INTO program_enrollee (program_enrollee_id, program_id, enrollee_id)
VALUES (1, 3, 1),
       (2, 4, 1),
       (3, 1, 1),
       (4, 2, 2),
       (5, 1, 2),
       (6, 1, 3),
       (7, 2, 3),
       (8, 4, 3),
       (9, 3, 4),
       (10, 3, 5),
       (11, 4, 5),
       (12, 2, 6),
       (13, 3, 6),
       (14, 4, 6);


CREATE TABLE enrollee_subject --����� ��� ������� �����������
  (enrollee_subject_id INT PRIMARY KEY IDENTITY(1, 1),
   enrollee_id INT, subject_id INT, RESULT INT,
   FOREIGN KEY (enrollee_id) REFERENCES enrollee (enrollee_id) ON DELETE CASCADE,
   FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE);


INSERT INTO enrollee_subject (enrollee_subject_id, enrollee_id, subject_id, RESULT)
VALUES (1, 1, 1, 68),
       (2, 1, 2, 70),
       (3, 1, 3, 41),
       (4, 1, 4, 75),
       (5, 2, 1, 75),
       (6, 2, 2, 70),
       (7, 2, 4, 81),
       (8, 3, 1, 85),
       (9, 3, 2, 67),
       (10, 3, 3, 90),
       (11, 3, 4, 78),
       (12, 4, 1, 82),
       (13, 4, 2, 86),
       (14, 4, 3, 70),
       (15, 5, 1, 65),
       (16, 5, 2, 67),
       (17, 5, 3, 60),
       (18, 6, 1, 90),
       (19, 6, 2, 92),
       (20, 6, 3, 88),
       (21, 6, 4, 94);