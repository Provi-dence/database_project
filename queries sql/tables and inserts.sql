



Create database tester
go

use tester
go

-- Create users table
CREATE TABLE users (
  u_id INTEGER PRIMARY KEY NOT NULL,  -- User ID
  username VARCHAR(30) NOT NULL UNIQUE,             -- Username
  password VARCHAR(30) NOT NULL,                    -- Password
  u_type VARCHAR(30) NOT NULL,                      -- User type (e.g., admin, customer)
  status INTEGER NOT NULL                           -- Status (e.g., active, inactive)
);

-- Create admins table
CREATE TABLE admins (
  a_id INTEGER PRIMARY KEY,                         -- Admin ID
  a_name VARCHAR(50) NOT NULL,                      -- Admin name
  a_email VARCHAR(50),                              -- Admin email
  a_address VARCHAR(80),                            -- Admin address
  status INTEGER NOT NULL,                          -- Status (e.g., active, inactive)
  FOREIGN KEY (a_id) REFERENCES users(u_id) ON DELETE CASCADE  -- Foreign key reference to users table
);

-- Create customer table
CREATE TABLE customer (
  c_id INTEGER PRIMARY KEY,                         -- Customer ID
  c_name VARCHAR(50) NOT NULL,                      -- Customer name
  c_email VARCHAR(50),                              -- Customer email
  c_address VARCHAR(80),                            -- Customer address
  status INTEGER NOT NULL,                          -- Status (e.g., active, inactive)
  FOREIGN KEY (c_id) REFERENCES users(u_id) ON DELETE CASCADE  -- Foreign key reference to users table
);

-- Create items table
CREATE TABLE items (
  i_id INTEGER PRIMARY KEY,           -- Item ID
  isbn VARCHAR(15) UNIQUE,                          -- ISBN (International Standard Book Number)
  title VARCHAR(30) NOT NULL,                       -- Title of the item
  author VARCHAR(50),                               -- Author of the item
  genre VARCHAR(30),                                -- Genre of the item
  price DECIMAL(10,2),                              -- Price of the item
  i_type VARCHAR(15),                               -- Type of item (e.g., book, ebook)
  status INTEGER NOT NULL                           -- Status (e.g., available, out of stock)
);

-- Create itemsOrdered table
CREATE TABLE itemsOrdered (
  io_id INTEGER PRIMARY KEY,          -- Items ordered ID
  c_id INTEGER,                                     -- Customer ID
  i_id INTEGER,                                     -- Item ID
  qty INTEGER,                                      -- Quantity ordered
  status INTEGER NOT NULL,                          -- Status (e.g., pending, shipped)
  FOREIGN KEY (i_id) REFERENCES items(i_id) ON DELETE CASCADE,  -- Foreign key reference to items table
  FOREIGN KEY (c_id) REFERENCES customer(c_id) ON DELETE CASCADE  -- Foreign key reference to customer table
);

-- Create payment table
CREATE TABLE payment (
  payment_id INTEGER PRIMARY KEY,     -- Payment ID
  c_id INTEGER,                                     -- Customer ID
  amount DECIMAL(10,2),                             -- Payment amount
  payment_date DATE,                                -- Date of payment
  status INTEGER NOT NULL,                          -- Status (e.g., pending, completed)
  FOREIGN KEY (c_id) REFERENCES customer(c_id) ON DELETE CASCADE  -- Foreign key reference to customer table
);

-- Create shipping_address table
CREATE TABLE shipping_address (
  address_id INTEGER PRIMARY KEY,    -- Address ID
  c_id INTEGER,                                    -- Customer ID
  address_line1 VARCHAR(100),                      -- Address line 1
  address_line2 VARCHAR(100),                      -- Address line 2
  city VARCHAR(50),                                -- City
  postal_code VARCHAR(20),                         -- Postal code
  status INTEGER NOT NULL,                         -- Status (e.g., active, inactive)
  FOREIGN KEY (c_id) REFERENCES customer(c_id) ON DELETE CASCADE  -- Foreign key reference to customer table
);

-- Create cart table
CREATE TABLE cart (
    cart_id INTEGER,                               -- Cart ID
    date_created DATE,                             -- Date and time when the cart was created
    PRIMARY KEY (cart_id),                         -- Primary key constraint
    FOREIGN KEY (cart_id) REFERENCES customer(c_id) ON DELETE CASCADE  -- Foreign key reference to customer table
);

-- Create orders table
CREATE TABLE orders (
    o_id INTEGER,                                  -- Order ID
    o_date DATE,                                   -- Order date
    ship_address_id INTEGER,                       -- Shipping address ID
    c_id INTEGER,                                  -- Customer ID
    io_id INTEGER,                                 -- Items ordered ID
    payment_id INTEGER,                            -- Payment ID
    PRIMARY KEY (o_id),                            -- Primary key constraint
    FOREIGN KEY (c_id) REFERENCES customer(c_id),
    FOREIGN KEY (io_id) REFERENCES itemsOrdered(io_id),
    FOREIGN KEY (ship_address_id) REFERENCES shipping_address(address_id),
    FOREIGN KEY (payment_id) REFERENCES payment(payment_id) ON DELETE CASCADE  -- Foreign key reference to payment table
);

-- Create orders_payment table (Many-to-Many relationship between orders and payment)
CREATE TABLE orders_payment (
    o_id INTEGER,                                  -- Order ID
    payment_id INTEGER,                            -- Payment ID
    PRIMARY KEY (o_id, payment_id),                -- Primary key constraint
    FOREIGN KEY (o_id) REFERENCES orders(o_id),  -- Foreign key reference to orders table
    FOREIGN KEY (payment_id) REFERENCES payment(payment_id) ON DELETE CASCADE  -- Foreign key reference to payment table
);




-- Inserting data into the users table /
INSERT INTO users (u_id, username, password, u_type, status) VALUES
(1, 'admin1', 'admin123', 'admin', 1),
(2, 'customer1', 'customer123', 'customer', 1),
(3, 'admin2', 'admin456', 'admin', 1),
(4, 'customer2', 'customer456', 'customer', 1),
(5, 'customer3', 'customer789', 'customer', 1);

-- Inserting data into the admins table /
INSERT INTO admins (a_id, a_name, a_email, a_address, status) VALUES
(1, 'Admin One', 'admin1@example.com', '123 Admin Street', 1);

-- Inserting data into the customer table /
INSERT INTO customer (c_id, c_name, c_email, c_address, status) VALUES
(2, 'Customer One', 'customer1@example.com', '456 Customer Avenue', 1),
(3, 'Customer Two', 'customer2@example.com', '789 Customer Street', 1),
(4, 'Customer Three', 'customer3@example.com', '321 Customer Road', 1);

-- Inserting data into the items table /
INSERT INTO items (i_id, isbn, title, author, genre, price, i_type, status) VALUES
(1, '1234567890123', 'Sample Book', 'Sample Author', 'Sample Genre', 19.99, 'book', 1),
(2, '9876543210987', 'Another Book', 'Another Author', 'Another Genre', 29.99, 'book', 1),
(3, '4561237890456', 'Yet Another Book', 'Yet Another Author', 'Yet Another Genre', 39.99, 'book', 1);

-- Inserting data into the itemsOrdered table
INSERT INTO itemsOrdered (io_id, c_id, i_id, qty, status) VALUES
(1, 2, 1, 2, 1),
(2, 3, 2, 1, 1),
(3, 4, 3, 3, 1);

-- Inserting data into the payment table
INSERT INTO payment (payment_id, c_id, amount, payment_date, status) VALUES
(1, 2, 39.98, '2024-03-04', 1),
(2, 3, 119.97, '2024-03-04', 1),
(3, 4, 29.99, '2024-03-04', 1);


-- Inserting data into the shipping_address table
INSERT INTO shipping_address (address_id, c_id, address_line1, address_line2, city, postal_code, status) VALUES
(1, 2, '123 Shipping St', '', 'Shipping City', '12345', 1),
(2, 3, '456 Shipping St', '', 'Shipping City', '45678', 1),
(3, 4, '789 Shipping St', '', 'Shipping City', '78910', 1);
 /
-- Inserting data into the cart table
INSERT INTO cart (cart_id, date_created) VALUES
(2, '2024-03-04'),
(3, '2024-03-04'),
(4, '2024-03-04');


-- Delete existing row with cart_id = 2
DELETE FROM cart WHERE cart_id = 2;

-- Re-insert data into the cart table
INSERT INTO cart (cart_id, date_created) VALUES
(2, '2024-03-04');


-- Inserting data into the orders table
INSERT INTO orders (o_id, o_date, ship_address_id, c_id, io_id, payment_id) VALUES
(1, '2024-03-04', 1, 2, 1, 1),
(2, '2024-03-04', 2, 3, 2, 2),
(3, '2024-03-04', 3, 4, 3, 3);

-- Inserting data into the orders_payment table
INSERT INTO orders_payment (o_id, payment_id) VALUES
(1, 1),
(2, 2),
(3, 3);



select * from [dbo].[admins]
select * from [dbo].[cart]
select * from [dbo].[customer]
select * from [dbo].[items]
select * from [dbo].[itemsOrdered]
select * from [dbo].[orders]
select * from [dbo].[orders_payment]
select * from [dbo].[payment]
select * from [dbo].[shipping_address]
select * from [dbo].[users]
