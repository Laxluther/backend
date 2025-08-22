#!/usr/bin/env python3
"""
Script to clean database for coffee-focused application
Keeps: admin users only
Removes: all products, categories, orders, users (except admin), addresses, cart, wishlist, referrals
"""

import mysql.connector
from config import get_config

def clean_database_for_coffee():
    """Clean database and prepare for coffee-focused application"""
    
    config = get_config()
    
    try:
        db = mysql.connector.connect(
            host=config.DB_HOST,
            user=config.DB_USER,
            password=config.DB_PASSWORD,
            database=config.DB_NAME,
            port=config.DB_PORT
        )
        cursor = db.cursor()
        
        print("Cleaning database for coffee-focused application...")
        print("=" * 50)
        
        # Disable foreign key checks temporarily
        cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
        
        # 1. Clear all order-related data
        tables_to_clear = [
            'order_items',
            'orders',
            'cart_items', 
            'wishlist_items',
            'addresses'
        ]
        
        for table in tables_to_clear:
            try:
                cursor.execute(f"DELETE FROM {table}")
                count = cursor.rowcount
                print(f"   Cleared {table}: {count} records deleted")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not clear {table}: {e}")
        
        # 2. Clear all products and categories
        product_tables = [
            'product_images',
            'inventory_logs', 
            'product_reviews',
            'products',
            'categories'
        ]
        
        for table in product_tables:
            try:
                cursor.execute(f"DELETE FROM {table}")
                count = cursor.rowcount
                print(f"   Cleared {table}: {count} records deleted")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not clear {table}: {e}")
        
        # 3. Clear referral data
        referral_tables = [
            'referral_transactions',
            'user_referrals'
        ]
        
        for table in referral_tables:
            try:
                cursor.execute(f"DELETE FROM {table}")
                count = cursor.rowcount
                print(f"   Cleared {table}: {count} records deleted")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not clear {table}: {e}")
        
        # 4. Remove all regular users (keep only admin)
        cursor.execute("DELETE FROM users WHERE user_id NOT IN (SELECT DISTINCT admin_id FROM admins WHERE admin_id IS NOT NULL)")
        deleted_users = cursor.rowcount
        print(f"   Cleared users: {deleted_users} regular users deleted (admin preserved)")
        
        # 5. Clear wallets and transactions
        wallet_tables = [
            'wallet_transactions',
            'wallets'
        ]
        
        for table in wallet_tables:
            try:
                cursor.execute(f"DELETE FROM {table}")
                count = cursor.rowcount
                print(f"   Cleared {table}: {count} records deleted")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not clear {table}: {e}")
        
        # 6. Insert coffee-focused category
        print("\n   Creating coffee category...")
        cursor.execute("""
            INSERT INTO categories (category_name, description, status, created_at, updated_at) 
            VALUES ('Coffee', 'Premium coffee beans and blends', 'active', NOW(), NOW())
        """)
        coffee_category_id = cursor.lastrowid
        print(f"   Created Coffee category with ID: {coffee_category_id}")
        
        # 7. Reset auto-increment counters
        reset_tables = [
            'products', 'categories', 'orders', 'addresses', 
            'cart_items', 'wishlist_items', 'product_images'
        ]
        
        for table in reset_tables:
            try:
                cursor.execute(f"ALTER TABLE {table} AUTO_INCREMENT = 1")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not reset auto-increment for {table}: {e}")
        
        # Re-enable foreign key checks
        cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
        
        # Commit all changes
        db.commit()
        
        print("\nDatabase cleanup completed successfully!")
        print("=" * 50)
        print("Ready for coffee-focused application:")
        print("   - All products and categories removed")
        print("   - All user data cleared (except admin)")
        print("   - All orders and transactions removed")
        print("   - Fresh coffee category created")
        print("   - Database ready for new coffee products")
        
    except mysql.connector.Error as e:
        print(f"Database error: {e}")
        db.rollback()
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

if __name__ == "__main__":
    print("Coffee-Focused Database Cleanup")
    print("=" * 40)
    
    confirm = input("WARNING: This will delete ALL data except admin. Continue? (y/N): ")
    if confirm.lower() == 'y':
        clean_database_for_coffee()
        print("\nDatabase is now ready for coffee-focused application!")
    else:
        print("Operation cancelled.")