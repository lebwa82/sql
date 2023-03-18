Л.р. №1. Создание и заполнение отношений БД диссертаций.


1 Отношение "Разделы науки" (поля "Шифр", "Название раздела").

drop table sections_of_science cascade
CREATE TABLE sections_of_science
(
cipher int PRIMARY KEY,
section_name varchar(40) NOT null
);

2 Отношение "Научные направления" (поля "Код", "Название", "Раздел науки").
drop table scientific_field cascade
CREATE TABLE scientific_field
(
code int PRIMARY KEY,
field_name varchar(40) NOT null,
science_section int references sections_of_science (cipher)
);

3 Отношение "Авторы" (поле "ФИО", "Дата рождения", "Пол", "Серия и номер паспорта", "Дата 
выдачи паспорта").

drop table authors cascade
CREATE TABLE authors
(
id integer generated always as identity primary key,
full_name varchar(40) NOT NULL,
date_of_birth date,
sex char(1),
passport_number char(10),
passport_issue_date date
);

drop TABLE dissertations cascade
CREATE TABLE dissertations
(
id integer generated always as identity primary key, 
science_field int references scientific_field (code),
author integer references authors (id),
dissertation_name varchar(200) not null,
dissertation_type varchar(15),
defence_day date not null,
organization varchar(60) NOT NULL,
approve_day date,
diplom_number varchar(20) unique
);

INSERT INTO sections_of_science
VALUES
(12, 'история'),
(23, 'биология'),
(34, 'право'),
(11, 'информатика'),
(128, 'мемология'),
(45, 'астрология');

INSERT INTO scientific_field
VALUES
(77, 'гуманитарные науки', 34),
(79, 'исторические науки', 23),
(885, 'сельскохозяйственные науки', 45),
(15, 'Телекоммуникационные науки', 45),
(66, 'филологически науки', 45);

INSERT INTO authors
values 
(default,'Гагарина Нюша Игоревна', '2001-10-12', 'ж', '1234567890', '2001-11-11'),
(default,'Поспелов Иван Николаевич', '2005-6-7', 'м', '4500654321', '1900-1-22'),
(default,'Сурков Денис Давыдович', '2000-1-2', 'м', '1772883990', '2000-3-4');

drop table dissertations 
INSERT INTO dissertations
values
(default, 15, 1, 'новые проблемы', 'докторская', '2022-12-15', 
'институт живота','2021-1-10', '303'),
(default, 66, 1, 'проблемы живота', 'докторская', '2022-12-15', 
'институт живота','2021-8-10', '302'),
(default, 66, 1, 'проблемы мышц', 'докторская', '2008-8-10', 
'институт мышц', '2008-8-12', '312'),
(default, 885, 2, 'Изучение зерна', 'кандидатская', '2022-4-7', 
'сельскохозяйственный универ', '2022-8-12', '399'),
(default, 15, 3, 'технология 5g', 'кандидатская', '2022-8-10', 
'институт теле наук', '2022-8-12', '228'),
(default, 15, 2, 'ipv6 в 22 году', 'докторская', '2006-1-12', 
'институт информатики', '2018-2-12', '138'),
(default, 15, 1, 'ядро linux 6.0.0', 'кандадатская', '2017-2-2', 
'Калтех', '2020-2-20', '139'),
(default, 885, 3, 'проблема засухи', 'кандадатская', '2017-2-2', 
'институт экологии', '2020-2-20', '140');

select * from sections_of_science
select * from scientific_field
select * from authors
select * from dissertations
