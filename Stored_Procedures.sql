-- Table
CREATE TABLE past_due(
id SERIAL PRIMARY KEY,
cust_id INTEGER NOT NULL,
balance NUMERIC(6,2) NOT NULL);

INSERT INTO past_due(cust_id, balance)
VALUES
(1, 123.45),
(2, 324.50);

SELECT * FROM past_due

-- Stored_Procedure
CREATE OR REPLACE PROCEDURE pr_debt_paid(
	past_due_id int,
	payment numeric)
AS
$body$
DECLARE

BEGIN
	UPDATE past_due
	SET balance = balance - payment
	WHERE id = past_due_id;
	COMMIT;
END;
$body$
LANGUAGE PLPGSQL;

CALL pr_debt_paid(1, 10.00);

SELECT * FROM past_due

-- Triggers
CREATE TABLE distributor(
	id SERIAL PRIMARY KEY,
	name varchar(100)
)

INSERT INTO distributor (name) VALUES ('Parawholesale'),('J & B Sales'),('Steel City Clothing');

CREATE TABLE distributor_audit(
	id SERIAL PRIMARY KEY,
	dist_id INT NOT NULL,
	name VARCHAR(100) NOT NULL,
	edit_date TIMESTAMP NOT NULL);


-- Trigger function

-- 1st Trigger
CREATE OR REPLACE FUNCTION fn_log_dist_name_change()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
AS
$body$
BEGIN
	IF NEW.name <> OLD.name THEN
		INSERT INTO distributor_audit
		(dist_id, name, edit_date)
		VALUES
		(OLD.id, OLD.name, NOW());
	END IF;
	RAISE NOTICE 'Trigger Name : %', TG_NAME;
	RAISE NOTICE 'Table Name : %', TG_TABLE_NAME;
	RAISE NOTICE 'Operation : %', TG_OP;
	RAISE NOTICE 'When Executed : %', TG_WHEN;
	RAISE NOTICE 'Row or Statement : %', TG_LEVEL;
	RAISE NOTICE 'Table Schema : %', TG_TABLE_SCHEMA;
	RETURN NEW;
END;
$body$


CREATE TRIGGER tr_dist_name_changed
	BEFORE UPDATE 
	ON distributor
	FOR EACH ROW
	EXECUTE PROCEDURE fn_log_dist_name_change();

UPDATE distributor
SET name = 'Western Clothing'
WHERE id = 2;

SELECT * FROM distributor_audit; 
SELECT * FROM distributor; 

	
-- 2nd Trigger
CREATE OR REPLACE FUNCTION fn_block_weekend_changes()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$body$
BEGIN
	RAISE NOTICE 'No database changes allowed on the weekend';
	RETURN NULL;
END;
$body$

CREATE OR REPLACE TRIGGER tr_block_weekend_changes
	BEFORE UPDATE OR INSERT OR DELETE OR TRUNCATE 
	ON distributor
	FOR EACH STATEMENT
	WHEN(
		EXTRACT('DOW' FROM CURRENT_TIMESTAMP) =2
	)
	EXECUTE PROCEDURE fn_block_weekend_changes();


UPDATE distributor
SET name = 'Western Clothing'
WHERE id = 2;

SELECT * FROM distributor; 

DROP TRIGGER tr_block_weekend_changes ON distributor;



