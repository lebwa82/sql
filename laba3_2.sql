create or replace function avtrep(out res char(20)) as $$
declare
  --Авторы
  c1 cursor for select * from authors order by id DESC;
  --Авторы с одинаковыми ФИО и датой рождения 
  c2 cursor (n21 varchar, n22 date, n23 int) for select * from authors 
  where authors.id != n23 and authors.full_name=n21 and authors.date_of_birth =n22; 
  --Диссертации автора с большим номером
  c3 cursor (n3 int) for select * from dissertations where dissertations.author=n3;
  --Диссертации автора с такойже датой рождения и ФИО
  c4 cursor  (n4 int) is select * from dissertations where dissertations.author=n4;
  --переменные
  v_c1_o authors%ROWTYPE;
begin
	open c1;	
	fetch c1 into v_c1_o;
	close c1;
	--Авторы	
	for v_c1 in c1 loop
		for v_c2 in c2(v_c1.full_name,v_c1.date_of_birth,v_c1.id) loop
			for v_c3 in c3(v_c1.id) loop
				for v_c4 in c4(v_c2.id) loop 
					if((v_c3.science_field=v_c4.science_field) and (v_c3.dissertation_type!=v_c4.dissertation_type)) then 
							update dissertations set author = v_c1.id 
								where author=v_c2.id;
							delete from authors where authors.id=v_c2.id;
					end if;
				end loop;
			end loop;		
		end loop;
	end loop;	
end;
$$ language plpgsql;

select avtrep()


INSERT INTO authors
values 
(default,'Поспелов Иван Николаевич', '2005-6-7', 'м', '455555555', '1900-1-22');
select * from authors a 

select * from dissertations
INSERT INTO dissertations
values
(default, 885, 6, 'Изучение зерна 4.0', 'докторская', '2023-2-6', 
'сельскохозяйственный универ', '2023-9-11', '402')


