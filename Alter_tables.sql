
-- Add a new column
ALTER TABLE sales_item ADD day_of_week VARCHAR(8);
-- Modify a column
ALTER TABLE sales_item ALTER COLUMN day_of_week SET NOT NULL;
-- Change name of a column
ALTER TABLE sales_item RENAME COLUMN day_of_week TO weekday;
-- Drop a column
ALTER TABLE sales_item DROP COLUMN weekday;

-- Add a new table
CREATE TABLE transaction_type(
	name VARCHAR(30) NOT NULL,
	payment_type VARCHAR(30) NOT NULL,
	id SERIAL PRIMARY KEY
);

-- Rename table
ALTER TABLE transaction_type RENAME TO transaction;

-- Create index based on a single column
CREATE INDEX transaction_id ON transaction(name);
-- Create an index based on 2 columns
CREATE INDEX transaction_id_2 ON transaction(name, payment_type);

-- Delete data in a table
TRUNCATE TABLE transaction;
-- Drop a table
DROP TABLE transaction;