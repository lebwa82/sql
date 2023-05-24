
create table Conferences
(
Conference_name char(10) primary key
);

create table Positions
(
Position_name char(10) primary key
);

create table Cities
(
City_name varchar(30) primary key
);

drop table Teams, Sportsmens, Contracts, Sportphone, Competitions_hockey, Games, Fanclub
create table Teams
(
T_id int generated always as identity primary key,
T_name varchar(30) not null unique,
T_city varchar(30) references Cities(City_name),
T_arena varchar(30) not null,
T_conf char(10) references Conferences (Conference_name)
);

create table Sportsmens
(
S_id int generated always as identity primary key,
S_FirstName varchar(50) not null,
S_SecondName varchar(50) not null,
S_ThirdName varchar(50), 
S_passport char(10) not null unique,
S_born date not null check (S_born > '1920-1-1'),
S_salary int not null check (S_salary > 1160),
S_position char(10) references Positions (Position_name),
S_capitan bool not null,
S_team int references Teams (T_id)
);


create table Sportphone
(
Sportsman int references Sportsmens (S_id),
phone char(10) not null
);


create table Competitions_hockey
(
C_id int generated always as identity primary key,
C_name varchar(30) not null,
C_date_start date not null check (C_date_start > '2000-1-1'),
C_date_end date not null check (C_date_end > C_date_start),
C_prize int not null check (C_prize > 0)
);


create table Games
(
G_id int generated always as identity primary key,
G_team1 int references Teams (T_id),
G_team2 int references Teams (T_id) check (G_team2 != G_team1),
G_tournament int references Competitions_hockey (C_id),
G_city varchar(30) not null,
G_date date not null,
G_tickets int not null check (G_tickets >=0),
G_dels int not null check (G_dels >=0),
G_res_1 int not null check (G_dels >=0),
G_res_2 int not null check (G_dels >=0)
);


create table Fanclub
(
F_id int generated always as identity primary key,
F_FirstName varchar(50) not null,
F_SecondName varchar(50) not null,
F_ThirdName varchar(50),
F_passport char(10) not null unique,
F_born date not null check (F_born > '1920-1-1'),
F_count int not null check (F_count >= 0),
F_team int references Teams (T_id)
);



insert into Conferences
values
('восточная');
('западная'),
('вострочная');
select * from Conferences


insert into Positions
values
('нападающий'),
('защитник'),
('вратарь');

insert into Cities
values
('Казань'),
('Москва'),
('Цюрих');

insert into Teams
values
(default, 'DreamTeam', 'Цюрих', 'Цюрих арена', 'восточная'),
(default, 'Ак барс', 'Казань', 'Татнефть арена', 'восточная'),
(default, 'ЦСКА', 'Москва', 'ЦСКА арена', 'западная');
select * from Teams


insert into Sportsmens--акбарс
values
(default, 'Тимур', 'Билялов', '', '1234567890', '1995-3-28', 2000, 'вратарь', false, 2),
(default, 'Даниил', 'Журавлев', '', '2345678901', '2000-4-8', 1900, 'защитник', false, 2),
(default, 'Александр', 'Радулов', '', '3456789012', '1986-7-5', 5000, 'нападающий', true, 2);


insert into Sportsmens--цска
values
(default, 'Скотников', 'Всеволод', '', '4567890123', '2001-9-28', 3100, 'вратарь', false, 3),
(default, 'Макаров', 'Николай', '', '5678901234', '2003-1-12', 3500, 'защитник', true, 3),
(default, 'Абрамов', 'Виталий', '', '6789012345', '1998-5-8', 4000, 'нападающий', false, 3);

insert into Sportsmens --дримтим
values
(default, 'Безхозный', 'Бездельник', '', '3333333444', '2000-1-1')
(default, 'Dream', 'Player', '', '3333333333', '2000-1-1')

select * from Sportsmens
select * from Teams


insert into Competitions_hockey
values
(default, 'КХЛ', '2023-2-1', '2023-4-29', 50000)
select * from Competitions_hockey

insert into Games
values
(default, 2, 3, 1, 'Казань', '2023-4-29', 2400, 3, 2,0)

insert into Fanclub
values
(default, 'Михайлова', 'Анастасия', 'Алексеевна', '1111111111', '2001-5-3', 1, 1),
(default, 'Парфенов', 'Дмитрий', 'Алексеевич', '2222222222', '2001-4-8', 2, 2);



----------------------------------------------
CREATE OR REPLACE FUNCTION check_goalkeeper_not_capitan_function()
     RETURNS trigger as $$
	 BEGIN
	 if new.S_position = 'вратарь' and new.S_capitan = true
	 then
	 raise exception 'вратарь не может быть капитаном'; 
	 end if;

	 return new;
	 END;
	 $$ LANGUAGE 'plpgsql';


create OR REPLACE TRIGGER check_goalkeeper_not_capitan
    BEFORE insert or update ON Sportsmens
    FOR EACH ROW
    EXECUTE PROCEDURE check_goalkeeper_not_capitan_function();



select * from Sportsmens
insert into Sportsmens
values
(default, 'Фамилия', 'Имя', 'Отчество', '1231231231', '2000-1-1', 100500, 'вратарь', false, 2)
---------------------------------------------------------------


----------------------------------------------------------------
CREATE OR REPLACE FUNCTION check_increase_tickets_function()
     RETURNS trigger as $$
	 BEGIN
	 if new.G_tickets < old.G_tickets
	 then
	 raise exception 'количество проданных билетов не может уменьшаться'; 
	 end if;
	
	 return new;
	 END;
	 $$ LANGUAGE 'plpgsql';


create OR REPLACE TRIGGER check_increase_tickets
    BEFORE update ON Games
    FOR EACH ROW
    EXECUTE PROCEDURE check_increase_tickets_function();
   
 select * from Games
 update Games set G_tickets = 25000
 where G_id = 2
----------------------------------------------------------------
 
 ----------------------------------------------------------------
 CREATE OR REPLACE FUNCTION became_capitan_function()
     RETURNS trigger as $$
	 BEGIN
	 if new.S_capitan = true and old.S_capitan = false
	 then
	 new.S_salary = old.S_salary * 1.5;
	 end if;
	
	if new.S_capitan = false and old.S_capitan = true
	 then
	 new.S_salary = old.S_salary * 0.75;
	 end if;
	
	 return new;
	 END;
	 $$ LANGUAGE 'plpgsql';


create OR REPLACE TRIGGER became_capitan
    BEFORE update ON Sportsmens
    FOR EACH ROW
    EXECUTE PROCEDURE became_capitan_function();
   
 select * from Sportsmens
 update Sportsmens set S_position = 'нападающий', S_capitan = true
 where S_id = 7
 ------------------------------------------------------------------------
 
 
 ----------------------------------------------------------------
 -- топ богатых спортсменов
create view top_rich_players AS
select S_firstname, S_secondname, S_position, S_salary  from Sportsmens 
order by S_salary desc
limit 5
 ----------------------------------------------------------------
 
--  безхозные спортсмены
--create view ownerless_players AS
--select S_firstname, S_secondname  from Sportsmens
--on Contracts.Contract_sroptsman = Sportsmens.S_id
--where Contracts.Contract_id is null

--фанаты одной команды или спортсмены одной команды

--------------------------------------------------------------------
drop function get_team_fans(char)
create or replace function get_team_fans(team_name char(30), out res char(50))
as $$
declare 
	c1 cursor for select * from Fanclub join Teams on 
	Fanclub.F_team = Teams.T_id
	where T_name = team_name;
begin
	for v_c1 in c1 loop
		RAISE NOTICE '%', v_c1.F_FirstName;
		
	end loop;
	res = 'OK';
end
$$ language plpgsql

select get_team_fans('Ак барс')
------------------------------------------------------------------------

 ----------------------------------------------------------------

Даты матчей в турнире должны соответствовать периоду проведения турнира
 CREATE OR REPLACE FUNCTION correct_game_date_function()
     RETURNS trigger as $$
     declare 
     date_start date;
     date_end date;
	 begin
	 select competitions_hockey.c_date_start into date_start from competitions_hockey 
	 where competitions_hockey.C_id = new.G_tournament;
	 select competitions_hockey.c_date_end into date_end from competitions_hockey 
	where competitions_hockey.C_id = new.G_tournament;
	 if new.G_date not between date_start and date_end
	 then
	 raise exception 'дата матча должна быть в рамках турнира'; 
	 end if;
	
	 return new;
	 END;
	 $$ LANGUAGE 'plpgsql';


create OR REPLACE TRIGGER correct_game_date
    before insert or update ON Games
    FOR EACH ROW
    EXECUTE PROCEDURE correct_game_date_function();
   
 select * from competitions_hockey
 select * from Games
 
insert into Games
values
(default, 2, 3, 1, 'Казань', '2023-4-28', 2400, 3, 2,0)
 ------------------------------------------------------------------------


 
 


