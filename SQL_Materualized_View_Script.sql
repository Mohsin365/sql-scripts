select * from inventory;

-- VIEWS

-- view is database object created over an SQL query
-- view doesnot store data (it is just a representation of the underlying SQL query)
-- everytime a view is called, it just executes the underlying SQL query
-- it is like a virtual table



-- MATERIALIZED VIEW

create table random_table (id int, value decimal);

insert into random_table
select 1, random() from generate_series(1,100); -- generate_series() function only in postgre sql

insert into random_table
select 2, random() from generate_series(1,100);

select id, avg(value), count(*) from random_table
group by id;


-- materialized view is useful for faster data retrival (improves performance)
-- sql will not look execute materialized view everytime
-- it is executed once and we directly fetch data from the view 
-- (stores both query and data of the query)

-- create materialized view for above query
create or replace materialized view m_view
as
select id, avg(value), count(*) from random_table
group by id;

-- select all from materialized view
select * from m_view;

-- but it doesnot update itself
delete from random_table where id = 1;  -- here i am updating the table
select * from m_view; -- but m_view will show old data

-- we need to refresh m_view to get updated data
refresh materialized view m_view;

select * from m_view; -- now we have updated data from m_view 
