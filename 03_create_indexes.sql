-- =====================================================
-- INDEXES FOR BETTER PERFORMANCE
-- =====================================================
-- These make searches faster on large amounts of data

-- Indexes for machines table
CREATE INDEX idx_machines_location ON machines(location);
CREATE INDEX idx_machines_status ON machines(status);

-- Indexes for products table  
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_price ON products(price);

-- Indexes for sales table (IMPORTANT - this table will have 500,000+ records)
CREATE INDEX idx_sales_date ON sales_transactions(transaction_timestamp);
CREATE INDEX idx_sales_machine ON sales_transactions(machine_id);
CREATE INDEX idx_sales_product ON sales_transactions(product_id);

-- Composite indexes for common searches
CREATE INDEX idx_sales_machine_date ON sales_transactions(machine_id, transaction_timestamp);
CREATE INDEX idx_sales_product_date ON sales_transactions(product_id, transaction_timestamp);

-- Indexes for maintenance table
CREATE INDEX idx_maintenance_machine ON maintenance_logs(machine_id);
CREATE INDEX idx_maintenance_date ON maintenance_logs(maintenance_date);
