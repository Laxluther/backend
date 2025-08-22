#!/usr/bin/env python3
"""
Script to remove all product images from the database and filesystem
"""

import mysql.connector
import os
import shutil
from config import get_config

def remove_all_images():
    """Remove all product images from database and filesystem"""
    
    # Get database configuration
    config = get_config()
    
    # Database connection
    try:
        db = mysql.connector.connect(
            host=config.DB_HOST,
            user=config.DB_USER,
            password=config.DB_PASSWORD,
            database=config.DB_NAME,
            port=config.DB_PORT
        )
        cursor = db.cursor()
        
        print("Removing all product images...")
        
        # 1. Clear product_images table
        cursor.execute("DELETE FROM product_images")
        deleted_images = cursor.rowcount
        print(f"   Deleted {deleted_images} image records from database")
        
        # 2. Clear image URLs from products table (if any primary image columns exist)
        cursor.execute("DESCRIBE products")
        columns = [col[0] for col in cursor.fetchall()]
        
        if 'primary_image' in columns:
            cursor.execute("UPDATE products SET primary_image = NULL")
            print("   Cleared primary_image references from products")
            
        if 'image_url' in columns:
            cursor.execute("UPDATE products SET image_url = NULL")
            print("   Cleared image_url references from products")
        
        # 3. Remove physical image files
        upload_folders = [
            config.UPLOAD_FOLDER,
            os.path.join(config.UPLOAD_FOLDER, 'products'),
            './static/uploads',
            './static/uploads/products',
            './static/uploades',  # Found this typo in the file structure
            './static/uploades/products'
        ]
        
        for folder in upload_folders:
            if os.path.exists(folder):
                try:
                    # Remove all files in the folder but keep the folder structure
                    for root, dirs, files in os.walk(folder):
                        for file in files:
                            if file.lower().endswith(('.jpg', '.jpeg', '.png', '.webp', '.gif')):
                                file_path = os.path.join(root, file)
                                os.remove(file_path)
                                print(f"   Removed: {file_path}")
                except Exception as e:
                    print(f"   ⚠️  Error removing files from {folder}: {e}")
        
        # Commit database changes
        db.commit()
        print(f"\nSuccessfully removed all images:")
        print(f"   - {deleted_images} database records deleted")
        print(f"   - Physical image files removed from filesystem")
        print(f"   - Product image references cleared")
        
    except mysql.connector.Error as e:
        print(f"Database error: {e}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

if __name__ == "__main__":
    print("Image Cleanup Script")
    print("=" * 40)
    
    confirm = input("WARNING: This will permanently delete ALL product images. Continue? (y/N): ")
    if confirm.lower() == 'y':
        remove_all_images()
        print("\nImage cleanup completed!")
    else:
        print("Operation cancelled.")