CREATE DATABASE Ecommerce_DB;
USE Ecommerce_DB;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

#Inserting Data
INSERT INTO customers (customer_name, email, country) VALUES
('Alice', 'alice@gmail.com', 'USA'),
('Bob', 'bob@gmail.com', 'India'),
('Charlie', 'charlie@gmail.com', 'UK');

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 70000),
('Headphones', 'Accessories', 2000),
('Mobile', 'Electronics', 30000);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-10-01', 72000),
(2, '2024-10-05', 30000),
(3, '2024-10-10', 2000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 3, 1),
(3, 2, 1);

#Extract all customer details
SELECT * FROM customers;

#Find orders above ₹50,000
SELECT * FROM orders
WHERE total_amount > 50000;

#Show total sales per country
SELECT c.country, SUM(o.total_amount) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_sales DESC;

#Find the most purchased product
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;

#Average revenue per customer (using subquery)
SELECT customer_name,
       (SELECT AVG(total_amount)
        FROM orders
        WHERE customer_id = c.customer_id) AS avg_revenue
FROM customers c;

#Create a View for quick access
CREATE VIEW sales_summary AS
SELECT c.customer_name, c.country, o.order_date, o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

#Optimize with Index
CREATE INDEX idx_country ON customers(country);
CREATE INDEX idx_orderdate ON orders(order_date);

