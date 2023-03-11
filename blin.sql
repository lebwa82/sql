drop function get_initials(x char(50), out res char[20][3])

create or replace function get_initials(x char(50), out res char(50))
as $$
declare 
	list char(20)[];
	n char(1);
	o char(1);
begin 
	list = string_to_array(x, ' ');
	n = left(list[1], 1);
	o = left(list[3], 1);
	--res = list;
	res = list[1] || ' ' || n || '.' || o || '.';
	if res is null then
		res = '########';
	end if;
end
$$ language plpgsql

select  get_initials('Иванов')

create or replace function get_full_name(x char(50), y char(50), out res char(50))
as $$
declare 
	list char(20)[];
	p1 char(20);
	p2 char(20);
	p3 char(20);
begin 
	list = string_to_array(y, ' ');
	p1 = left(x, -4);
	p2 = left(list[1], -1) || 'x';
	p3 = left(list[2], -1);
	res = p1 || ' ' || p2 || ' ' || p3;
end
$$ language plpgsql

select  get_full_name('докторская', 'технические науки')

drop function get_age(date,date)
create or replace function get_age(one date, two date, out res char(20))
as $$
declare 
	i int;
begin 
	i = two - one;
	res = to_char(i/365, '999') || ' лет';
	if i < 365 then
	res = to_char(i/12, '999') || ' месяцев';
	end if;

end
$$ language plpgsql

select  get_age('2000-1-1', '2022-2-2')



