-- =====================================================
-- CREATE LOTS OF SALES DATA (500,000+ RECORDS)
-- =====================================================
-- This creates many sales records to test performance

-- Add some maintenance records first
INSERT INTO maintenance_logs (machine_id, maintenance_date, technician_name, issue_description, resolution_description, maintenance_type, cost) VALUES
(1, '2024-05-15', 'John Smith', 'Monthly cleaning and check', 'Cleaned and restocked', 'PREVENTIVE', 100.00),
(2, '2024-05-20', 'Sarah Johnson', 'Coin mechanism stuck', 'Replaced coin validator', 'CORRECTIVE', 150.00),
(3, '2024-06-01', 'Mike Davis', 'Display not working', 'Replaced LCD screen', 'CORRECTIVE', 200.00),
(4, '2024-05-25', 'Lisa Chen', 'Regular maintenance', 'Full service completed', 'PREVENTIVE', 80.00),
(5, '2024-06-10', 'John Smith', 'Machine not dispensing', 'Fixed dispensing motor', 'EMERGENCY', 250.00);

-- Simple procedure to create lots of sales data  
DELIMITER //

CREATE PROCEDURE CreateSalesData()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE random_machine INT;
    DECLARE random_product INT;
    DECLARE random_price DECIMAL(8,2);
    DECLARE random_date TIMESTAMP;
    DECLARE random_payment VARCHAR(10);
    
    -- Turn off autocommit for better performance
    SET autocommit = 0;
    
    WHILE i <= 500000 DO
        -- Pick random machine (1-5, only active ones)
        SET random_machine = FLOOR(1 + RAND() * 4);
        
        -- Pick random product (1-16)
        SET random_product = FLOOR(1 + RAND() * 16);
        
        -- Get the product price
        SELECT price INTO random_price FROM products WHERE product_id = random_product;
        
        -- Random date in last 6 months
        SET random_date = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 180) DAY);
        SET random_date = DATE_ADD(random_date, INTERVAL FLOOR(RAND() * 86400) SECOND);
        
        -- Random payment method
        SET random_payment = CASE FLOOR(RAND() * 3)
            WHEN 0 THEN 'CASH'
            WHEN 1 THEN 'CARD'
            ELSE 'MOBILE'
        END;
        
        -- Insert the sale
        INSERT INTO sales_transactions (
            machine_id, product_id, transaction_timestamp, 
            quantity, unit_price, total_price, payment_method
        ) VALUES (
            random_machine, random_product, random_date,
            1, random_price, random_price, random_payment
        );
        
        -- Commit every 10000 records
        IF i % 10000 = 0 THEN
            COMMIT;
            SELECT CONCAT('Created ', i, ' sales records') as progress;
        END IF;
        
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
    SET autocommit = 1;
    SELECT 'Finished creating 500,000 sales records!' as result;
END //

DELIMITER ;

-- Run the procedure
CALL CreateSalesData();

-- Clean up
DROP PROCEDURE CreateSalesData;
