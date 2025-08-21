#!/usr/bin/env python3
import os
import mysql.connector
from config import get_config

def setup_railway_database():
    """Setup Railway database with schema"""
    try:
        config = get_config()
        
        print("Setting up Railway MySQL Database...")
        print(f"Host: {config.DB_HOST}")
        print(f"Database: {config.DB_NAME}")
        print(f"User: {config.DB_USER}")
        
        # Try different connection methods
        mysql_url = os.environ.get('MYSQL_PUBLIC_URL')
        if mysql_url:
            print(f"Using public MySQL URL for external connection")
            # Parse the URL: mysql://user:password@host:port/database
            import urllib.parse
            parsed = urllib.parse.urlparse(mysql_url)
            connection = mysql.connector.connect(
                host=parsed.hostname,
                user=parsed.username,
                password=parsed.password,
                port=parsed.port,
                database=parsed.path[1:] if parsed.path else None
            )
        else:
            # First connect without specifying database
            connection = mysql.connector.connect(
                host=config.DB_HOST,
                user=config.DB_USER,
                password=config.DB_PASSWORD,
                port=config.DB_PORT
            )
        
        cursor = connection.cursor()
        
        # Check if database exists, if not create it
        cursor.execute("SHOW DATABASES LIKE %s", (config.DB_NAME,))
        result = cursor.fetchone()
        
        if not result:
            print(f"Creating database: {config.DB_NAME}")
            cursor.execute(f"CREATE DATABASE {config.DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci")
            print("Database created successfully!")
        else:
            print("Database already exists")
            
        # Now connect to the specific database
        cursor.close()
        connection.close()
        
        # Reconnect to the specific database
        if mysql_url:
            # Use the same parsed URL for reconnection
            connection = mysql.connector.connect(
                host=parsed.hostname,
                user=parsed.username,
                password=parsed.password,
                port=parsed.port,
                database=parsed.path[1:] if parsed.path else config.DB_NAME
            )
        else:
            connection = mysql.connector.connect(
                host=config.DB_HOST,
                user=config.DB_USER,
                password=config.DB_PASSWORD,
                database=config.DB_NAME,
                port=config.DB_PORT
            )
        
        cursor = connection.cursor()
        
        # Check if tables exist
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        
        if len(tables) == 0:
            print("No tables found. Reading schema file...")
            
            # Read and execute schema file
            with open('schema.sql', 'r', encoding='utf-8') as f:
                schema_content = f.read()
            
            # Split the schema into individual statements
            statements = []
            current_statement = ""
            
            for line in schema_content.split('\n'):
                line = line.strip()
                
                # Skip comments and empty lines
                if line.startswith('--') or line.startswith('/*') or not line:
                    continue
                    
                # Skip MySQL dump directives
                if line.startswith('/*!') and line.endswith('*/;'):
                    continue
                
                current_statement += line + " "
                
                if line.endswith(';'):
                    if current_statement.strip():
                        statements.append(current_statement.strip())
                    current_statement = ""
            
            print(f"Found {len(statements)} SQL statements")
            
            # Execute each statement
            executed_count = 0
            for i, statement in enumerate(statements):
                try:
                    # Skip certain statements that might cause issues
                    if any(skip in statement.upper() for skip in [
                        'DROP DATABASE', 
                        'CREATE DATABASE', 
                        'USE ', 
                        'LOCK TABLES', 
                        'UNLOCK TABLES',
                        'SET @OLD_',
                        'SET NAMES',
                        'SET TIME_ZONE',
                        'SET UNIQUE_CHECKS',
                        'SET FOREIGN_KEY_CHECKS',
                        'SET SQL_MODE',
                        'SET SQL_NOTES'
                    ]):
                        continue
                        
                    cursor.execute(statement)
                    executed_count += 1
                    
                except mysql.connector.Error as e:
                    print(f"Warning: Statement {i+1} failed: {e}")
                    print(f"Statement: {statement[:100]}...")
                    continue
            
            connection.commit()
            print(f"Successfully executed {executed_count} statements")
            
        else:
            print(f"Database already has {len(tables)} tables:")
            for table in tables:
                print(f"  - {table[0]}")
        
        # Verify setup
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        print(f"\nFinal verification: {len(tables)} tables in database")
        
        cursor.close()
        connection.close()
        
        print("Database setup completed successfully!")
        return True
        
    except Exception as e:
        print(f"Database setup failed: {e}")
        return False

if __name__ == "__main__":
    success = setup_railway_database()
    exit(0 if success else 1)