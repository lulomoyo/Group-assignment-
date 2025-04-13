
CREATE TABLE author (
    author_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE publisher (
    publisher_id INT PRIMARY KEY,
    publisher_name VARCHAR(100)
);

CREATE TABLE book_language (
    language_id INT PRIMARY KEY,
    language_name VARCHAR(50)
);

CREATE TABLE book (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    publisher_id INT,
    language_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

CREATE TABLE book_author (
    book_author_id INT PRIMARY KEY,
    book_id INT,
    author_id INT,
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE TABLE country (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100)
);

CREATE TABLE address (
    address_id INT PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50),
    postal_code VARCHAR(10),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE address_status (
    address_status_id INT PRIMARY KEY,
    status_description VARCHAR(50)
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

CREATE TABLE customer_address (
    customer_address_id INT PRIMARY KEY,
    customer_id INT,
    address_id INT,
    address_status_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

CREATE TABLE shipping_method (
    shipping_method_id INT PRIMARY KEY,
    method_name VARCHAR(50),
    delivery_time_days INT
);

CREATE TABLE order_status (
    order_status_id INT PRIMARY KEY,
    status_name VARCHAR(50)
);

CREATE TABLE cust_order (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_status_id INT,
    shipping_method_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id)
);

CREATE TABLE order_history (
    order_history_id INT PRIMARY KEY,
    order_id INT,
    order_status_id INT,
    changed_on DATETIME,
    notes VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);

CREATE TABLE order_line (
    order_line_id INT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

INSERT INTO author (author_id, first_name, last_name) VALUES
(1, 'Lusanda', 'Zile'),
(2, 'Austin', 'Luz'),
(3, 'Sherry', 'Williams');

INSERT INTO publisher (publisher_id, publisher_name) VALUES
(1, 'MacMillan'),
(2, 'Scholastic'),
(3, 'Big Books');

INSERT INTO book_language (language_id, language_name) VALUES
(1, 'English'),
(2, 'Spanish');

INSERT INTO book (book_id, title, publisher_id, language_id) VALUES
(1, 'Boss Baby', 1, 1),
(2, 'The Strange Doll', 2, 1),
(3, 'Little One', 3, 1);

INSERT INTO book_author (book_author_id, book_id, author_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);

INSERT INTO country (country_id, country_name) VALUES
(1, 'South Africa'),
(2, 'Mexico'),
(3, 'Kenya');

INSERT INTO address (address_id, street, city, postal_code, country_id) VALUES
(1, '354 Bok St', 'Johannesburg', '2000', 1),
(2, '45 Kenyatta Ave', 'Kenya', '6001', 3);

INSERT INTO address_status (address_status_id, status_description) VALUES
(1, 'Current'),
(2, 'Previous');

INSERT INTO customer (customer_id, first_name, last_name, email, phone_number) VALUES
(1, 'Lulo', 'Samsons', 'lulo@gmail.com', '0821234567'),
(2, 'Katleho', 'Sebusi', 'kat@gmail.com', '0739876543');

INSERT INTO customer_address (customer_address_id, customer_id, address_id, address_status_id) VALUES
(1, 1, 1, 1),
(2, 2, 2, 1);

INSERT INTO shipping_method (shipping_method_id, method_name, delivery_time_days) VALUES
(1, 'Standard Shipping', 5),
(2, 'Express Shipping', 2);

INSERT INTO order_status (order_status_id, status_name) VALUES
(1, 'Pending'),
(2, 'Shipped'),
(3, 'Delivered');

INSERT INTO cust_order (order_id, customer_id, order_status_id, shipping_method_id, order_date, total_amount) VALUES
(1, 1, 1, 1, '2025-04-01', 99.98),
(2, 2, 3, 2, '2024-05-02', 79.99);

INSERT INTO order_history (order_history_id, order_id, order_status_id, changed_on, notes) VALUES
(1, 1, 1, '2024-04-01 09:00:00', 'Order created'),
(2, 1, 2, '2024-04-02 10:00:00', 'Order shipped');

INSERT INTO order_line (order_line_id, order_id, book_id, quantity, price) VALUES
(1, 1, 1, 2, 29.99),
(2, 2, 2, 1, 59.99);
