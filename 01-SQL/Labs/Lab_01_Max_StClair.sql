-- ----------------------------------------------------------------------------
-- 1). First, How Many Rows (Products) are in the Products Table?
-- ----------------------------------------------------------------------------

SELECT COUNT(*) AS row_count
FROM northwind.products;

-- ----------------------------------------------------------------------------
-- 2). Fetch Each Product Name and its Quantity per Unit
-- ----------------------------------------------------------------------------

SELECT product_name, quantity_per_unit FROM northwind.products;

-- ----------------------------------------------------------------------------
-- 3). Fetch the Product ID and Name of Currently Available Products
-- ----------------------------------------------------------------------------
SELECT id, product_name FROM northwind.products
WHERE discontinued = 0;

-- ----------------------------------------------------------------------------
-- 4). Fetch the Product ID, Name & List Price Costing Less Than $20
--     Sort the results with the most expensive Products first.
-- ----------------------------------------------------------------------------

SELECT id AS product_id
	, product_name
    , list_price
FROM northwind.products
WHERE list_price <= 20
ORDER BY list_price DESC;

-- ----------------------------------------------------------------------------
-- 5). Fetch the Product ID, Name & List Price Costing Between $15 and $20
--     Sort the results with the most expensive Products first.
-- ----------------------------------------------------------------------------
SELECT id AS product_id
	, product_name
	, list_price
FROM northwind.products
WHERE list_price BETWEEN 15 AND 20
ORDER BY list_price DESC;

-- Older (Equivalent) Syntax -----
SELECT id AS product_id
	, product_name
	, list_price
FROM northwind.products
WHERE list_price >= 15
AND list_price <= 20
ORDER BY list_price DESC;

-- ----------------------------------------------------------------------------
-- 6). Fetch the Product Name & List Price of the 10 Most Expensive Products 
--     Sort the results with the most expensive Products first.
-- ----------------------------------------------------------------------------
SELECT product_name, list_price
FROM northwind.products
ORDER BY list_price DESC 
LIMIT 10;

-- ----------------------------------------------------------------------------
-- 7). Fetch the Name & List Price of the Most & Least Expensive Products
-- ----------------------------------------------------------------------------
SELECT id AS product_id
	, product_name
    , list_price
FROM northwind.products 
WHERE list_price = (SELECT MAX(list_price) FROM northwind.products)
OR list_price = (SELECT MIN(list_price) FROM northwind.products);

-- ----------------------------------------------------------------------------
-- 8). Fetch the Product Name & List Price Costing Above Average List Price
--     Sort the results with the most expensive Products first.
-- ----------------------------------------------------------------------------
SELECT id AS product_id
	, product_name
    , list_price
FROM northwind.products 
WHERE list_price > (SELECT AVG(list_price) FROM northwind.products)
ORDER BY list_price DESC;

-- ---------------------------------------------------------------------------- 
-- 9). Fetch & Label the Count of Current and Discontinued Products using
-- 	   the "CASE... WHEN" syntax to create a column named "availablity"
--     that contains the values "discontinued" and "current". 
-- ----------------------------------------------------------------------------
UPDATE northwind.products SET discontinued = 1 WHERE id IN (95, 96, 97);

SELECT CASE discontinued
			WHEN 1 THEN 'discontinued'
			ELSE 'current'
		END AS availability
	, count(*) as product_count
FROM northwind.products
GROUP BY discontinued;

UPDATE northwind.products SET discontinued = 0 WHERE id in (95, 96, 97);

-- ----------------------------------------------------------------------------
-- 10). Fetch Product Name, Reorder Level, Target Level and "Reorder Threshold"
-- 	    Where Reorder Level is Less Than or Equal to 20% of Target Level
-- ----------------------------------------------------------------------------

SELECT product_name
	, reorder_level
    , target_level
    , ROUND(target_level/5) AS reorder_threshold
FROM northwind.products
WHERE reorder_level <= ROUND(target_level/5);

-- ----------------------------------------------------------------------------
-- 11). Fetch the Number of Products per Category Priced Less Than $20.00
-- ----------------------------------------------------------------------------

SELECT category
	, COUNT(*) AS product_count
FROM northwind.products
WHERE list_price < 20
GROUP BY category
ORDER BY category;

-- ----------------------------------------------------------------------------
-- 12). Fetch the Number of Products per Category With Less Than 5 Units In Stock
-- ----------------------------------------------------------------------------

SELECT category
	, COUNT(*) as units_in_stock
FROM northwind.products
GROUP BY category
HAVING units_in_stock < 5;

-- ----------------------------------------------------------------------------
-- 13). Fetch Products along with their Supplier Company & Address Info
-- ----------------------------------------------------------------------------

SELECT p.*
	, s.*
FROM northwind.products AS p
INNER JOIN northwind.suppliers AS s
ON s.id = p.supplier_ids;

-- ----------------------------------------------------------------------------
-- 14). Fetch the Customer ID and Full Name for All Customers along with
-- 		the Order ID and Order Date for Any Orders they may have
-- -------------------------------------------------------------------

SELECT c.id AS customer_id
	, CONCAT(c.first_name, " ", c.last_name) AS customer_name
    , o.id AS order_id
    , o.order_date
FROM northwind.customers AS c
LEFT OUTER JOIN northwind.orders AS o
ON c.id = o.customer_id
ORDER BY customer_id;

-- ----------------------------------------------------------------------------
-- 15). Fetch the Order ID and Order Date for All Orders along with
--   	the Customr ID and Full Name for Any Associated Customers
-- ----------------------------------------------------------------------------

SELECT o.id AS order_id
	, o.order_date
    , c.id AS customer_id
    , CONCAT(c.first_name, " ", c.last_name) AS customer_name
FROM northwind.customers AS c
RIGHT OUTER JOIN northwind.orders AS o
ON c.id = o.customer_id
ORDER BY customer_id;

