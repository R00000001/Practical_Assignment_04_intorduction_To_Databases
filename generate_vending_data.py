import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta
from tqdm import tqdm

fake = Faker()

# Number of rows to generate (Config)
NUM_CATEGORIES = 20  # Reasonable number of product categories for vending machines
NUM_MACHINES = 500   # Number of vending machines
NUM_PRODUCTS = 500000   # Number of different products
NUM_TRANSACTIONS = 100000  # Number of transactions
NUM_MAINTENANCE = 5000     # Number of maintenance logs

print("Generating categories...")
# Generate categories (snacks, drinks, etc.)
category_names = [
    "Snacks", "Beverages", "Candy", "Chips", "Cookies", "Energy Drinks", 
    "Water", "Soda", "Juice", "Coffee", "Tea", "Nuts", "Crackers", 
    "Chocolate", "Gum", "Mints", "Sandwiches", "Salads", "Protein Bars", "Fruit"
]

categories = pd.DataFrame({
    "category_id": list(range(1, NUM_CATEGORIES + 1)),
    "name": category_names[:NUM_CATEGORIES]
})
categories.to_csv("categories.csv", index=False)
print(f"Generated {len(categories)} categories")

print("Generating machines...")
# Generate vending machines
locations = [
    "Office Building A", "Office Building B", "University Campus", "Hospital",
    "Shopping Mall", "Airport Terminal", "Train Station", "Subway Station",
    "Library", "Gym", "Hotel Lobby", "School Cafeteria", "Factory Floor",
    "Warehouse", "Parking Garage", "Sports Complex", "Community Center",
    "Government Building", "Corporate Headquarters", "Medical Center"
]

machines = pd.DataFrame({
    "machine_id": list(range(1, NUM_MACHINES + 1)),
    "location": [f"{random.choice(locations)} - Floor {random.randint(1, 10)}" for _ in range(NUM_MACHINES)],
    "category_id": [random.randint(1, NUM_CATEGORIES) for _ in range(NUM_MACHINES)],
    "status": [random.choice(["Active", "Inactive"]) for _ in range(NUM_MACHINES)],
    "installation_date": [fake.date_time_between(start_date="-5y", end_date="-1y") for _ in range(NUM_MACHINES)]
})
machines.to_csv("machines.csv", index=False)
print(f"Generated {len(machines)} machines")

print("Generating products...")
# Generate products with realistic names for vending machines
product_names = {
    1: ["Potato Chips", "Doritos", "Cheetos", "Pretzels", "Popcorn"],
    2: ["Coca Cola", "Pepsi", "Sprite", "Orange Juice", "Apple Juice"],
    3: ["Snickers", "Kit Kat", "Twix", "M&Ms", "Skittles"],
    4: ["Lay's Classic", "Ruffles", "Pringles", "Sun Chips", "Kettle Chips"],
    5: ["Oreos", "Chips Ahoy", "Nutter Butter", "Fig Newtons", "Vanilla Wafers"],
    6: ["Red Bull", "Monster", "Rockstar", "5-Hour Energy", "Bang Energy"],
    7: ["Aquafina", "Dasani", "Smartwater", "Fiji", "Evian"],
    8: ["Diet Coke", "Dr Pepper", "Mountain Dew", "7UP", "Root Beer"],
    9: ["Tropicana", "Minute Maid", "Simply Orange", "Cranberry Juice", "Grape Juice"],
    10: ["Starbucks Coffee", "Dunkin Coffee", "Folgers", "Maxwell House", "Nescafe"]
}

products_data = []
product_id = 1

for category_id in range(1, NUM_CATEGORIES + 1):
    # Get base names for this category, or generate generic ones
    base_names = product_names.get(category_id, [f"Product {i}" for i in range(1, 11)])
    
    # Generate 8-12 products per category
    num_products_in_category = random.randint(8, 12)
    
    for i in range(num_products_in_category):
        if product_id > NUM_PRODUCTS:
            break
            
        # Use base names with variations
        if i < len(base_names):
            name = base_names[i]
        else:
            name = f"{random.choice(base_names)} {random.choice(['Classic', 'Original', 'Special', 'Premium', 'Deluxe'])}"
        
        # Set realistic prices for vending machine items
        if category_id in [1, 3, 4, 5]:  # Snacks, candy, chips, cookies
            price = round(random.uniform(1.25, 3.50), 2)
        elif category_id in [2, 6, 7, 8, 9, 10]:  # Beverages
            price = round(random.uniform(1.50, 4.00), 2)
        else:  # Other categories
            price = round(random.uniform(1.00, 5.00), 2)
        
        products_data.append({
            "product_id": product_id,
            "name": name,
            "category_id": category_id,
            "price": price
        })
        
        product_id += 1
        
        if product_id > NUM_PRODUCTS:
            break

products = pd.DataFrame(products_data)
products.to_csv("products.csv", index=False)
print(f"Generated {len(products)} products")

print("Generating transactions...")
# Generate transactions
transactions_data = []
for _ in tqdm(range(NUM_TRANSACTIONS), desc="Generating transactions"):
    machine_id = random.randint(1, NUM_MACHINES)
    product_id = random.randint(1, len(products))
    
    # Get the product price
    product_price = products[products['product_id'] == product_id]['price'].iloc[0]
    
    # Generate realistic transaction times (more during business hours)
    hour = random.choices(
        range(24), 
        weights=[1, 1, 1, 1, 1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2]
    )[0]
    
    transaction_time = fake.date_time_between(start_date="-1y", end_date="now").replace(
        hour=hour, 
        minute=random.randint(0, 59), 
        second=random.randint(0, 59)
    )
    
    # Amount is usually 1-3 items
    amount = random.choices([1, 2, 3], weights=[70, 25, 5])[0]
    total_price = round(product_price * amount, 2)
    
    transactions_data.append([
        machine_id, product_id, transaction_time, amount, total_price
    ])

transactions = pd.DataFrame(transactions_data, columns=[
    "machine_id", "product_id", "time_stamp", "amount", "total_price"
])
transactions.to_csv("transactions.csv", index=False)
print(f"Generated {len(transactions)} transactions")

print("Generating maintenance logs...")
# Generate maintenance logs
maintenance_reasons = [
    "Routine maintenance", "Product refill", "Coin jam", "Bill acceptor issue",
    "Display malfunction", "Cooling system repair", "Door lock repair",
    "Vending mechanism stuck", "Power supply issue", "Network connectivity",
    "Cleaning and sanitization", "Software update", "Inventory audit",
    "Temperature sensor calibration", "Cash collection", "Product expiry check"
]

maintenance_data = []
for _ in tqdm(range(NUM_MAINTENANCE), desc="Generating maintenance logs"):
    machine_id = random.randint(1, NUM_MACHINES)
    
    # Maintenance usually happens during off-hours
    hour = random.choices(
        range(24),
        weights=[8, 8, 8, 8, 8, 6, 4, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 6, 8, 8, 8]
    )[0]
    
    maintenance_date = fake.date_time_between(start_date="-2y", end_date="now").replace(
        hour=hour,
        minute=random.randint(0, 59),
        second=random.randint(0, 59)
    )
    
    reason = random.choice(maintenance_reasons)
    
    maintenance_data.append([machine_id, maintenance_date, reason])

maintenance_log = pd.DataFrame(maintenance_data, columns=[
    "machine_id", "date", "reason"
])
maintenance_log.to_csv("maintenance_log.csv", index=False)
print(f"Generated {len(maintenance_log)} maintenance logs")

print("\nData generation complete!")
print("Generated files:")
print("- categories.csv")
print("- machines.csv") 
print("- products.csv")
print("- transactions.csv")
print("- maintenance_log.csv")

# Print some statistics
print(f"\nStatistics:")
print(f"Categories: {len(categories)}")
print(f"Machines: {len(machines)}")
print(f"Products: {len(products)}")
print(f"Transactions: {len(transactions)}")
print(f"Maintenance logs: {len(maintenance_log)}")

print(f"\nTotal revenue from transactions: ${transactions['total_price'].sum():,.2f}")
print(f"Average transaction value: ${transactions['total_price'].mean():.2f}")
print(f"Most expensive product: ${products['price'].max():.2f}")
print(f"Cheapest product: ${products['price'].min():.2f}")
