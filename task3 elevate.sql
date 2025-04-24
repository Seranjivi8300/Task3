-- Create table for Olist Customers
CREATE TABLE olist_customers7 (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
-- Import CSV data into the table (adjust path and options based on your MySQL setup)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE olist_customers7
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT customer_state, COUNT(*) AS num_customers
FROM olist_customers
GROUP BY customer_state
ORDER BY num_customers DESC;

SELECT customer_city, COUNT(*) AS total_customers
FROM olist_customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 5;

SELECT customer_state, COUNT(*) AS num_customers
FROM olist_customers
GROUP BY customer_state
HAVING num_customers < 100;

-- View for customers grouped by state
CREATE VIEW customer_summary_by_state AS
SELECT customer_state, COUNT(*) AS num_customers
FROM olist_customers
GROUP BY customer_state;

-- Index to speed up queries filtering by state
CREATE INDEX idx_customer_state ON olist_customers(customer_state);

-- Cities with more customers than the average number of customers per city
SELECT customer_city
FROM (
    SELECT customer_city, COUNT(*) AS city_count
    FROM olist_customers
    GROUP BY customer_city
) AS city_counts
WHERE city_count > (
    SELECT AVG(city_count)
    FROM (
        SELECT customer_city, COUNT(*) AS city_count
        FROM olist_customers
        GROUP BY customer_city
    ) AS all_city_counts
);

