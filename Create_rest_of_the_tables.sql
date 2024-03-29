
CREATE TABLE sales_person(
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	email VARCHAR(60) NOT NULL,
	street VARCHAR(50) NOT NULL,
	city VARCHAR(40) NOT NULL,
	state CHAR(2) NOT NULL DEFAULT 'PA',
	zip SMALLINT NOT NULL,
	phone VARCHAR(20) NOT NULL,
	birth_date DATE NULL,
	sex sex_type NOT NULL,
	date_hired TIMESTAMP NOT NULL,
	id SERIAL PRIMARY KEY
);

CREATE TABLE product_type(
	name VARCHAR(30) NOT NULL,
	id SERIAL PRIMARY KEY
);


CREATE TABLE product(
	type_id INTEGER REFERENCES product_type(id),
	name VARCHAR(30) NOT NULL,
	supplier VARCHAR(30) NOT NULL,
	description TEXT NOT NULL,
	id SERIAL PRIMARY KEY
);


CREATE TABLE item(
	product_id INTEGER REFERENCES product(id),
	size INTEGER NOT NULL,
	color VARCHAR(30) NOT NULL,
	picture VARCHAR(256) NOT NULL,
	price NUMERIC(6,2) NOT NULL,
	id SERIAL PRIMARY KEY
);


CREATE TABLE sales_order(
	cust_id INTEGER REFERENCES customer(id),
	sales_person_id INTEGER REFERENCES sales_person(id),
	time_order_taken TIMESTAMP NOT NULL,
	purchase_order_number INTEGER NOT NULL,
	credit_card_number VARCHAR(16) NOT NULL,
	credit_card_exper_month SMALLINT NOT NULL,
	credit_card_exper_day SMALLINT NOT NULL,
	credit_card_secret_code SMALLINT NOT NULL,
	name_on_card VARCHAR(100) NOT NULL,
	id SERIAL PRIMARY KEY
);

CREATE TABLE sales_item(
	item_id INTEGER REFERENCES item(id),
	sales_order_id INTEGER REFERENCES sales_order(id),
	quantity INTEGER NOT NULL,
	discount NUMERIC(3,2) NULL DEFAULT 0,
	taxable BOOLEAN NOT NULL DEFAULT FALSE,
	sales_tax_rate NUMERIC(5,2) NOT NULL DEFAULT 0,
	id SERIAL PRIMARY KEY
);











