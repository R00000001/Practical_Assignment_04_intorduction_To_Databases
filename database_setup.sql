create database if not exists assignment4;
use assignment4;

-- tables
create table categories (
    category_id int auto_increment primary key,
    category_name varchar(50) not null unique
) comment='product categories like snacks, drinks, candy';

create table products (
    product_id int auto_increment primary key,
    product_name varchar(100) not null unique,
    category_id int not null,
    price decimal(10,2) not null check (price > 0),
    foreign key (category_id) references categories(category_id)
        on delete restrict
        on update cascade
) comment='all products we sell in our machines';

create table machines (
    machine_id int auto_increment primary key,
    machine_location varchar(100) not null comment 'vending machine location',
    category_id int not null,
    machine_status enum('active','inactive') not null comment 'active/inactive',
    installation_date datetime not null,
    foreign key (category_id) references categories(category_id)
        on delete restrict on update cascade
) comment='information about each vending machine';

create table stock (
    machine_id int not null,
    product_id int not null,
    quantity int not null default 0 check (quantity >= 0),
    last_restock_date date not null,
    primary key (machine_id, product_id),
    foreign key (machine_id) references machines(machine_id)
        on delete cascade on update cascade,
    foreign key (product_id) references products(product_id)
        on delete restrict 
        on update cascade
) comment='stock of each product in our machines';

create table transactions (
    transaction_id int auto_increment primary key,
    machine_id int not null,
    product_id int not null,
    time_stamp datetime not null,
    amount int not null check(amount > 0) comment 'item count',
    total_price decimal(10,2) not null check(total_price > 0) comment 'amount * products.price',
    foreign key (machine_id) references machines(machine_id)
        on delete restrict 
        on update cascade,
    foreign key (product_id) references products(product_id)
        on delete restrict
        on update cascade
) comment='record of every sale made';

create table maintenance_log (
    log_id int auto_increment primary key,
    machine_id int not null,
    maintenance_date date not null comment 'date of maintenance',
    reason varchar(100) comment 'maintenance issue: restock, repair, etc.',
    foreign key (machine_id) references machines(machine_id)
        on delete cascade
        on update cascade
) comment='record of all maintenance work done on machines';

-- indexes 
create index index_machines_location on machines(machine_location);
create index index_products_category on products(category_id);
create index index_transactions_machine_date on transactions(machine_id, time_stamp);
create index index_maintenance_machine on maintenance_log(machine_id);

-- roles and users
-- define roles
create role r_admin;
grant all privileges on assignment4.* to r_admin;

create role r_manager;
grant select, insert, update, delete on assignment4.* to r_manager;

create role r_analyst;
grant select on assignment4.* to r_analyst;

create role r_technician;
grant select on assignment4.machines to r_technician;
grant select, insert, update on assignment4.maintenance_log to r_technician;

-- create users and grant roles
create user if not exists 'admin'@'%' identified by 'General_Yevhen';
grant r_admin to 'admin'@'%';

create user if not exists 'manager'@'%' identified by 'OLTP_Povelitel';
grant r_manager to 'manager'@'%';

create user if not exists 'analyst'@'%' identified by 'seba_na_front';
grant r_analyst to 'analyst'@'%';

create user if not exists 'tech'@'%' identified by 'Cybersec_has_fallen';
grant r_technician to 'tech'@'%';

flush privileges;

-- trigger
delimiter $$
create trigger trg_reduce_stock_after_sale
after insert on transactions
for each row
begin
    update stock
       set quantity = quantity - new.amount
     where machine_id = new.machine_id
       and product_id = new.product_id
       and quantity >= new.amount;
end$$
delimiter ;


-- views
create view machines_view as
select
    m.machine_id,
    m.machine_location,
    c.category_name
from machines m
join categories c on m.category_id = c.category_id;

create view machine_sales_summary as
select
    m.machine_id,
    m.machine_location,
    m.machine_status,
    count(t.transaction_id) as total_sales,
    coalesce(sum(t.total_price), 0) as total_revenue,
    coalesce(avg(t.total_price), 0) as average_sale
from machines m
left join transactions t on m.machine_id = t.machine_id
group by m.machine_id, m.machine_location, m.machine_status;

-- procedure
delimiter $$
create procedure get_inactive_machines()
begin
    select * from machines where machine_status = 'inactive';
end$$
delimiter ;

-- procedure call
call get_inactive_machines();
