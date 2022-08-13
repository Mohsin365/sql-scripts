
-- QUERY 1 :
drop table emp;
create table emp
( emp_ID int
, emp_NAME varchar(50)
, SALARY int);

insert into emp values(101, 'Mohan', 40000);
insert into emp values(102, 'James', 50000);
insert into emp values(103, 'Robin', 60000);
insert into emp values(104, 'Carol', 70000);
insert into emp values(105, 'Alice', 80000);
insert into emp values(106, 'Jimmy', 90000);

select * from emp;

-- WITH CLAUSE
-- aka CTE (common table expression)
-- aka Sub-Query Factoring

-- With clause appears before select statement 

-- it makes something like a temporary table as per the sub-query provided
-- and then use this data for further queries
-- improves performance

/*	syntax
 with <cte_name> (<column names returned by this cte>) as
 		<sub-query>
 OR
 with <cte_name> as 	-- don't need to specify column names here but is a good practice
 		<sub-query> 	-- specify column names in the sub-query itself
 */

-- cte
with avg_sal(avg_salary) as
		(select cast(avg(salary) as int) from emp)
-- main query
select * from emp e
join avg_sal av on e.salary > av.avg_salary;





-- QUERY 2 :
DrOP table sales ;
create table sales
(
	store_id  		int,
	store_name  	varchar(50),
	product			varchar(50),
	quantity		int,
	cost			int
);
insert into sales values
(1, 'Apple Originals 1','iPhone 12 Pro', 1, 1000),
(1, 'Apple Originals 1','MacBook pro 13', 3, 2000),
(1, 'Apple Originals 1','AirPods Pro', 2, 280),
(2, 'Apple Originals 2','iPhone 12 Pro', 2, 1000),
(3, 'Apple Originals 3','iPhone 12 Pro', 1, 1000),
(3, 'Apple Originals 3','MacBook pro 13', 1, 2000),
(3, 'Apple Originals 3','MacBook Air', 4, 1100),
(3, 'Apple Originals 3','iPhone 12', 2, 1000),
(3, 'Apple Originals 3','AirPods Pro', 3, 280),
(4, 'Apple Originals 4','iPhone 12 Pro', 2, 1000),
(4, 'Apple Originals 4','MacBook pro 13', 1, 2500);

select * from sales;


-- Find total sales per each store
select s.store_id, sum(s.cost) as total_sales_per_store
from sales s
group by s.store_id;


-- Find average sales with respect to all stores
select cast(avg(total_sales_per_store) as int) avg_sale_for_all_store
from (select s.store_id, sum(s.cost) as total_sales_per_store
	from sales s
	group by s.store_id) x;



-- Find stores who's sales were better than the average sales accross all stores
select *
from   (select s.store_id, sum(s.cost) as total_sales_per_store
				from sales s
				group by s.store_id
	   ) total_sales
join   (select cast(avg(total_sales_per_store) as int) avg_sale_for_all_store
				from (select s.store_id, sum(s.cost) as total_sales_per_store
		  	  		from sales s
			  			group by s.store_id) x
	   ) avg_sales
on total_sales.total_sales_per_store > avg_sales.avg_sale_for_all_store;

-- above we are again writing same code multiple  times
-- writing multiple sub queries making it complex
-- so WITH clause can be used

-- Using WITH clause
WITH total_sales as		-- first cte
		(select s.store_id, sum(s.cost) as total_sales_per_store
		from sales s
		group by s.store_id),
		
	avg_sales as		-- second cte
		(select cast(avg(total_sales_per_store) as int) avg_sale_for_all_store
		from total_sales)
		
-- main query using above 2 CTEs		
select *
from   total_sales
join   avg_sales
on total_sales.total_sales_per_store > avg_sales.avg_sale_for_all_store;
