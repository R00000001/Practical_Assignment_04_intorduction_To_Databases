# Vending Machine Database - Assignment 4

## What This Database Does

This database manages vending machines for a business. It tracks:
- Which products are in which machines
- When people buy things
- When machines need fixing
- How much money we make

## Business Problem

**Problem**: A company has vending machines in different places (school, office, mall) and needs to track everything.

**What we need to know**:
- What products sell well?
- Which machines make the most money?
- When do machines need more products?
- When do machines break and need fixing?

## Our 5 Main Tables

### 1. **machines** 
- Stores information about each vending machine
- Important because: These are our money-making assets
- Examples: Location, status (working/broken), when installed

### 2. **products**
- All the items we sell (chips, drinks, candy)
- Important because: This is what customers buy
- Examples: Name, price, how much it costs us

### 3. **categories**
- Groups products together (snacks, drinks, etc.)
- Important because: Helps organize our inventory
- Examples: "Beverages", "Snacks", "Candy"

### 4. **sales_transactions**
- Every time someone buys something
- Important because: This is how we make money
- Examples: What was bought, when, how much paid

### 5. **maintenance_logs**
- When machines get fixed or serviced
- Important because: Broken machines don't make money
- Examples: What was wrong, who fixed it, how much it cost

## How Tables Connect

- **Categories** → **Products** (One category has many products)
- **Machines** → **Sales** (One machine has many sales)
- **Products** → **Sales** (One product appears in many sales)
- **Machines** → **Maintenance** (One machine has many repair records)

## Database Rules (Constraints)

We added rules to make sure our data makes sense:

1. **Prices must be positive** - Can't sell something for $0 or negative money
2. **Selling price > cost price** - We need to make profit  
3. **Machine capacity limits** - Can't put more items than the machine holds
4. **Unique serial numbers** - Each machine has a different serial number
5. **Required information** - Important fields can't be empty

## Performance (Speed)

For fast searches on 500,000+ sales records, we added:
- **Indexes on dates** - Quick searches by time period
- **Indexes on machines** - Fast reports by location  
- **Indexes on products** - Quick product sales reports

## Different Types of Users

1. **Admin** - Can do everything
2. **Manager** - Can see sales, update inventory
3. **Analyst** - Can only view data for reports
4. **Technician** - Can only update maintenance records
5. **Clerk** - Can only manage inventory

## What Reports Can We Make?

- How much money did each machine make?
- Which products sell the most?
- Which machines need maintenance?
- What are our busiest sales hours?
- Which products are running low?

## Why This is OLTP (Not OLAP)

This database handles **transactions** (people buying things) in real-time:
- Fast when adding new sales
- Handles many people using it at once
- Keeps data accurate and consistent
- Good for daily business operations

(OLAP would be for analyzing historical data, not for running the business day-to-day)
