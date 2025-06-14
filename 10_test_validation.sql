-- =====================================================
-- TEST THE DATABASE TO MAKE SURE IT WORKS
-- =====================================================

USE vending_machine_db;

-- Test 1: Check if all tables were created
SELECT 'CHECKING TABLES' as test_section;
SELECT 
    TABLE_NAME as table_name,
    TABLE_ROWS as estimated_rows
FROM information_schema.tables 
WHERE table_schema = 'vending_machine_db'
ORDER BY table_name;

-- Test 2: Check constraints are working
SELECT 'TESTING CONSTRAINTS' as test_section;
SELECT 
    'Products with valid prices' as test_name,
    COUNT(*) as count
FROM products 
WHERE price > cost AND price > 0;

-- Test 3: Check sample data was inserted
SELECT 'CHECKING SAMPLE DATA' as test_section;
SELECT 'Categories' as table_name, COUNT(*) as records FROM categories
UNION ALL
SELECT 'Machines' as table_name, COUNT(*) as records FROM machines
UNION ALL
SELECT 'Products' as table_name, COUNT(*) as records FROM products
UNION ALL
SELECT 'Sales' as table_name, COUNT(*) as records FROM sales_transactions
ORDER BY table_name;

-- Test 4: Test a simple query performance
SELECT 'TESTING PERFORMANCE' as test_section;
SELECT 
    COUNT(*) as total_sales,
    SUM(total_price) as total_revenue,
    AVG(total_price) as average_sale
FROM sales_transactions
WHERE transaction_timestamp >= '2024-01-01';

-- Test 5: Test views work
SELECT 'TESTING VIEWS' as test_section;
SELECT COUNT(*) as machine_summary_records FROM machine_sales_summary;
SELECT COUNT(*) as product_popularity_records FROM product_popularity;

-- Test 6: Test stored procedure
SELECT 'TESTING STORED PROCEDURE' as test_section;
CALL ProcessSale(1, 1, 'CARD');

-- Test 7: Test function
SELECT 'TESTING FUNCTION' as test_section;
SELECT 
    product_id,
    name,
    calculate_profit(product_id) as total_profit
FROM products 
LIMIT 5;

-- Final message
SELECT 'ALL TESTS COMPLETED' as status;
