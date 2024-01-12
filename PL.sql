-- PL/pgSQL

-- PL 1
CREATE OR REPLACE FUNCTION fn_get_price_product_name(prod_name varchar) 
RETURNS numeric AS
$body$
	BEGIN
	RETURN item.price
	FROM item
	NATURAL JOIN product
	WHERE product.name = prod_name;
	END
$body$
LANGUAGE plpgsql

SELECT fn_get_price_product_name('Grandview');

-- PL 2
CREATE OR REPLACE FUNCTION fn_get_random_number(min_val int, max_val int) 
RETURNS int AS
$body$
	DECLARE
		rand int;
	BEGIN
		SELECT random()*(max_val - min_val) + min_val INTO rand;
		RETURN rand;
	END;
$body$
LANGUAGE plpgsql

SELECT fn_get_random_number(1, 5);

-- PL 3
CREATE OR REPLACE FUNCTION fn_get_random_salesperson() 
RETURNS varchar AS
$body$
	DECLARE
		rand int;
		emp record;
	BEGIN
		SELECT random()*(5 - 1) + 1 INTO rand;
		SELECT *
		FROM sales_person
		INTO emp
		WHERE id = rand;
		RETURN CONCAT(emp.first_name, ' ', emp.last_name);		
	END;
$body$

LANGUAGE plpgsql

SELECT fn_get_random_salesperson();

-- PL 4
CREATE OR REPLACE FUNCTION fn_get_cust_birthday(IN the_month int, OUT bd_month int, OUT bd_day int, 
												OUT f_name varchar, OUT l_name varchar) AS
$body$
	BEGIN
		SELECT EXTRACT(MONTH FROM birth_date), EXTRACT(DAY FROM birth_date), 
		first_name, last_name 
		INTO bd_month, bd_day, f_name, l_name
    	FROM customer
    	WHERE EXTRACT(MONTH FROM birth_date) = the_month
		LIMIT 1;
	END;
$body$
LANGUAGE plpgsql

SELECT fn_get_cust_birthday(12);

-- Pl 5
CREATE OR REPLACE FUNCTION fn_get_sales_people() 
RETURNS SETOF sales_person AS
$body$
	BEGIN
		RETURN QUERY
		SELECT *
		FROM sales_person;
	END;
$body$
LANGUAGE plpgsql

SELECT (fn_get_sales_people()).*;

-- PL 6
CREATE OR REPLACE FUNCTION fn_get_10_expensive_prods() 
RETURNS TABLE (
	name varchar,
	supplier varchar,
	price numeric
) AS
$body$
	BEGIN
		RETURN QUERY
		SELECT product.name, product.supplier, item.price
		FROM item
		NATURAL JOIN product
		ORDER BY item.price DESC
		LIMIT 10;
	END;
$body$
LANGUAGE plpgsql

SELECT (fn_get_10_expensive_prods()).*;

-- PL 7
CREATE OR REPLACE FUNCTION fn_check_month_orders(the_month int) 
RETURNS varchar AS
$body$
	DECLARE total_orders int;
	BEGIN
		SELECT COUNT(purchase_order_number)
    	INTO total_orders
		FROM sales_order
		WHERE EXTRACT(MONTH FROM time_order_taken) = the_month;
		IF total_orders > 5 THEN
			RETURN CONCAT(total_orders, ' Orders : Doing Good');
		ELSEIF total_orders < 5 THEN
			RETURN CONCAT(total_orders, ' Orders : Doing Bad');
		ELSE
			RETURN CONCAT(total_orders, ' Orders : On Target');
		END IF;	
	END;
$body$ 
LANGUAGE plpgsql

SELECT fn_check_month_orders(12);

-- PL 8
CREATE OR REPLACE FUNCTION fn_check_month_orders_case(the_month int) 
RETURNS varchar AS
$body$
	DECLARE
		total_orders int;
	BEGIN
		SELECT COUNT(purchase_order_number)
    	INTO total_orders
		FROM sales_order
		WHERE EXTRACT(MONTH FROM time_order_taken) = the_month;
		CASE
			WHEN total_orders < 1 THEN
				RETURN CONCAT(total_orders, ' Orders : Terrible');
			WHEN total_orders > 1 AND total_orders < 5 THEN
				RETURN CONCAT(total_orders, ' Orders : Get Better');
			WHEN total_orders = 5 THEN
				RETURN CONCAT(total_orders, ' Orders : On Target');
			ELSE
				RETURN CONCAT(total_orders, ' Orders : Doing Good');
		END CASE;
	END;
$body$
LANGUAGE plpgsql

SELECT fn_check_month_orders_case(12);


-- PL 9
DO
$$
	DECLARE
		rec record;
	BEGIN
		FOR rec IN
			SELECT first_name, last_name
			FROM sales_person
			LIMIT 5
		LOOP
			RAISE NOTICE '%, %', rec.first_name, rec.last_name;
		END LOOP;
	END;
$$
LANGUAGE plpgsql

-- PL 10
CREATE OR REPLACE FUNCTION fn_get_supplier_value(the_supplier varchar) 
RETURNS varchar AS
$body$
DECLARE
	supplier_name varchar;
	price_sum numeric;
BEGIN
	SELECT product.supplier, SUM(item.price)
 	INTO supplier_name, price_sum
	FROM product, item
	WHERE product.supplier = the_supplier
	GROUP BY product.supplier;
	RETURN CONCAT(supplier_name, ' Inventory Value : $', price_sum);
END;
$body$
LANGUAGE plpgsql

SELECT fn_get_supplier_value('Nike');




















