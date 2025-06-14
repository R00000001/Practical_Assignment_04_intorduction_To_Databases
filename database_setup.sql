create database if not exists Assignment4;
use Assignment4;

create table machines(
    machine_id int auto_increment primary key,
    machine_location varchar(100) not null comment 'Vending machine location',
    category_id int not null,
    machine_status varchar(10) not null comment 'Active/Inactive',
    installation_date timestamp not null,
    foreign key (category_id) references categories(category_id)
) comment 'information about each vending machine';

create table stock(
    machine_id  int,
    product_id  int,
    quantiity   int
not null default 0 check (quantity ))
-- Our stockre:
-- pednis (6)
-- coke (10)
-- void (null)
-- cocacola (0)

create table products(
    product_id int auto_increment primary key,
    product_name varchar(100) not null unique,
    category_id int not null,
    price float not null check (price > 0),
    foreign key (category_id) references categories(category_id)
) comment 'all products we sell in our machines';

create table categories(
    category_id int auto_increment primary key,
    category_name varchar(50) not null unique
) comment 'product categories like snacks, drinks, candy';

create table transactions(
    transaction_id int auto_increment primary key,
    machine_id int not null,
    product_id int not null,
    time_stamp timestamp not null,
    amount int not null check(amount > 0) comment 'Item count', 
    total_price int not null check(total_price > 0) comment 'amount * products.price',
    Foreign Key (machine_id) REFERENCES machines(machine_id),
    Foreign Key (product_id) REFERENCES products(product_id)
) comment 'record of every sale made';

create table maintenance_log(
    log_id int auto_increment primary key,
    machine_id int,
    maintenance_date  date not null comment 'date',
    reason varchar(100) comment 'Maintenace issue: Restock, Repair, Regular check etc.',
    foreign key (machine_id) references machines(machine_id)
) comment 'record of all maintenance work done on machines';


-- Necessary indexes for efficient queries

-- Indexes for machines table
CREATE INDEX idx_machines_location ON machines(machine_location);

-- Indexes for products table  
CREATE INDEX idx_products_category ON products(category_id);

-- Indexes for transactions table (IMPORTANT - this table will have 500,000 records)
CREATE INDEX idx_transactions_date ON transactions(time_stamp);
CREATE INDEX idx_transactions_machine ON transactions(machine_id);

-- Indexes for maintenance_log table
CREATE INDEX idx_maintenance_machine ON maintenance_log(machine_id);





-- 1. ADMIN - can do everything
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'AdminPass123!';
GRANT ALL PRIVILEGES ON Assignment4.* TO 'admin'@'%';

-- 2. MANAGER - can see everything, update inventory and machines
CREATE USER IF NOT EXISTS 'manager'@'%' IDENTIFIED BY 'ManagerPass123!';
GRANT SELECT, INSERT, UPDATE, DELETE ON Assignment4.* TO 'manager'@'%';

-- 3. ANALYST - can only view data for reports
CREATE USER IF NOT EXISTS 'analyst'@'%' IDENTIFIED BY 'AnalystPass123!';
GRANT SELECT ON Assignment4.* TO 'analyst'@'%';

-- 4. TECHNICIAN - can only update maintenance records
CREATE USER IF NOT EXISTS 'tech'@'%' IDENTIFIED BY 'TechPass123!';
GRANT SELECT ON Assignment4.machines TO 'tech'@'%';
GRANT SELECT, INSERT, UPDATE ON Assignment4.maintenance_logs TO 'tech'@'%';

-- 5. CLERK - can only manage inventory  
CREATE USER IF NOT EXISTS 'clerk'@'%' IDENTIFIED BY 'ClerkPass123!';
GRANT SELECT ON Assignment4.machines TO 'clerk'@'%';
GRANT SELECT ON Assignment4.products TO 'clerk'@'%';
GRANT SELECT ON Assignment4.categories TO 'clerk'@'%';

-- Apply the changes
FLUSH PRIVILEGES;

-- View
create view machines_view as  
select  
    machines.machine_id,
    machines.machine_location,
    categories.category_name