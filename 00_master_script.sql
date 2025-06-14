-- =====================================================
-- MASTER SCRIPT - RUN THIS TO CREATE EVERYTHING
-- =====================================================
-- This creates the complete vending machine database

SELECT 'STARTING DATABASE CREATION' as status;

-- 1. Create database
SOURCE 01_create_database.sql;
SELECT '✓ Database created' as step;

-- 2. Create tables
SOURCE 02_create_tables.sql;
SELECT '✓ Tables created' as step;

-- 3. Create indexes for speed
SOURCE 03_create_indexes.sql;
SELECT '✓ Indexes created' as step;

-- 4. Add sample data
SOURCE 04_insert_sample_data.sql;
SELECT '✓ Sample data added' as step;

-- 5. Generate lots of sales data (500,000 records)
SOURCE 05_generate_bulk_data.sql;
SELECT '✓ Bulk sales data created (this may take a few minutes)' as step;

-- 6. Create users with different permissions
SOURCE 06_create_users.sql;
SELECT '✓ Users created' as step;

-- 7. Create views for reporting
SOURCE 07_create_views.sql;
SELECT '✓ Views created' as step;

-- 8. Create stored procedures
SOURCE 08_create_procedures.sql;
SELECT '✓ Stored procedures created' as step;

-- 9. Create triggers and functions
SOURCE 09_create_triggers_functions.sql;
SELECT '✓ Triggers and functions created' as step;

-- 10. Test everything
SOURCE 10_test_validation.sql;
SELECT '✓ Tests completed' as step;

SELECT '🎉 VENDING MACHINE DATABASE IS READY!' as final_status;
