# Database Modeling Q&A - Practical Assignment 4

## 1. What is the difference between OLTP and OLAP systems? Why is your solution OLTP?

**OLTP (Online Transaction Processing)**:
- Designed for real-time transaction processing
- Handles INSERT, UPDATE, DELETE operations efficiently
- Optimized for concurrent users and fast response times
- Maintains ACID properties for data consistency
- Typically normalized to reduce redundancy

**OLAP (Online Analytical Processing)**:
- Designed for complex analytical queries and reporting
- Optimized for SELECT operations on large datasets
- Often uses denormalized structures (star/snowflake schema)
- Focuses on historical data analysis and aggregations
- Typically read-only or append-only

**My solution is OLTP because**:
- It processes real-time vending machine transactions
- Supports concurrent sales operations across multiple machines
- Requires immediate inventory updates after each sale
- Maintains data integrity through constraints and triggers
- Optimized for operational efficiency rather than analytical processing

## 2. How would you choose primary keys and foreign keys for your tables?

**Primary Key Selection Criteria**:
- **Uniqueness**: Must uniquely identify each record
- **Stability**: Should not change over time
- **Simplicity**: Prefer single-column integer keys for performance
- **Non-null**: Must always have a value

**My Primary Key Choices**:
- `machine_id`, `product_id`, `category_id`: Auto-incrementing integers for simplicity and performance
- `transaction_id`, `log_id`: Sequential IDs for audit trails and chronological ordering
- `inventory_id`: Surrogate key for the many-to-many relationship

**Foreign Key Selection**:
- Reference primary keys of parent tables
- Enforce referential integrity
- Support cascading updates where business logic allows
- Restrict deletions to prevent orphaned records

## 3. What are normalization and denormalization? Did you normalize your data?

**Normalization**: Process of organizing data to reduce redundancy and dependency by dividing large tables into smaller ones and defining relationships.

**Denormalization**: Intentionally introducing redundancy to improve query performance, typically in read-heavy systems.

**My Database Normalization (3NF)**:
- **1NF**: All attributes contain atomic values (no repeating groups)
- **2NF**: Eliminated partial dependencies (product categories separated)
- **3NF**: Eliminated transitive dependencies (no derived data stored)

**Examples of Normalization in My Design**:
- Categories separated from products to avoid repetition
- Machine inventory as junction table for many-to-many relationship
- Maintenance logs separated from machine master data
- Product pricing history through audit table

## 4. Why is indexing important, and how did it impact performance in your database?

**Importance of Indexing**:
- Dramatically improves SELECT query performance
- Reduces disk I/O operations
- Enables efficient sorting and filtering
- Critical for large datasets (500K+ records)

**Performance Impact in My Database**:
- **Time-based indexes** on `transaction_timestamp` enable fast date range queries
- **Machine indexes** support location-based reporting
- **Composite indexes** optimize common query patterns
- **Foreign key indexes** improve join performance

**Specific Examples**:
```sql
-- Without index: Full table scan on 500K records
-- With index: Direct lookup in milliseconds
SELECT * FROM sales_transactions 
WHERE transaction_timestamp BETWEEN '2024-06-01' AND '2024-06-14';
```

## 5. What are the risks of many-to-many relationships and how can you model them efficiently?

**Risks of Many-to-Many Relationships**:
- **Data Redundancy**: Without proper junction tables
- **Update Anomalies**: Difficulty maintaining consistency
- **Complex Queries**: Require joins through multiple tables
- **Performance Issues**: Can impact query speed if not indexed properly

**My Efficient Modeling**:
- **Junction Table**: `machine_inventory` resolves Machine ↔ Product many-to-many
- **Composite Unique Key**: `(machine_id, product_id)` prevents duplicates
- **Additional Attributes**: Store inventory-specific data (stock levels, capacity)
- **Proper Indexing**: Indexes on both foreign keys for join performance

## 6. Why are constraints like CHECK and UNIQUE important in a business context?

**Business Value of Constraints**:

**CHECK Constraints**:
- **Data Quality**: Ensure valid business values (price > cost)
- **Business Rules**: Enforce capacity limits, positive quantities
- **Error Prevention**: Catch invalid data at database level

**UNIQUE Constraints**:
- **Data Integrity**: Prevent duplicate serial numbers, barcodes
- **Business Logic**: Ensure one inventory record per product per machine
- **Operational Efficiency**: Enable reliable identification systems

**Examples in My System**:
```sql
-- Ensures profitability
CHECK (price > cost AND price > 0)
-- Prevents overstocking
CHECK (current_stock <= max_capacity)
-- Ensures unique machine identification
UNIQUE (serial_number)
```

## 7. How would you model historical data (e.g., price changes over time)?

**My Historical Data Strategy**:

**Price Change Audit Table**:
```sql
CREATE TABLE product_price_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    old_price DECIMAL(8,2),
    new_price DECIMAL(8,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_account VARCHAR(100)
);
```

**Alternative Approaches**:
1. **Slowly Changing Dimensions (SCD Type 2)**: Keep historical versions of product records
2. **Temporal Tables**: Use valid-from/valid-to dates
3. **Event Sourcing**: Store all changes as events

**Benefits of My Approach**:
- Maintains current operational efficiency
- Provides complete audit trail
- Supports pricing analytics and compliance
- Minimal impact on transactional performance

## 8. When would you use a view instead of a table? Give an example from your project.

**When to Use Views**:
- **Complex Queries**: Simplify frequently-used complex joins
- **Security**: Limit data access to specific columns/rows
- **Data Abstraction**: Hide underlying table complexity
- **Calculated Fields**: Provide computed values without storage

**Example from My Project**:
```sql
CREATE VIEW vw_machine_performance AS
SELECT 
    m.machine_id,
    m.location,
    COUNT(st.transaction_id) as total_transactions,
    SUM(st.total_price) as total_revenue,
    AVG(st.total_price) as avg_transaction_value,
    -- Complex calculations without storing redundant data
    ROUND(SUM(mi.current_stock) * 100.0 / SUM(mi.max_capacity), 1) as stock_fill_percentage
FROM machines m
LEFT JOIN sales_transactions st ON m.machine_id = st.machine_id
LEFT JOIN machine_inventory mi ON m.machine_id = mi.machine_id
GROUP BY m.machine_id;
```

**Benefits**: Simplifies reporting queries, provides consistent metrics, hides complexity from users.

## 9. What's the difference between a trigger and a stored procedure?

**Stored Procedures**:
- **Explicit Execution**: Called manually by applications or users
- **Parameters**: Accept input and output parameters
- **Control Flow**: Can contain complex business logic
- **Use Case**: Business operations, data processing, reporting

**Triggers**:
- **Automatic Execution**: Fire automatically on database events
- **Event-Driven**: Respond to INSERT, UPDATE, DELETE operations
- **No Parameters**: Work with NEW/OLD record values
- **Use Case**: Audit trails, business rule enforcement, data validation

**Examples from My Project**:

**Stored Procedure** (Manual execution):
```sql
CALL ProcessSale(1, 1, 1, 'CARD', 'CUSTOMER123', @trans_id, @total, @status);
```

**Trigger** (Automatic execution):
```sql
-- Automatically updates machine status when inventory changes
CREATE TRIGGER tr_check_machine_inventory
    AFTER UPDATE ON machine_inventory
    FOR EACH ROW
BEGIN
    -- Auto-maintenance mode if too many products out of stock
END;
```

## 10. What are some potential scalability issues you might face with your current design?

**Current Scalability Challenges**:

**1. Transaction Volume Growth**:
- **Issue**: Sales transactions table growing rapidly (500K+ records)
- **Solution**: Implement table partitioning by date/location

**2. Concurrent Access**:
- **Issue**: Multiple machines updating inventory simultaneously
- **Solution**: Implement optimistic locking, connection pooling

**3. Analytics Performance**:
- **Issue**: Complex reporting queries impacting operational performance
- **Solution**: Read replicas, separate analytics database

**4. Storage Growth**:
- **Issue**: Historical data accumulation
- **Solution**: Data archiving strategy, cold storage for old transactions

**Future Scalability Enhancements**:

```sql
-- Partition transactions by month
CREATE TABLE sales_transactions_2024_06 PARTITION OF sales_transactions
FOR VALUES FROM ('2024-06-01') TO ('2024-07-01');

-- Implement archiving
CREATE TABLE sales_transactions_archive
SELECT * FROM sales_transactions 
WHERE transaction_timestamp < DATE_SUB(NOW(), INTERVAL 2 YEAR);
```

**Additional Considerations**:
- **Horizontal Scaling**: Database clustering, sharding by location
- **Caching**: Redis for frequently accessed data
- **API Rate Limiting**: Prevent system overload
- **Monitoring**: Performance metrics and alerting systems
