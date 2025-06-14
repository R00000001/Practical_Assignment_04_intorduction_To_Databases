-- =====================================================
-- SAMPLE DATA FOR TESTING
-- =====================================================

-- Add product categories
INSERT INTO categories (name, description) VALUES
('Beverages', 'Drinks like soda, water, juice'),
('Snacks', 'Chips, crackers, nuts'),
('Candy', 'Chocolate bars, gummy bears, mints'),
('Healthy', 'Protein bars, granola, dried fruit');

-- Add vending machines
INSERT INTO machines (location, category, status, installation_date, capacity, serial_number) VALUES
('Main Building Lobby', 'Mixed', 'ACTIVE', '2024-01-15', 100, 'VM001'),
('Cafeteria', 'Beverages', 'ACTIVE', '2024-02-01', 80, 'VM002'),
('Library Entrance', 'Snacks', 'ACTIVE', '2024-02-15', 60, 'VM003'),
('Gym', 'Healthy', 'ACTIVE', '2024-03-01', 50, 'VM004'),
('Student Center', 'Mixed', 'MAINTENANCE', '2024-03-15', 120, 'VM005');

-- Add products
INSERT INTO products (name, category_id, price, cost, barcode, is_active) VALUES
-- Beverages (category_id = 1)
('Coca Cola 330ml', 1, 2.50, 1.00, '12345001', TRUE),
('Pepsi 330ml', 1, 2.50, 1.00, '12345002', TRUE),
('Water 500ml', 1, 2.00, 0.50, '12345003', TRUE),
('Orange Juice', 1, 3.00, 1.50, '12345004', TRUE),

-- Snacks (category_id = 2)  
('Potato Chips', 2, 2.00, 0.80, '12345101', TRUE),
('Doritos', 2, 2.25, 0.90, '12345102', TRUE),
('Pringles', 2, 3.00, 1.20, '12345103', TRUE),
('Crackers', 2, 1.50, 0.60, '12345104', TRUE),

-- Candy (category_id = 3)
('Snickers', 3, 2.00, 0.80, '12345201', TRUE),
('Kit Kat', 3, 1.75, 0.70, '12345202', TRUE),
('M&Ms', 3, 2.50, 1.00, '12345203', TRUE),
('Gummy Bears', 3, 1.80, 0.72, '12345204', TRUE),

-- Healthy (category_id = 4)
('Protein Bar', 4, 4.00, 2.00, '12345301', TRUE),
('Granola Bar', 4, 2.50, 1.00, '12345302', TRUE),
('Trail Mix', 4, 3.00, 1.50, '12345303', TRUE),
('Dried Fruit', 4, 2.75, 1.10, '12345304', TRUE);
