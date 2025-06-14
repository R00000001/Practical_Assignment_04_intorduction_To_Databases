-- =====================================================
-- STORED PROCEDURES FOR COMMON TASKS
-- =====================================================

DELIMITER //

-- 1. Procedure to process a sale
CREATE PROCEDURE ProcessSale(
    IN machine_id INT,
    IN product_id INT,
    IN payment_method VARCHAR(10)
)
BEGIN
    DECLARE product_price DECIMAL(8,2);
    
    -- Get product price
    SELECT price INTO product_price 
    FROM products 
    WHERE product_id = product_id AND is_active = TRUE;
    
    -- Record the sale
    INSERT INTO sales_transactions (machine_id, product_id, quantity, unit_price, total_price, payment_method)
    VALUES (machine_id, product_id, 1, product_price, product_price, payment_method);
    
    SELECT 'Sale processed successfully' as result;
END //

-- 2. Procedure to get sales report for a machine
CREATE PROCEDURE GetMachineSalesReport(
    IN machine_id INT,
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT 
        p.name as product_name,
        COUNT(*) as times_sold,
        SUM(s.total_price) as total_revenue
    FROM sales_transactions s
    JOIN products p ON s.product_id = p.product_id
    WHERE s.machine_id = machine_id
        AND DATE(s.transaction_timestamp) BETWEEN start_date AND end_date
    GROUP BY p.name
    ORDER BY total_revenue DESC;
END //

DELIMITER ;
