#!/usr/bin/env python3
"""
Corrected script to clean database for coffee-focused application
"""

import mysql.connector
from config import get_config

def clean_database_for_coffee():
    """Clean database with correct table names"""
    
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
        
        # 1. Clear all order and user-related data
        tables_to_clear = [
            'order_items',
            'orders', 
            'cart',
            'wishlist',
            'addresses',
            'wallet_transactions',
            'wallet',
            'reviews',
            'order_tracking'
        ]
        
        for table in tables_to_clear:
            try:
                cursor.execute(f"DELETE FROM {table}")
                count = cursor.rowcount
                print(f"   Cleared {table}: {count} records deleted")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not clear {table}: {e}")
        
        # 2. Clear products and related data
        product_tables = [
            'product_images',
            'product_variants',
            'products'
        ]
        
        for table in product_tables:
            try:
                cursor.execute(f"DELETE FROM {table}")
                count = cursor.rowcount
                print(f"   Cleared {table}: {count} records deleted")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not clear {table}: {e}")
        
        # 3. Clear categories
        cursor.execute("DELETE FROM categories")
        categories_deleted = cursor.rowcount
        print(f"   Cleared categories: {categories_deleted} records deleted")
        
        # 4. Clear referral data
        referral_tables = [
            'referral_uses',
            'referral_codes'
        ]
        
        for table in referral_tables:
            try:
                cursor.execute(f"DELETE FROM {table}")
                count = cursor.rowcount
                print(f"   Cleared {table}: {count} records deleted")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not clear {table}: {e}")
        
        # 5. Clear verification and password reset data
        auth_tables = [
            'email_verifications',
            'password_reset_tokens'
        ]
        
        for table in auth_tables:
            try:
                cursor.execute(f"DELETE FROM {table}")
                count = cursor.rowcount
                print(f"   Cleared {table}: {count} records deleted")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not clear {table}: {e}")
        
        # 6. Remove all regular users (keep only admin users)
        cursor.execute("DELETE FROM users WHERE user_id NOT IN (SELECT user_id FROM admin_users)")
        deleted_users = cursor.rowcount
        print(f"   Cleared users: {deleted_users} regular users deleted (admin preserved)")
        
        # 7. Clear inventory and promocodes
        other_tables = [
            'inventory',
            'promocodes'
        ]
        
        for table in other_tables:
            try:
                cursor.execute(f"DELETE FROM {table}")
                count = cursor.rowcount
                print(f"   Cleared {table}: {count} records deleted")
            except mysql.connector.Error as e:
                print(f"   Warning: Could not clear {table}: {e}")
        
        # 8. Insert coffee-focused category
        print("\n   Creating coffee category...")
        cursor.execute("""
            INSERT INTO categories (category_name, description, status, created_at, updated_at) 
            VALUES ('Premium Coffee', 'Artisan coffee beans and premium blends', 'active', NOW(), NOW())
        """)
        coffee_category_id = cursor.lastrowid
        print(f"   Created Premium Coffee category with ID: {coffee_category_id}")
        
        # 9. Reset auto-increment counters
        reset_tables = [
            'products', 'categories', 'orders', 'addresses', 
            'cart', 'wishlist', 'product_images', 'reviews'
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
        print("Coffee-focused application ready:")
        print("   - All products and old categories removed")
        print("   - All user data cleared (admin preserved)")
        print("   - All orders and transactions removed")
        print("   - Fresh 'Premium Coffee' category created")
        print("   - Database ready for coffee products only")
        
        return coffee_category_id
        
    except mysql.connector.Error as e:
        print(f"Database error: {e}")
        db.rollback()
        return None
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
        return None
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

if __name__ == "__main__":
    print("Coffee-Focused Database Cleanup (Corrected)")
    print("=" * 40)
    
    confirm = input("WARNING: This will delete ALL data except admin. Continue? (y/N): ")
    if confirm.lower() == 'y':
        category_id = clean_database_for_coffee()
        if category_id:
            print(f"\nSuccess! Coffee category created with ID: {category_id}")
            print("Database is ready for your coffee-focused application!")
        else:
            print("\nSome errors occurred. Please check the output above.")
    else:
        print("Operation cancelled.")