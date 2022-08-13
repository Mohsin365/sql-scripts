use demo;

/* CREATING THE TABLES */
select * from products;
select * from sales;

drop table sales;
drop table products;

create table products
(
	product_code			varchar(20) primary key,
	product_name			varchar(100),
	price					float,
	quantity_remaining		int,
	quantity_sold			int
);

create table sales
(
	order_id			int auto_increment primary key,
	order_date			date,
	product_code		varchar(20) references products(product_code),
	quantity_ordered	int,
	sale_price			float
);

insert into products (product_code,product_name,price,quantity_remaining,quantity_sold)
	values ('P1', 'iPhone 13 Pro Max', 1200, 5, 195);
insert into products (product_code,product_name,price,quantity_remaining,quantity_sold)
	values ('P2', 'AirPods Pro', 279, 10, 90);
insert into products (product_code,product_name,price,quantity_remaining,quantity_sold)
	values ('P3', 'MacBook Pro 16', 5000, 2, 48);
insert into products (product_code,product_name,price,quantity_remaining,quantity_sold)
	values ('P4', 'iPad Air', 650, 1, 9);

insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('10-01-2022','%d-%m-%Y'), 'P1', 100, 120000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('20-01-2022','%d-%m-%Y'), 'P1', 50, 60000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('05-02-2022','%d-%m-%Y'), 'P1', 45, 540000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('15-01-2022','%d-%m-%Y'), 'P2', 50, 13950);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('25-03-2022','%d-%m-%Y'), 'P2', 40, 11160);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('25-02-2022','%d-%m-%Y'), 'P3', 10, 50000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('15-03-2022','%d-%m-%Y'), 'P3', 10, 50000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('25-03-2022','%d-%m-%Y'), 'P3', 20, 100000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('21-04-2022','%d-%m-%Y'), 'P3', 8, 40000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('27-04-2022','%d-%m-%Y'), 'P4', 9, 5850);



/* CREATING THE PROCEDURE */
drop procedure if exists pr_buy_products;

DELIMITER $$

create procedure pr_buy_products(p_product_name varchar, p_quantity int)
begin
	declare v_cnt           int;
	declare v_product_code  varchar(20);
	declare v_price         int;

    select count(*)
    into v_cnt
    from products
    where product_name = p_product_name
    and quantity_remaining >= p_quantity;

    if v_cnt > 0
    then
        select product_code, price
        into v_product_code, v_price
        from products
        where product_name = p_product_name
        and quantity_remaining >= p_quantity;

        insert into sales (order_date,product_code,quantity_ordered,sale_price)
			values (cast(now() as date), v_product_code, p_quantity, (v_price * p_quantity));

        update products
        set quantity_remaining = (quantity_remaining - p_quantity)
        , quantity_sold = (quantity_sold + p_quantity)
        where product_code = v_product_code;

        select 'Product sold!';
    else
        select 'Insufficient Quantity!';
    end if;
end$$
