#!/usr/bin/env python3
import os
import mysql.connector
import redis
from config import get_config

def test_mysql_connection():
    """Test MySQL database connection"""
    try:
        config = get_config()
        
        connection = mysql.connector.connect(
            host=config.DB_HOST,
            user=config.DB_USER,
            password=config.DB_PASSWORD,
            database=config.DB_NAME,
            port=config.DB_PORT
        )
        
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("SELECT VERSION()")
            version = cursor.fetchone()
            print(f"MySQL Connection: SUCCESS")
            print(f"   MySQL Version: {version[0]}")
            print(f"   Host: {config.DB_HOST}:{config.DB_PORT}")
            print(f"   Database: {config.DB_NAME}")
            
            # Test basic query
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            print(f"   Tables found: {len(tables)}")
            
            cursor.close()
            connection.close()
            return True
            
    except mysql.connector.Error as e:
        print(f"MySQL Connection: FAILED")
        print(f"   Error: {e}")
        print(f"   Host: {os.environ.get('DB_HOST', 'Not set')}")
        print(f"   User: {os.environ.get('DB_USER', 'Not set')}")
        print(f"   Database: {os.environ.get('DB_NAME', 'Not set')}")
        return False
    except Exception as e:
        print(f"MySQL Connection: FAILED")
        print(f"   Error: {e}")
        return False

def test_redis_connection():
    """Test Redis connection"""
    try:
        config = get_config()
        
        # Parse Redis URL
        redis_url = config.CACHE_REDIS_URL
        r = redis.from_url(redis_url)
        
        # Test connection
        r.ping()
        info = r.info()
        
        print(f"Redis Connection: SUCCESS")
        print(f"   Redis Version: {info.get('redis_version', 'Unknown')}")
        print(f"   URL: {redis_url}")
        print(f"   Used Memory: {info.get('used_memory_human', 'Unknown')}")
        
        # Test basic operations
        r.set('test_key', 'test_value', ex=10)
        value = r.get('test_key')
        if value == b'test_value':
            print(f"   Read/Write Test: SUCCESS")
        else:
            print(f"   Read/Write Test: FAILED")
            
        r.delete('test_key')
        return True
        
    except redis.RedisError as e:
        print(f"❌ Redis Connection: FAILED")
        print(f"   Error: {e}")
        print(f"   URL: {os.environ.get('REDIS_URL', 'Not set')}")
        return False
    except Exception as e:
        print(f"❌ Redis Connection: FAILED")
        print(f"   Error: {e}")
        return False

def test_volume_storage():
    """Test volume storage"""
    try:
        config = get_config()
        upload_folder = config.UPLOAD_FOLDER
        
        print(f"📁 Volume Storage Test:")
        print(f"   Upload Folder: {upload_folder}")
        
        # Check if directory exists
        if os.path.exists(upload_folder):
            print(f"   Directory Exists: ✅ YES")
            
            # Check if writable
            test_file = os.path.join(upload_folder, 'test_write.txt')
            try:
                with open(test_file, 'w') as f:
                    f.write('test')
                
                if os.path.exists(test_file):
                    print(f"   Write Test: ✅ SUCCESS")
                    os.remove(test_file)
                    return True
                else:
                    print(f"   Write Test: ❌ FAILED - File not created")
                    return False
                    
            except Exception as e:
                print(f"   Write Test: ❌ FAILED - {e}")
                return False
        else:
            print(f"   Directory Exists: ❌ NO")
            # Try to create it
            try:
                os.makedirs(upload_folder, exist_ok=True)
                print(f"   Directory Created: ✅ SUCCESS")
                return test_volume_storage()  # Recursive test
            except Exception as e:
                print(f"   Directory Creation: ❌ FAILED - {e}")
                return False
                
    except Exception as e:
        print(f"❌ Volume Storage Test: FAILED")
        print(f"   Error: {e}")
        return False

def main():
    print("Testing Railway Database Connections...")
    print("=" * 50)
    
    # Show environment
    print(f"Environment: {os.environ.get('FLASK_ENV', 'development')}")
    print(f"Railway Service: {os.environ.get('RAILWAY_SERVICE_NAME', 'Unknown')}")
    print("=" * 50)
    
    mysql_ok = test_mysql_connection()
    print()
    redis_ok = test_redis_connection()
    print()
    volume_ok = test_volume_storage()
    
    print("\n" + "=" * 50)
    print("SUMMARY:")
    print(f"   MySQL: {'OK' if mysql_ok else 'FAILED'}")
    print(f"   Redis: {'OK' if redis_ok else 'FAILED'}")
    print(f"   Volume: {'OK' if volume_ok else 'FAILED'}")
    
    if mysql_ok and redis_ok and volume_ok:
        print("\nAll connections successful!")
        return 0
    else:
        print("\nSome connections failed. Check the errors above.")
        return 1

if __name__ == "__main__":
    exit(main())