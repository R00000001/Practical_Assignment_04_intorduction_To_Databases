-- =====================================================
-- TRIGGERS AND FUNCTIONS FOR AUTOMATION
-- =====================================================

DELIMITER //

-- 1. TRIGGER: Keep track of price changes
-- Create audit table first
CREATE TABLE IF NOT EXISTS price_changes (
    change_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    old_price DECIMAL(8,2),
    new_price DECIMAL(8,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100)
);

-- Trigger to log price changes
CREATE TRIGGER price_change_log
    AFTER UPDATE ON products
    FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price THEN
        INSERT INTO price_changes (product_id, old_price, new_price, changed_by)
        VALUES (NEW.product_id, OLD.price, NEW.price, USER());
    END IF;
END //

-- 2. FUNCTION: Calculate profit for a product
CREATE FUNCTION calculate_profit(product_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE total_profit DECIMAL(10,2) DEFAULT 0;
    
    SELECT SUM((unit_price - cost) * quantity) INTO total_profit
    FROM sales_transactions s
    JOIN products p ON s.product_id = p.product_id
    WHERE s.product_id = product_id;
    
    RETURN COALESCE(total_profit, 0);
END //

DELIMITER ;
