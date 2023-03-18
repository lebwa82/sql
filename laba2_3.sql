create or replace function avt(out res char(20)) as $$
declare
  --Авторы
  c1 cursor for select * from authors order by authors.id DESC;
  
  --Работы автора
  c2 cursor (n2 int) for select * from dissertations,scientific_field,sections_of_science 
  where dissertations.author=n2 and 
  scientific_field.code=dissertations.science_field and 
  sections_of_science.cipher=scientific_field.science_section;
  
  --Докторские работы автора по определенному разделу науки 
  c3 cursor (n31 int, n32 int) for select count(*) from dissertations,scientific_field,sections_of_science 
  where dissertations.author=n31 and 
  scientific_field.code=dissertations.science_field and 
  sections_of_science.cipher=n32 and
  dissertations.dissertation_type = 'докторская';
    
  --переменные 
  v_c3_n int;
  zv char(200);
  v_c1_o authors%ROWTYPE;
  

begin
	--Авторы	
	for v_c1 in c1 loop		
		zv:=v_c1.full_name;
		for v_c2 in c2(v_c1.id) loop
      		if(v_c2.dissertation_type = 'докторская') then
        		zv:=zv||' '||get_full_name(v_c2.dissertation_type, v_c2.field_name)||',';
      		end if;
       		if(v_c2.dissertation_type = 'кандидатская') then
        		open c3(v_c1.id,v_c2.cipher);
        		fetch c3 into v_c3_n;
        		if(v_c3_n=0) then
          			zv:=zv||' '||get_full_name(v_c2.dissertation_type, v_c2.field_name)||',';
        		end if;
        		close c3;
      		end if;
		end loop;
    RAISE NOTICE '%', zv;
	end loop;	
  
end;
$$ language plpgsql;


select avt()

create or replace function print_func(out res char(20)) as $$
declare
	zv char(200);
begin
	zv = '';
	zv = zv||get_full_name('докторская', 'астрологические науки');--||',';
	RAISE NOTICE 'zv = %', zv;
end;
$$ language plpgsql;


select print_func()
select get_full_name('докторская', 'технические науки')

