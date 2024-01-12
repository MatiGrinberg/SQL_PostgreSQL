
-- simple SELECT
SELECT * FROM sales_item WHERE discount > .15 ORDER BY discount;
SELECT time_order_taken FROM sales_order WHERE time_order_taken > '2018-12-01' AND time_order_taken < '2018-12-31';
SELECT time_order_taken FROM sales_order WHERE time_order_taken BETWEEN '2018-12-01' AND '2018-12-31';
SELECT * FROM sales_item WHERE discount > .15 ORDER BY discount DESC;
SELECT * FROM sales_item WHERE discount > .15 ORDER BY discount DESC LIMIT 5;
SELECT CONCAT(first_name,  ' ', last_name) AS Name, phone, state FROM customer WHERE state = 'TX';
SELECT product_id, SUM(price) AS Total FROM item WHERE product_id=1 GROUP BY product_id;
SELECT DISTINCT state FROM customer ORDER BY state;
SELECT DISTINCT state FROM customer WHERE state != 'CA' ORDER BY state;
SELECT DISTINCT state FROM customer WHERE state IN ('CA', 'NJ') ORDER BY state;
-- JOINs
SELECT item_id, price FROM item INNER JOIN sales_item ON item.id = sales_item.item_id ORDER BY item_id;
SELECT item_id, price FROM item INNER JOIN sales_item ON item.id = sales_item.item_id AND price > 120.00 
	ORDER BY item_id;
SELECT sales_order.id, sales_item.quantity, item.price, (sales_item.quantity * item.price) AS Total
	FROM sales_order JOIN sales_item ON sales_item.sales_order_id = sales_order.id
	JOIN item ON item.id = sales_item.item_id ORDER BY sales_order.id;
SELECT name, supplier, price FROM product LEFT JOIN item ON item.product_id = product.id ORDER BY name;
-- Union, Null, SIMILAR, LIKE ~, REGEXP
SELECT first_name, last_name, street, city, zip, birth_date FROM customer WHERE EXTRACT(MONTH FROM birth_date) = 12
	UNION SELECT first_name, last_name, street, city, zip, birth_date FROM sales_person 
	WHERE EXTRACT(MONTH FROM birth_date) = 12 ORDER BY birth_date;
SELECT product_id, price FROM item WHERE price = NULL;
SELECT first_name, last_name FROM customer WHERE first_name SIMILAR TO 'M%';
SELECT first_name, last_name FROM customer WHERE first_name LIKE 'A_____';
SELECT first_name, last_name FROM customer WHERE first_name SIMILAR TO 'D%' OR last_name SIMILAR TO '%n';
-- GroupBy
SELECT EXTRACT(MONTH FROM birth_date) AS Month, COUNT(*) AS Amount FROM customer GROUP BY Month ORDER BY Month;
SELECT EXTRACT(MONTH FROM birth_date) AS Month, COUNT(*) AS Amount FROM customer GROUP BY Month HAVING COUNT(*) > 1 ORDER BY Month;
-- AGGREGATE FUNCTIONS
SELECT COUNT(*) AS Items, SUM(price) AS Value, ROUND(AVG(price), 2) AS Avg, MIN(price) AS Min, MAX(price) AS Max FROM item;
-- Views
CREATE VIEW purchase_order_overview AS SELECT sales_order.purchase_order_number, customer.company, sales_item.quantity, 
product.supplier, product.name, item.price, (sales_item.quantity * item.price) AS Total, CONCAT(sales_person.first_name, ' ', sales_person.last_name) AS Salesperson
FROM sales_order JOIN sales_item ON sales_item.sales_order_id = sales_order.id
JOIN item ON item.id = sales_item.item_id JOIN customer ON sales_order.cust_id = customer.id
JOIN product ON product.id = item.product_id JOIN sales_person ON sales_person.id = sales_order.sales_person_id
ORDER BY purchase_order_number;








