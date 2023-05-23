create or replace function cursors_and_fields(table_name char(20), out res char(20)) as $$
declare
--Переменные 
	index_name varchar(100);
	column_name varchar(100);
	str_out varchar(2000);	
--Курсоры
	--type ref_cur is ref cursor;
	ind refcursor;
	col refcursor;

begin
 	EXECUTE 'select indexname from pg_indexes where tablename=$1'
	INTO ind
	using table_name;
	loop fetch ind into index_name;
    exit when ind%notfound;
    str_out:=index_name||'(';
    
		EXECUTE 'select column_name from pg_indexes where tablename=$1 and indexname=$2'
		INTO col
		using table_name, index_name;
		loop fetch col into column_name;
		exit when col%notfound;
			str_out:=str_out||column_name||',';
		end loop;
    
    --dbms_output.put_line(rtrim(str_out,',')||')');
   	RAISE NOTICE '%,)', str_out;
	end loop;
end;
$$ language plpgsql;

select cursors_and_fields('authors')



select indexname from pg_indexes where tablename = 'authors'
select column_name from pg_indexes where tablename='authors' and indexname='authors_pkey'

create or replace function print_func(out res char(20)) as $$
declare
	zv varchar(200);
	ind record;
begin
	zv = 'authors';	
	--open ind for 'select indexname from pg_indexes where tablename=:tname' using 'authors';
	EXECUTE 'select indexname from pg_indexes where tablename=$1'
   INTO ind
   USING zv;
  res = ind;
end;
$$ language plpgsql;

select print_func()
select column_name from dba_ind_columns where table_name=$1 and index_name=$2

select * from pg_indexes
select * from pg_index


