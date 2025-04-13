
-- =========================================
-- BookStoreDB - MySQL Database Schema Script
-- =========================================

-- Create Database
CREATE DATABASE IF NOT EXISTS BookStoreDB;
USE BookStoreDB;

-- Table: book_language
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);

-- Table: publisher
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: author
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

-- Table: book
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    language_id INT,
    price DECIMAL(10,2),
    stock_quantity INT,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

-- Table: book_author (many-to-many)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Table: country
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Table: address
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Table: address_status
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Table: customer
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);

-- Table: customer_address (many-to-many with status)
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Table: shipping_method
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100),
    cost DECIMAL(10,2)
);

-- Table: order_status
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50)
);

-- Table: cust_order
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME,
    shipping_method_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id)
);

-- Table: order_line
CREATE TABLE order_line (
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10,2),
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Table: order_history
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    updated_at DATETIME,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- =========================================
-- User Roles and Permissions (Example)
-- =========================================

-- Create user: manager
CREATE USER IF NOT EXISTS 'manager'@'localhost' IDENTIFIED BY 'manager_pass';
GRANT SELECT, INSERT, UPDATE, DELETE ON BookStoreDB.* TO 'manager'@'localhost';

-- Create user: support
CREATE USER IF NOT EXISTS 'support'@'localhost' IDENTIFIED BY 'support_pass';
GRANT SELECT ON BookStoreDB.* TO 'support'@'localhost';

-- Create user: admin
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin_pass';
GRANT ALL PRIVILEGES ON BookStoreDB.* TO 'admin'@'localhost';

-- =========================================
-- Test Queries
-- =========================================

-- 1. List all books with authors and publishers
SELECT b.title, CONCAT(a.first_name, ' ', a.last_name) AS author, p.name AS publisher
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id
LEFT JOIN publisher p ON b.publisher_id = p.publisher_id;

-- 2. Show all customers and their addresses
SELECT c.customer_id, c.first_name, c.last_name, a.street, a.city, a.state, co.country_name
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN address a ON ca.address_id = a.address_id
JOIN country co ON a.country_id = co.country_id;

-- 3. View orders and their total amount
SELECT o.order_id, o.order_date, c.first_name, c.last_name,
       SUM(ol.quantity * ol.price) AS total_amount
FROM cust_order o
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_line ol ON o.order_id = ol.order_id
GROUP BY o.order_id;

-- 4. Get order history and current status
SELECT o.order_id, os.status_name, oh.updated_at
FROM order_history oh
JOIN cust_order o ON oh.order_id = o.order_id
JOIN order_status os ON oh.status_id = os.status_id
ORDER BY oh.updated_at DESC;

-- 5. Find books in stock with quantity < 10
SELECT title, stock_quantity
FROM book
WHERE stock_quantity < 10;

-- 6. Count of orders per shipping method
SELECT sm.method_name, COUNT(*) AS order_count
FROM cust_order co
JOIN shipping_method sm ON co.shipping_method_id = sm.shipping_method_id
GROUP BY sm.method_name;
