-- =====================================================
-- VIEWS FOR EASY REPORTING
-- =====================================================

-- 1. Machine sales summary - how much each machine makes
CREATE VIEW machine_sales_summary AS
SELECT 
    m.machine_id,
    m.location,
    m.status,
    COUNT(s.transaction_id) as total_sales,
    SUM(s.total_price) as total_revenue,
    AVG(s.total_price) as average_sale
FROM machines m
LEFT JOIN sales_transactions s ON m.machine_id = s.machine_id
GROUP BY m.machine_id, m.location, m.status;

-- 2. Product popularity - which products sell the most
CREATE VIEW product_popularity AS
SELECT 
    p.product_id,
    p.name as product_name,
    c.name as category_name,
    p.price,
    COUNT(s.transaction_id) as times_sold,
    SUM(s.total_price) as total_revenue
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
LEFT JOIN sales_transactions s ON p.product_id = s.product_id
GROUP BY p.product_id, p.name, c.name, p.price
ORDER BY times_sold DESC;

-- 3. Daily sales report - sales by day
CREATE VIEW daily_sales AS
SELECT 
    DATE(transaction_timestamp) as sale_date,
    COUNT(transaction_id) as total_transactions,
    SUM(total_price) as daily_revenue,
    AVG(total_price) as average_transaction
FROM sales_transactions
GROUP BY DATE(transaction_timestamp)
ORDER BY sale_date DESC;
