-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE IF EXISTS employee, customer_and_account_info, invoice_frequency, products, metadata, invoice_header CASCADE;

CREATE TABLE employee (
  emp_id serial PRIMARY KEY,
  emp_name varchar(255) UNIQUE
);

CREATE TABLE customer_and_account_info (
  customer_and_account_id serial PRIMARY KEY,
  customer_and_account_no varchar(255) UNIQUE
);

CREATE TABLE invoice_frequency (
  invoice_freq_id serial PRIMARY KEY,
  invoice_frequency varchar(255) UNIQUE
);

CREATE TABLE products (
  product_id serial PRIMARY KEY,
  product_name varchar(255) UNIQUE
);

CREATE TABLE metadata (
  emp_id varchar(255),
  customer_and_account_id varchar(255),
  product_id varchar(255),
  sale_date date,
  sale_amount varchar(255),
  units_sold integer,
  invoice_no integer,
  invoice_frequency_id varchar(255)
);

CREATE TABLE invoice_header (
  id SERIAL PRIMARY KEY,
  emp_id integer REFERENCES employee(emp_id),
  customer_and_account_id integer REFERENCES customer_and_account_info(customer_and_account_id),
  product_id integer REFERENCES products(product_id),
  sale_date date,
  sale_amount varchar(255),
  units_sold integer,
  invoice_no integer,
  invoice_frequency_id integer REFERENCES invoice_frequency(invoice_freq_id)
);

\copy metadata FROM 'sales.csv' DELIMITER ',' CSV HEADER;
