-- =====================================================
-- CREATE DIFFERENT USERS WITH DIFFERENT PERMISSIONS
-- =====================================================

-- 1. ADMIN - can do everything
CREATE USER IF NOT EXISTS 'admin_user'@'%' IDENTIFIED BY 'AdminPass123!';
GRANT ALL PRIVILEGES ON vending_machine_db.* TO 'admin_user'@'%';

-- 2. MANAGER - can see everything, update inventory and machines
CREATE USER IF NOT EXISTS 'manager_user'@'%' IDENTIFIED BY 'ManagerPass123!';
GRANT SELECT, INSERT, UPDATE, DELETE ON vending_machine_db.* TO 'manager_user'@'%';

-- 3. ANALYST - can only view data for reports
CREATE USER IF NOT EXISTS 'analyst_user'@'%' IDENTIFIED BY 'AnalystPass123!';
GRANT SELECT ON vending_machine_db.* TO 'analyst_user'@'%';

-- 4. TECHNICIAN - can only update maintenance records
CREATE USER IF NOT EXISTS 'tech_user'@'%' IDENTIFIED BY 'TechPass123!';
GRANT SELECT ON vending_machine_db.machines TO 'tech_user'@'%';
GRANT SELECT, INSERT, UPDATE ON vending_machine_db.maintenance_logs TO 'tech_user'@'%';

-- 5. CLERK - can only manage inventory  
CREATE USER IF NOT EXISTS 'clerk_user'@'%' IDENTIFIED BY 'ClerkPass123!';
GRANT SELECT ON vending_machine_db.machines TO 'clerk_user'@'%';
GRANT SELECT ON vending_machine_db.products TO 'clerk_user'@'%';
GRANT SELECT ON vending_machine_db.categories TO 'clerk_user'@'%';

-- Apply the changes
FLUSH PRIVILEGES;
