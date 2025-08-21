#!/usr/bin/env python3
import os
import mysql.connector

def import_schema():
    """Import the complete schema file to Railway MySQL"""
    try:
        # Get MySQL connection details from Railway environment
        mysql_public_url = "mysql://root:MFwUlSYxTIxKjaqUFvwVuZpmCBWlcpdX@interchange.proxy.rlwy.net:25477/railway"
        
        print("Connecting to Railway MySQL...")
        
        # Parse the URL
        import urllib.parse
        parsed = urllib.parse.urlparse(mysql_public_url)
        
        # Connect without specifying database first
        connection = mysql.connector.connect(
            host=parsed.hostname,
            user=parsed.username,
            password=parsed.password,
            port=parsed.port
        )
        
        cursor = connection.cursor()
        
        # Read the schema file
        print("Reading schema.sql file...")
        with open('schema.sql', 'r', encoding='utf-8') as f:
            schema_content = f.read()
        
        # Split into statements and execute
        statements = []
        current_statement = ""
        
        for line in schema_content.split('\n'):
            line = line.strip()
            
            # Skip comments and empty lines
            if line.startswith('--') or not line:
                continue
                
            # Handle MySQL directives
            if line.startswith('/*!') and line.endswith('*/;'):
                statements.append(line)
                continue
            
            current_statement += line + " "
            
            if line.endswith(';'):
                if current_statement.strip():
                    statements.append(current_statement.strip())
                current_statement = ""
        
        print(f"Executing {len(statements)} SQL statements...")
        
        executed = 0
        for i, statement in enumerate(statements):
            try:
                # Clean up the statement
                statement = statement.strip()
                if not statement:
                    continue
                    
                cursor.execute(statement)
                executed += 1
                
                if i % 50 == 0:
                    print(f"Executed {executed} statements...")
                    
            except mysql.connector.Error as e:
                if "already exists" in str(e) or "duplicate" in str(e).lower():
                    continue  # Skip duplicate errors
                print(f"Warning on statement {i+1}: {e}")
                print(f"Statement: {statement[:100]}...")
                continue
        
        connection.commit()
        print(f"Successfully executed {executed} statements")
        
        # Verify the ecommerce_db database was created
        cursor.execute("SHOW DATABASES LIKE 'ecommerce_db'")
        if cursor.fetchone():
            print("✓ ecommerce_db database created successfully")
            
            # Connect to ecommerce_db and show tables
            cursor.execute("USE ecommerce_db")
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            print(f"✓ Found {len(tables)} tables in ecommerce_db")
        else:
            print("✗ ecommerce_db database not found")
        
        cursor.close()
        connection.close()
        
        print("Schema import completed!")
        return True
        
    except Exception as e:
        print(f"Schema import failed: {e}")
        return False

if __name__ == "__main__":
    success = import_schema()
    exit(0 if success else 1)