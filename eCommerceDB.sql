-- Step 1 Create the database eCommerceDB

CREATE DATABASE eCommerceDB;
-- Select the eCommerceDB database to use for the following operations
SHOW DATABASES;
USE eCommerceDB; 
-- Confirm the selected database
SELECT DATABASE();

-- Step 2 Create tables with relationships

-- 2.1 Products table - create the tbl_products to 
-- with column/fields: 
-- productID (primaryKey), Name, Description, Price, stockQuantity

CREATE TABLE tbl_products (
    productID INT AUTO_INCREMENT PRIMARY KEY,   -- Unique identifier for each product
    name VARCHAR(100) NOT NULL,                  -- Product name
    description TEXT,                            -- Description of the product
    price DECIMAL(10, 2) NOT NULL,               -- Price of the product
    stockQuantity INT NOT NULL                  -- Quantity of the product in stock
);

-- See table structure
DESC tbl_products;

-- 2.2 Customer table - create the tbl_customers 
-- with column/fields:
-- customerID (primaryKey), firstName, lastName, email, phoneNumber, address)

CREATE TABLE tbl_customers (
    customerID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each customer
    firstName VARCHAR(50) NOT NULL,             -- Customer's first name
    lastName VARCHAR(50) NOT NULL,              -- Customer's last name
    email VARCHAR(100) NOT NULL,                -- Customer's email address
    phoneNumber VARCHAR(15),                    -- Customer's phone number
    address TEXT                                -- Customer's address
);

DESC tbl_customers;

-- 2.3 Orders table - create the tbl_orders to
-- record customer orders and create relationship with tbl_customers
-- Columns/fields: orderID (primaryKey), customerID (foreignKey), orderDate, status, 

CREATE TABLE tbl_orders (
    orderID INT AUTO_INCREMENT PRIMARY KEY,     
    -- Unique identifier for each order
    customerID INT,                             
    -- Foreign key to identify the customer who placed the order
    orderDate DATETIME DEFAULT 
    CURRENT_TIMESTAMP,  -- Date and time when the order was placed
    status ENUM
    ('Pending', 'Shipped', 'Delivered', 'Cancelled') 
    DEFAULT 'Pending',  -- Status of the order
    FOREIGN KEY (customerID) 
    REFERENCES tbl_customers (customerID) 
    ON DELETE CASCADE   -- Delete orders if the customer is deleted
);
DESC tbl_orders;

-- 2.4 Order items table - create tbl_orderItems
-- record each item within an order and 
-- create relationship with tbl_products and tbl_orders
-- columns/fields: orderItemID (primaryKey), orderID (foreignKey), 
-- productID (foreignKey), quantity and price. 
CREATE TABLE tbl_orderItems (
    orderItemID INT AUTO_INCREMENT PRIMARY KEY, 
    -- Unique identifier for each order item
    orderID INT,                                 
    -- Foreign key linking to the Orders table
    productID INT,                               
    -- Foreign key linking to the Products table
    quantity INT NOT NULL,                        
    -- Quantity of the product ordered
    price DECIMAL(10, 2) NOT NULL,                
    -- Price of the product at the time of order
    FOREIGN KEY (orderID) 
    REFERENCES tbl_orders (orderID) 
    -- Creating relationship with primaryKey in tbl_orders
    ON DELETE CASCADE, -- Delete order items if the order is deleted
    FOREIGN KEY (productID) 
    REFERENCES tbl_products (productID)              
    -- -- Creating relationship with primaryKey in tbl_products
);

DESC tbl_orderItems;
SHOW TABLES;
-- Step 3 - Insert records and date into tbl_products (5 products min),
-- tbl_customers (5 customers min), and tbl_order (10 orders min)

-- 3.1 - Insert 5 products into tbl_products using the created column/fields
INSERT INTO tbl_products (name, description, price, stockQuantity) 
VALUES
('Laptop', 'High performance laptop', 1200.00, 10),
('Headphones', 'Noise cancelling headphones', 150.00, 30),
('Mouse', 'Wireless mouse', 25.00, 50),
('Keyboard', 'Mechanical keyboard', 75.00, 20),
('Monitor', '27-inch 4K display', 300.00, 15);

-- -- List all records in the table products to confirm data added
SELECT * FROM tbl_products;

-- 3.2 - Insert 5 customer records into tbl_customers using the created columns
INSERT INTO tbl_customers (firstName, lastName, email, phoneNumber, address) 
VALUES
('Cob', 'Medwell', 'cmedwell0@npr.org', '07555 987654', 'Liverpool'),
('Leonie', 'Masham', 'lmasham1@gmail.com', '07444 222111', 'Birmingham'),
('Bastien', 'Springle', 'bspringle2@hotmail.co.uk', '07911 123456', 'SW1A 1AA'),
('Kipp', 'Velasquez', 'kvelasquez3@marketwatch.com', '07822 555444', '222 Imaginary Drive'),
('Evangeline', 'Nevett', 'enevett4@msn.com', '07822 555444', 'Manchester');

-- List all records in the table customers to confirm data added
SELECT * FROM tbl_customers;

-- 3.3 Insert 10 customer orders into tbl_orders using created column/fields

INSERT INTO tbl_orders (customerID, orderDate, status) 
VALUES
(1, '2024-07-20 10:30:00', 'Pending'),
(2, '2024-07-21 14:15:00', 'Shipped'),
(3, '2024-07-22 09:45:00', 'Delivered'),
(4, '2024-07-23 16:30:00', 'Delivered'),
(5, '2024-07-24 11:20:00', 'Cancelled'),
(1, '2024-07-25 12:50:00', 'Shipped'),
(2, '2024-07-26 15:00:00', 'Delivered'),
(3, '2024-07-27 08:00:00', 'Pending'),
(5, '2024-07-28 17:30:00', 'Shipped'),
(5, '2024-07-29 13:45:00', 'Pending');

-- List all records in the table orders to confirm data added
SELECT * FROM tbl_orders;

-- 3.4 Insert records into tbl_orderItems using it's column/fields

INSERT INTO tbl_orderItems (orderID, productID, quantity, price) 
VALUES
(1, 1, 1, 1200.00),    -- Order 1: 1 Laptop
(1, 2, 1, 150.00),     -- Order 1: 1 Headphones
(2, 3, 2, 25.00),      -- Order 2: 2 Mice
(3, 4, 1, 75.00),      -- Order 3: 1 Keyboard
(4, 5, 1, 300.00),     -- Order 4: 1 Monitor
(5, 1, 1, 1200.00),    -- Order 5: 1 Laptop
(6, 2, 3, 150.00),     -- Order 6: 3 Headphones
(7, 3, 4, 25.00),      -- Order 7: 4 Mice
(8, 4, 2, 75.00),      -- Order 8: 2 Keyboards
(9, 5, 1, 300.00),     -- Order 9: 1 Monitor
(10, 1, 2, 1200.00);   -- Order 10: 2 Laptops

-- List all records in the table orderItems to confirm data added
SELECT * FROM tbl_orderItems;

-- Step 4 Queries
-- 4.1 listing all orders along with their status and
-- customer details (firstName, lastName and email)

SELECT tbl_orders.orderID, tbl_orders.orderDate, 
tbl_orders.status, tbl_customers.firstName, 
tbl_customers.lastName, tbl_customers.email
FROM tbl_orders
INNER JOIN tbl_customers ON tbl_orders.customerID = tbl_customers.customerID
ORDER BY tbl_orders.orderDate;

-- 4.2 Query to calculate days since a customer placed an order
SELECT 
tbl_customers.customerID,
CONCAT(tbl_customers.firstName, 
' ', tbl_customers.lastName) AS fullName,
tbl_orders.orderID,
tbl_orders.orderDate,
DATEDIFF(CURDATE(), tbl_orders.orderDate) 
AS daysSinceOrder
FROM 
tbl_customers
INNER JOIN 
tbl_orders ON tbl_customers.customerID 
= tbl_orders.customerID
ORDER BY 
daysSinceOrder DESC;



-- Step 5 Update product stock after an order is placed
-- Check initial stock quantities for products in orderID = 1
SELECT productID, stockQuantity 
FROM tbl_products
WHERE productID IN (SELECT productID FROM tbl_orderItems WHERE orderID = 1);

UPDATE tbl_products
SET stockQuantity = stockQuantity 
- (SELECT quantity FROM tbl_orderItems 
WHERE productID = tbl_products.productID 
AND orderID = 1)
WHERE productID IN 
(SELECT productID 
FROM tbl_orderItems 
WHERE orderID = 1);

-- Check updated stock quantities for products in orderID = 1
SELECT productID, stockQuantity 
FROM tbl_products
WHERE productID IN (SELECT productID FROM tbl_orderItems WHERE orderID = 1);

-- Step 6 Generating reports for total sales by product, total orders by customer 
-- 6.1 Total sales by product using the sum up
-- quantity * price for each productID in table orderItems 
-- and join with table products to get the product names
SELECT tbl_products.productID, 
tbl_products.name, 
SUM(tbl_orderItems.quantity * tbl_orderItems.price) 
AS total_sales
FROM tbl_orderItems
INNER JOIN tbl_products ON tbl_orderItems.productID = tbl_products.productID
GROUP BY tbl_products.productID
ORDER BY total_sales DESC;

-- 6.2 Total orders by customer, by counting the number of
-- orderIDs in the orders table grouped by customerID and 
-- join with customers table to get customer details
SELECT tbl_customers.customerID, 
tbl_customers.firstName, 
tbl_customers.lastName, 
COUNT(tbl_orders.orderID) 
AS total_orders
FROM tbl_orders
JOIN tbl_customers ON 
tbl_orders.customerID 
= tbl_customers.customerID
GROUP BY tbl_customers.customerID
ORDER BY total_orders DESC;

-- 6.3 Total order value per customer
-- Obtaining customer firstName and lastName as 'fullName'
-- Calculating the SUM total number of ordered items * price
-- to give a total order value
-- join tables customers, orders and orderItems
SELECT 
tbl_customers.customerID,
CONCAT(tbl_customers.firstName, 
' ', tbl_customers.lastName) AS fullName,
SUM(tbl_orderItems.price 
* tbl_orderItems.quantity) AS totalOrderValue
FROM 
tbl_customers
INNER JOIN 
tbl_orders ON 
tbl_customers.customerID 
= tbl_orders.customerID
INNER JOIN 
tbl_orderItems ON 
tbl_orders.orderID 
= tbl_orderItems.orderID
GROUP BY 
tbl_customers.customerID
ORDER BY
totalOrderValue DESC;


-- Added procedures (not mentioned in the project brief)
-- Procedure 1
-- Using a stored procedure for when all or specific customer
-- detailed record wants to be viewed 
-- providing customer details and products ordered.
DELIMITER $$
CREATE PROCEDURE GetCustomerOrderDetails(
IN p_customerID INT
)
BEGIN
SELECT 
tbl_customers.customerID,
CONCAT(tbl_customers.firstName, ' ', tbl_customers.lastName) AS fullName,
tbl_customers.email,
tbl_customers.address,
tbl_orders.orderID,
tbl_products.productID,
tbl_products.name AS productName,
tbl_products.description,
tbl_orderItems.price AS productPrice,
tbl_orderItems.quantity,
FORMAT(tbl_orderItems.price * tbl_orderItems.quantity, 2) AS totalProductValue
FROM 
tbl_customers
INNER JOIN 
tbl_orders ON tbl_customers.customerID = tbl_orders.customerID
INNER JOIN 
tbl_orderItems ON tbl_orders.orderID = tbl_orderItems.orderID
INNER JOIN 
tbl_products ON tbl_orderItems.productID = tbl_products.productID
WHERE 
p_customerID IS NULL OR tbl_customers.customerID = p_customerID
ORDER BY 
tbl_customers.customerID, tbl_orders.orderID, tbl_products.productID;
END $$

DELIMITER $$

-- To call the procedure and generate the report
-- retrieves the detailed order report for the customer/s
-- by using NULL (to get all customers
-- by using customerID = 3 for example for a specific customer report
CALL GetCustomerOrderDetails(NULL);
CALL GetCustomerOrderDetails(3);

-- Procedure 2 - Retrieve a pickingList for pending orders
-- for when an eCommerce company needs to
-- pick items from their stored location
DELIMITER $$

CREATE PROCEDURE GetPickingList()
BEGIN
SELECT 
tbl_products.productID,
tbl_products.name AS productName,
SUM(tbl_orderItems.quantity) AS totalQty
FROM 
tbl_orderItems
INNER JOIN 
tbl_orders ON tbl_orderItems.orderID = tbl_orders.orderID
INNER JOIN 
tbl_products ON tbl_orderItems.productID = tbl_products.productID
WHERE 
tbl_orders.status = 'Pending'
GROUP BY 
tbl_products.productID, tbl_products.name
ORDER BY 
totalQty DESC;
END $$

DELIMITER $$

-- Retrieve pickingList by calling the procedure
CALL GetPickingList();


-- Adding CASE for updating product stockQuantity
-- in the products table
SELECT * FROM tbl_products;

UPDATE tbl_products
SET stockQuantity = 
(CASE productID
    WHEN 1 THEN stockQuantity + 5  -- Add by 5 for productID 1
    WHEN 2 THEN stockQuantity + 2  -- Add by 2 for productID 2
    WHEN 4 THEN stockQuantity + 10 -- Add by 10 for productID 4
    ELSE stockQuantity                         -- No change for other productIDs
END)
WHERE productID IN (1, 2, 4);


-- Step 7 ON DELETE CASCADE has been implemented into
-- the tbl_orderItems
-- When an order record is deleted from tbl_orders
-- all the related items in orderItems table will also 
-- be deleted

-- inserting a new order
INSERT INTO tbl_orders (customerID, orderDate, status) 
VALUES
(2, '2024-08-13 13:40:00', 'Pending');

-- inserting data related to new orderID = 11
INSERT INTO tbl_orderItems (orderID, productID, quantity, price) 
VALUES
(11, 1, 3, 1200.00);    -- Order 11: 3 Laptops

-- new order has been created with orderID = 11
SELECT * FROM tbl_orders;
-- new orderItems record created with orderItems = 12
SELECT * FROM tbl_orderItems;

-- delete record with orderID = 11 
-- on doing so this will then delete the related record 
-- in orderItems table
DELETE FROM tbl_orders WHERE orderID = 11;



