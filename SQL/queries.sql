-- 1. What is the distribution of customers by age group?

SELECT 
    gender, 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 18 AND 25 THEN '18-25'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 26 AND 35 THEN '26-35'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 36 AND 45 THEN '36-45'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 46 AND 55 THEN '46-55'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) > 55 THEN '55+'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(customerkey) AS customer_count
FROM 
    customer
GROUP BY 
    gender, age_group;

-- 2. Which products are the top-selling items?

SELECT 
    p.product_name,
    SUM(s.quantity) AS total_quantity_sold
FROM sales s
JOIN product p ON s.productkey = p.productkey
GROUP BY 
    p.product_name
ORDER BY 
    total_quantity_sold DESC
LIMIT 10;

-- 3. What is the average order value across different customer segments?

SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 18 AND 25 THEN '18-25'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 26 AND 35 THEN '26-35'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 36 AND 45 THEN '36-45'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 46 AND 55 THEN '46-55'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) > 55 THEN '55+'
        ELSE 'Unknown'
    END AS age_group,
    AVG(sales.quantity * product.unit_price_usd) AS avg_order_value
FROM 
    sales
INNER JOIN 
    customer ON sales.customerkey = customer.customerkey
INNER JOIN 
    product ON sales.productkey = product.productkey
GROUP BY 
    age_group;

-- 4. What is the total revenue by store location?

SELECT 
    st.country,
    st.state,
    SUM(s.quantity * p.unit_price_usd) AS total_revenue
FROM sales s
JOIN store st ON s.storekey = st.storekey
JOIN product p ON s.productkey = p.productkey
GROUP BY st.country, st.state;

-- 5. How do sales vary by currency, considering exchange rates?

SELECT 
    s.currency_code,
    SUM(s.quantity * p.unit_price_usd * e.exchange) AS total_revenue_usd
FROM sales s
JOIN product p ON s.productkey = p.productkey
JOIN exchange_rate e ON s.currency_code = e.currency_code AND s.order_date = e.date_
GROUP BY s.currency_code;

-- 6. Which customer groups have the highest purchase frequency?

SELECT 
    gender,
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 18 AND 25 THEN '18-25'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 26 AND 35 THEN '26-35'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 36 AND 45 THEN '36-45'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) BETWEEN 46 AND 55 THEN '46-55'
        WHEN TIMESTAMPDIFF(YEAR, birthday, CURDATE()) > 55 THEN '55+'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(sales.order_id) AS purchase_count
FROM 
    sales
INNER JOIN 
    customer ON sales.customerkey = customer.customerkey
GROUP BY 
    age_group, gender
ORDER BY 
    purchase_count DESC;

-- 7. What are the most popular product categories?

SELECT 
    p.category,
    SUM(s.quantity) AS total_quantity_sold
FROM sales s
JOIN product p ON s.productkey = p.productkey
GROUP BY 
    p.category
ORDER BY 
    total_quantity_sold DESC;

-- 8. How does revenue per square meter differ among stores?

SELECT 
    st.country,
    st.square_meters,
    SUM(s.quantity * p.unit_price_usd * e.exchange) / st.square_meters AS revenue_per_square_meter
FROM sales s
JOIN store st ON s.storekey = st.storekey
JOIN product p ON s.productkey = p.productkey
JOIN exchange_rate e ON s.currency_code = e.currency_code AND s.order_date = e.date_
GROUP BY 
    st.country, st.square_meters;


-- 9. Which age group contributes the most to total revenue?

SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) BETWEEN 18 AND 25 THEN '18-25'
        WHEN TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) BETWEEN 26 AND 35 THEN '26-35'
        WHEN TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) BETWEEN 36 AND 45 THEN '36-45'
        WHEN TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) BETWEEN 46 AND 55 THEN '46-55'
        ELSE '55+'
    END AS age_group,
    SUM(s.quantity * p.unit_price_usd * e.exchange) AS total_revenue
FROM sales s
JOIN customer c ON s.customerkey = c.customerkey
JOIN product p ON s.productkey = p.productkey
JOIN exchange_rate e ON s.currency_code = e.currency_code AND s.order_date = e.date_
GROUP BY 
    age_group
ORDER BY 
    total_revenue DESC;

-- 10. What is the overall profit margin for each product?

SELECT 
    p.product_name,
    p.category,
    p.subcategory,
    (SUM(s.quantity * (p.unit_price_usd - p.unit_cost_usd)) / SUM(s.quantity * p.unit_price_usd)) AS profit_margin
FROM sales s
JOIN product p ON s.productkey = p.productkey
GROUP BY 
    p.product_name, p.category,p.subcategory
ORDER BY 
    profit_margin;

-- 11. Identify the Customer Retention?

SELECT 
    c.customerkey,
    c.name,
    COUNT(DISTINCT s.order_id) AS total_orders
FROM 
    sales s
INNER JOIN 
    customer c ON s.customerkey = c.customerkey
GROUP BY 
    c.customerkey, c.name
HAVING 
    total_orders > 1
ORDER BY 
    total_orders DESC;