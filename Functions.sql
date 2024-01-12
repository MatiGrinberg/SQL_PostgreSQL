-- F1
CREATE OR REPLACE FUNCTION fn_get_value_inventory() 
RETURNS numeric as
$body$
	SELECT SUM(price)
	FROM item;	
$body$
LANGUAGE SQL

SELECT fn_get_value_inventory()

-- F2
CREATE OR REPLACE FUNCTION fn_number_customers() 
RETURNS numeric as
$body$
	SELECT count(*)
	FROM customer;	
$body$
LANGUAGE SQL

SELECT fn_number_customers()

-- F3
CREATE OR REPLACE FUNCTION fn_get_number_customers_from_state(state_name char(2)) 
RETURNS numeric as
$body$
	SELECT count(*)
	FROM customer
	WHERE state = state_name;	
$body$
LANGUAGE SQL

SELECT fn_get_number_customers_from_state('TX');

-- F4
CREATE OR REPLACE FUNCTION fn_get_number_orders_from_customer(cus_fname varchar, cus_lname varchar) 
RETURNS numeric as
$body$
	SELECT COUNT(*)
	FROM sales_order
	NATURAL JOIN customer
	WHERE customer.first_name = cus_fname AND customer.last_name = cus_lname;	
$body$
LANGUAGE SQL

SELECT fn_get_number_orders_from_customer('Christopher', 'Jones');

-- F5
CREATE OR REPLACE FUNCTION fn_get_last_order() 
RETURNS sales_order as
$body$
	SELECT *
	FROM sales_order
	ORDER BY time_order_taken DESC
	LIMIT 1;
$body$
LANGUAGE SQL

SELECT (fn_get_last_order()).*;
SELECT (fn_get_last_order()).time_order_taken;

--F6
CREATE OR REPLACE FUNCTION fn_get_employees_location(loc varchar) 
RETURNS SETOF sales_person as
$body$
	SELECT *
	FROM sales_person
	WHERE state = loc;
$body$
LANGUAGE SQL

SELECT (fn_get_employees_location('CA')).*;
SELECT first_name FROM fn_get_employees_location('CA');


















