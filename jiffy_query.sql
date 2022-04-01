/*CREATE TABLE customers (
    customer_uid VARCHAR(55) PRIMARY KEY,
    is_business BOOLEAN NOT NULL,
    has_account BOOLEAN NOT NULL,
    bill_state VARCHAR(5) NOT NULL,
    acquisition_channel VARCHAR(100) NOT NULL
    );*/

/*CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_uid INTEGER,
    order_timestamp DATETIME NOT NULL,
    discount FLOAT NOT NULL,
    ship_state VARCHAR NOT NULL,
    shipping_revenue FLOAT NOT NULL,
    shipping_cost FLOAT NOT NULL,
    returned BOOLEAN NOT NULL,
    FOREIGN KEY (customer_uid) 
      REFERENCES customers (customer_uid)
    );*/
    
/*CREATE TABLE line_items (
    line_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    selling_price FLOAT NOT NULL,
    supplier_cost FLOAT NOT NULL,
    product_category VARCHAR(255) NOT NULL,
    color VARCHAR(55) NOT NULL,
    size VARCHAR(10) NOT NULL,
    FOREIGN KEY (order_id) 
      REFERENCES orders (order_id)
    );*/


SELECT COUNT(order_id) FROM orders
WHERE strftime('%Y',order_timestamp) = '2018';

SELECT COUNT(*) FROM(
    SELECT orders.order_id, quantity FROM orders
    JOIN line_items
    ON orders.order_id = line_items.order_id
    WHERE strftime('%Y',order_timestamp) = '2018'
    AND quantity >= 10
    GROUP BY orders.order_id);
    
SELECT COUNT(*) FROM (
    SELECT customers.customer_uid, discount, product_category, size FROM customers
    JOIN orders
    ON customers.customer_uid = orders.customer_uid
    JOIN line_items
    ON orders.order_id = line_items.order_id
    WHERE discount > 0 AND size = 'M' AND product_category = 'Sweater'
    GROUP BY customers.customer_uid);

SELECT SUM((quantity*selling_price) - (quantity*supplier_cost))+(shipping_revenue-shipping_cost) AS profit, 
strftime('%m',order_timestamp) AS month, 
strftime('%Y',order_timestamp) AS year
FROM line_items
JOIN orders 
ON line_items.order_id = orders.order_id
GROUP BY month, year
ORDER BY profit DESC LIMIT 1;

SELECT is_business, returned, (COUNT(*) / CAST( SUM(COUNT(*)) over () as float))*100 AS precent_returned FROM orders
JOIN customers
ON customers.customer_uid = orders.customer_uid
GROUP BY is_business, returned;

SELECT is_business, returned, (COUNT(*) / CAST( SUM(COUNT(*)) over () as float))*100 AS precent_returned FROM orders
JOIN customers
ON customers.customer_uid = orders.customer_uid
WHERE returned="True"
GROUP BY is_business, returned;