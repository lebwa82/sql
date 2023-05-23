create or replace function dissertation_report
(dis_year int default extract(year from current_date), out res char(30)) as $$
declare
  --Разделы
  c1 cursor for select * from sections_of_science;
  --Направления 
  c2 cursor (n2 int) for select * from scientific_field where scientific_field.science_section=n2;
  --Диссертации
  c3 cursor (n3 int) for select * from dissertations 
  where extract(year from dissertations.approve_day) = dis_year
  and dissertations.science_field=n3 order by dissertations.dissertation_type;
  --Авторы
  c4 cursor (n4 int) for select full_name from authors where authors.id=n4;
 
  --переменные
  v_c4_fio authors.full_name%TYPE;
  
begin

	--цикл по разделам	
	for v_c1 in c1 loop
		RAISE NOTICE '%', v_c1.section_name;
		--цикл по направлениям
		for v_c2 in c2(v_c1.cipher) loop
			RAISE NOTICE '    %', v_c2.field_name;
			--цикл по диссертациям 
			for v_c3 in c3(v_c2.code) loop
				open c4(v_c3.author);
				fetch c4 into v_c4_fio;
				RAISE NOTICE '    %', '    '||rpad(get_initials(v_c4_fio),20)||rpad(TO_CHAR(v_c3.approve_day, 'yyymmdd'),15)||(v_c3.dissertation_type);
				close c4;
			end loop;
		end loop;
	end loop;	
	res = 'OK';
	EXCEPTION WHEN OTHERS 
	THEN
    res = 'ERROR';
	end
$$ language plpgsql;


select dissertation_report(2020);





