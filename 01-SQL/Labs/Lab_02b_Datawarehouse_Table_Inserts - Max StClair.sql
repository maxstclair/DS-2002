-- --------------------------------------------------------------------------------------------------------------
-- TODO: Extract the appropriate data from the northwind database, and INSERT it into the Northwind_DW database.
-- --------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------
-- Populate dim_customers
-- ----------------------------------------------
TRUNCATE TABLE northwind_dw.dim_customers;

INSERT INTO `northwind_dw`.`dim_customers`
(`customer_id`,
`company`,
`last_name`,
`first_name`,
`job_title`,
`business_phone`,
`fax_number`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`)
SELECT `id`,
	`company`,
	`last_name`,
	`first_name`,
	`job_title`,
	`business_phone`,
	`fax_number`,
	`address`,
	`city`,
	`state_province`,
	`zip_postal_code`,
	`country_region`
FROM northwind.customers;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_customers;


-- ----------------------------------------------
-- Populate dim_employees
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`dim_employees`;

INSERT INTO `northwind_dw`.`dim_employees`
(`employee_id`,
`company`,
`last_name`,
`first_name`,
`email_address`,
`job_title`,
`business_phone`,
`home_phone`,
`fax_number`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`,
`web_page`)
SELECT `id`,
    `company`,
    `last_name`,
    `first_name`,
    `email_address`,
    `job_title`,
    `business_phone`,
    `home_phone`,
    `fax_number`,
    `address`,
    `city`,
    `state_province`,
    `zip_postal_code`,
    `country_region`,
    `web_page`
FROM `northwind`.`employees`;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_employees;


-- ----------------------------------------------
-- Populate dim_products
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`dim_products`;

INSERT INTO `northwind_dw`.`dim_products`
(`product_id`,
`product_code`,
`product_name`,
`standard_cost`,
`list_price`,
`reorder_level`,
`target_level`,
`quantity_per_unit`,
`discontinued`,
`minimum_reorder_quantity`,
`category`)
SELECT `id`,
	`product_code`,
	`product_name`,
	`standard_cost`,
	`list_price`,
	`reorder_level`,
	`target_level`,
	`quantity_per_unit`,
	`discontinued`,
	`minimum_reorder_quantity`,
	`category`
FROM `northwind`.`products`;
# TODO: Write a SELECT Statement to Populate the table;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_products;


-- ----------------------------------------------
-- Populate dim_shippers
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`dim_shippers`;

INSERT INTO `northwind_dw`.`dim_shippers`
(`shipper_id`,
`company`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`)
SELECT `id`,
	`company`,
	`address`,
	`city`,
	`state_province`,
	`zip_postal_code`,
	`country_region`
FROM `northwind`.`shippers`;
# TODO: Write a SELECT Statement to Populate the table;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_shippers;



-- ----------------------------------------------
-- Populate fact_orders
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`fact_orders`;

INSERT INTO `northwind_dw`.`fact_orders`
(`order_id`,
`customer_id`,
`employee_id`,
`product_id`,
`shipper_id`,
`order_date`,
`paid_date`,
`shipped_date`,
`payment_type`,
`shipping_fee`,
`quantity`,
`unit_price`,
`discount`,
`taxes`,
`tax_rate`,
`order_status`,
`order_details_status`)
SELECT od.id AS order_id,
	od.id AS order_detail_id,
    o.customer_id,
    o.employee_id,
    od.product_id,
    o.shipper_id,
    o.order_date,
    o.paid_date,
    o.shipped_date,
    o.payment_type,
    od.quantity,
    od.unit_price,
    od.discount,
    o.shipping_fee,
    o.taxes,
    o.tax_rate,
    os.status_name AS order_status,
    ods.status_name AS order_detail_status
FROM northwind.orders AS o
INNER JOIN northwind.orders_status AS od
ON o.status_id = os.id
RIGHT OUTER JOIN northwind.order_details AS od
ON o.id = od.order_id
INNER JOIN northwind.order_details_status AS ods
ON od.status_id = ods.id;


/* 
--------------------------------------------------------------------------------------------------
TODO: Write a SELECT Statement that:
- JOINS the northwind.orders table with the northwind.orders_status table
- JOINS the northwind.orders with the northwind.order_details table.
--  (TIP: Remember that there is a one-to-many relationship between orders and order_details).
- JOINS the northwind.order_details table with the northwind.order_details_status table.
--------------------------------------------------------------------------------------------------
- The column list I've included in the INSERT INTO clause above should be your guide to which 
- columns you're required to extract from each of the four tables. Pay close attention!
--------------------------------------------------------------------------------------------------
*/

SELECT o.*
	, os.status_name AS order_details_status
FROM northwind.orders AS o
INNER JOIN northwind.orders_status AS os
ON o.status_id = os.id;

SELECT od.*
	, ods.status_name AS order_details_status
FROM northwind.order_details AS od
INNER JOIN northwind.order_details_status AS ods
ON od.status_id = ods.id;


-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.fact_orders;



-- ----------------------------------------------
-- ----------------------------------------------
-- Next, create the date dimension and then -----
-- integrate the date, customer, employee -------
-- product and shipper dimension tables ---------
-- ----------------------------------------------
-- ----------------------------------------------


-- --------------------------------------------------------------------------------------------------
-- LAB QUESTION: Author a SQL query that returns the total (sum) of the quantity and unit price
-- for each customer (last name), sorted by the total unit price in descending order.
-- --------------------------------------------------------------------------------------------------
SELECT customers.`last_name` AS `customer_name`,
	SUM(orders.`quantity`) AS `total_quantity`,
    SUM(orders.`unit_price`) AS `total_unit_price`
FROM `northwind_dw`.`fact_orders` AS orders
INNER JOIN `northwind_dw`.`dim_customers` AS customers
ON orders.customer_key = customers.customer_key
GROUP BY customers.`last_name`
ORDER BY total_unit_price DESC;
