-- =====================================================
-- create tables for vending machine database
-- =====================================================

-- 1. categories table - groups products (snacks, drinks, etc.)
create table categories (
    category_id int primary key auto_increment,
    name varchar(100) not null unique comment 'category name like snacks, beverages',
    description text comment 'what this category includes',
    created_at timestamp default current_timestamp
) comment 'product categories like snacks, drinks, candy';

-- 2. machines table - information about each vending machine  
create table machines (
    machine_id int primary key auto_increment,
    location varchar(255) not null comment 'where the machine is located',
    category varchar(100) not null comment 'type of machine: food, beverage, or mixed',
    status enum('active', 'inactive', 'maintenance', 'out_of_order') not null default 'active',
    installation_date date not null comment 'when machine was installed',
    capacity int not null check (capacity > 0) comment 'how many items it can hold',
    serial_number varchar(50) unique comment 'unique machine identifier',
    created_at timestamp default current_timestamp
) comment 'information about each vending machine';

-- 3. products table - all items we sell
create table products (
    product_id int primary key auto_increment,
    name varchar(200) not null comment 'product name',
    category_id int not null comment 'what category this belongs to',
    price decimal(8,2) not null check (price > 0) comment 'how much we sell it for',
    cost decimal(8,2) not null check (cost > 0 and cost < price) comment 'how much it costs us',
    barcode varchar(50) unique comment 'product barcode',
    is_active boolean default true comment 'is this product still being sold',
    created_at timestamp default current_timestamp,
    
    foreign key (category_id) references categories(category_id)
) comment 'all products we sell in our machines';

-- 4. sales transactions table - record of every purchase
create table sales_transactions (
    transaction_id int primary key auto_increment,
    machine_id int not null comment 'which machine',
    product_id int not null comment 'what was bought',
    transaction_timestamp timestamp default current_timestamp comment 'when it was bought',
    quantity int not null default 1 check (quantity > 0) comment 'how many items',
    unit_price decimal(8,2) not null check (unit_price > 0) comment 'price per item',
    total_price decimal(10,2) not null check (total_price > 0) comment 'total amount paid',
    payment_method enum('cash', 'card', 'mobile') not null comment 'how they paid',
    
    foreign key (machine_id) references machines(machine_id),
    foreign key (product_id) references products(product_id),
    
    check (total_price = unit_price * quantity)
) comment 'record of every sale made';

-- 5. maintenance logs table - when machines get fixed
create table maintenance_logs (
    log_id int primary key auto_increment,
    machine_id int not null comment 'which machine was serviced',
    maintenance_date date not null comment 'when the work was done',
    technician_name varchar(100) not null comment 'who did the work',
    issue_description text not null comment 'what was wrong',
    resolution_description text comment 'what was done to fix it',
    maintenance_type enum('preventive', 'corrective', 'emergency') not null,
    cost decimal(8,2) check (cost >= 0) comment 'how much the repair cost',
    created_at timestamp default current_timestamp,
    
    foreign key (machine_id) references machines(machine_id)
) comment 'record of all maintenance work done on machines';
