CREATE TABLE dim_customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name TEXT,
    gender VARCHAR(10),
    city TEXT,
    segment VARCHAR(20)
);
select * from dim_customers

CREATE TABLE dim_products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    sub_category TEXT
);

select * from dim_products

CREATE TABLE dim_stores (
    store_id VARCHAR(20) PRIMARY KEY,
    region VARCHAR(20),
    store_type VARCHAR(20)
);
select * from dim_stores


CREATE TABLE dim_dates (
    date_id DATE PRIMARY KEY,
    year INT,
    month INT,
    month_name VARCHAR(20),
    quarter VARCHAR(10)
);

select * from dim_dates

CREATE TABLE fact_sales (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    store_id VARCHAR(20),
    quantity INT,
    unit_price NUMERIC(12,2),
    sales NUMERIC(14,2),
    cost NUMERIC(14,2),
    profit NUMERIC(14,2),

    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES dim_customers(customer_id),

    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
        REFERENCES dim_products(product_id),

    CONSTRAINT fk_store
        FOREIGN KEY (store_id)
        REFERENCES dim_stores(store_id)
);
select * from fact_sales

COPY dim_customers
FROM 'D:\chat gpt practice file\multiple table\dim_customers.csv'
DELIMITER ','
CSV HEADER;

SELECT *
FROM fact_sales
WHERE sales > 100


Cardinality = Many to One
Cross filter = Single

SELECT *
FROM fact_sales f
JOIN dim_products p ON f.product_id = p.product_id
JOIN dim_customers c ON f.customer_id = c.customer_id
JOIN dim_stores s ON f.store_id = s.store_id;

CREATE VIEW vw_sales_full AS
SELECT
    f.order_id,
    f.sales,
    f.cost,
    f.profit,
    p.product_name,
    p.category,
    p.sub_category,
    c.customer_name,
    c.segment,
    s.region,
    s.store_type,
    f.order_date
FROM fact_sales f
JOIN dim_products p ON f.product_id = p.product_id
JOIN dim_customers c ON f.customer_id = c.customer_id
JOIN dim_stores s ON f.store_id = s.store_id;

SELECT * FROM vw_sales_full;

SELECT category, SUM(sales)
FROM vw_sales_full
GROUP BY category;
