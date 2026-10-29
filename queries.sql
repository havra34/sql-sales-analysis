-- Query 0: Total orders and revenue
SELECT COUNT(*) AS total_orders, SUM(total_price) AS total_revenue FROM sales;

-- Query 1: Top 10 customers
SELECT customer_name, SUM(total_price) AS total_spent
FROM sales
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- Query 2: Average order value by category
SELECT category,
       COUNT(*) AS orders,
       ROUND(AVG(total_price), 2) AS avg_order_value
FROM sales
GROUP BY category
ORDER BY avg_order_value DESC;

-- Query 3: Orders above the average (subquery)
SELECT order_id, customer_name, category, total_price
FROM sales
WHERE total_price > (SELECT AVG(total_price) FROM sales)
ORDER BY total_price DESC;

-- Query 4: Order levels (CASE)
SELECT
  CASE
    WHEN total_price >= 20000 THEN 'High'
    WHEN total_price >= 10000 THEN 'Medium'
    ELSE 'Low'
  END AS order_level,
  COUNT(*) AS orders,
  ROUND(AVG(total_price), 2) AS avg_order_value
FROM sales
GROUP BY order_level
ORDER BY avg_order_value DESC;

-- Setup for Query 5: regions table
CREATE TABLE regions (
  region TEXT,
  region_code TEXT
);

INSERT INTO regions (region, region_code) VALUES
  ('North', 'N01'),
  ('South', 'S02'),
  ('East', 'E03'),
  ('West', 'W04');

-- Query 5: Join sales with regions
SELECT r.region_code,
       s.region,
       COUNT(*) AS orders,
       SUM(s.total_price) AS total_revenue,
       ROUND(AVG(s.total_price), 2) AS avg_order_value
FROM sales s
JOIN regions r ON s.region = r.region
GROUP BY r.region_code, s.region
ORDER BY total_revenue DESC;