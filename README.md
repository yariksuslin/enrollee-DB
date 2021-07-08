# enrollee-DB
Университет состоит из совокупности факультетов (школ). Поступление абитуриентов осуществляется на образовательные программы по результатам Единого государственного экзамена (ЕГЭ). Каждая образовательная программа относится к определенному факультету, для нее определены необходимые для поступления предметы ЕГЭ, минимальный балл по этим предметам, а также план набора (количество мест) на образовательную программу.

В приемную комиссию абитуриенты подают заявления на образовательную программу, каждый абитуриент может выбрать несколько образовательных программ (но не более трех). В заявлении указывается фамилия, имя, отчество абитуриента, а также его достижения: получил ли он медаль за обучение в школе, имеет ли значок ГТО и пр. При этом за каждое достижение определен дополнительный балл. Абитуриент предоставляет сертификат с результатами сдачи  ЕГЭ. Если абитуриент выбирает образовательную программу, то у него обязательно должны быть сданы предметы, определенные на эту программу, причем балл должен быть не меньше минимального по данному предмету.

Зачисление абитуриентов осуществляется так: сначала вычисляется сумма баллов по предметам на каждую образовательную программу, добавляются баллы достижения, затем абитуриенты сортируются в порядке убывания суммы баллов и отбираются первые по количеству мест, определенному планом набора.

1)Tables_Creation_and_Insertion.sql - Содержит код создание и заполнения таблиц с описанием того за что каждая отвечает.

2)DBdiagram.png - Графическое предствление связей между таблицами

3)Select_queries.sql - Описание различных задач на выборку и код их решения 

4)Correction_queries.sql - Описание различных задач на корректировку и код их решения
