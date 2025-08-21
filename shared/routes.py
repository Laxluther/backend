from flask import Blueprint, jsonify
from shared.models import execute_query
from shared.image_utils import convert_products_images, convert_category_images, convert_product_images, convert_image_url
from datetime import datetime

shared_bp = Blueprint('shared', __name__)

@shared_bp.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'healthy',
        'message': 'E-commerce API is running',
        'timestamp': datetime.now().isoformat(),
        'version': '2.0'
    }), 200

@shared_bp.route('/public/products/featured', methods=['GET'])
def public_featured_products():
    products = execute_query("""
        SELECT p.product_id, p.product_name, p.price, p.discount_price, p.brand,
               (SELECT pi.image_url FROM product_images pi 
                WHERE pi.product_id = p.product_id AND pi.is_primary = 1 
                LIMIT 1) as primary_image,
               (SELECT i.quantity FROM inventory i 
                WHERE i.product_id = p.product_id) as stock_quantity
        FROM products p 
        WHERE p.is_featured = 1 AND p.status = 'active'
        ORDER BY p.created_at DESC LIMIT 6
    """, fetch_all=True)
    
    # Convert image URLs to absolute URLs and add stock status
    products = convert_products_images(products)
    
    # ADDED: Calculate in_stock status and savings for each product
    for product in products:
        # Set in_stock based on stock_quantity
        product['in_stock'] = (product.get('stock_quantity') or 0) > 0
        
        # Calculate savings if discount exists
        if product.get('discount_price') and product.get('price'):
            product['savings'] = round(float(product['price']) - float(product['discount_price']), 2)
        else:
            product['savings'] = 0
        
        # Add category name if needed (for consistency)
        if not product.get('category_name'):
            product['category_name'] = ''
    
    return jsonify({'products': products}), 200

@shared_bp.route('/public/categories', methods=['GET'])
def public_categories():
    categories = execute_query("""
        SELECT c.category_id, c.category_name, c.description, c.image_url,
               (SELECT COUNT(*) FROM products p 
                WHERE p.category_id = c.category_id AND p.status = 'active') as product_count
        FROM categories c
        WHERE c.status = 'active' 
        ORDER BY c.sort_order, c.category_name
    """, fetch_all=True)
    
    # Convert image URLs to absolute URLs
    categories = convert_category_images(categories)
    
    return jsonify({'categories': categories}), 200

@shared_bp.route('/public/products/<int:product_id>', methods=['GET'])
def public_product_detail(product_id):
    product = execute_query("""
        SELECT p.*, c.category_name,
               (SELECT pi.image_url FROM product_images pi 
                WHERE pi.product_id = p.product_id AND pi.is_primary = 1 
                LIMIT 1) as primary_image
        FROM products p 
        LEFT JOIN categories c ON p.category_id = c.category_id
        WHERE p.product_id = %s AND p.status = 'active'
    """, (product_id,), fetch_one=True)
    
    if not product:
        return jsonify({'error': 'Product not found'}), 404
    
    # Get all product images
    images = execute_query("""
        SELECT image_url, alt_text, is_primary, sort_order
        FROM product_images 
        WHERE product_id = %s 
        ORDER BY sort_order, is_primary DESC
    """, (product_id,), fetch_all=True)
    
    # Convert image URLs to absolute URLs
    product = convert_product_images(product)
    for img in images:
        img['image_url'] = convert_image_url(img['image_url'])
    
    product['images'] = images
    
    return jsonify({'product': product}), 200

@shared_bp.route('/public/products', methods=['GET'])
def public_products():
    """Get all public products with pagination and filtering"""
    from flask import request
    
    # Get query parameters
    page = int(request.args.get('page', 1))
    limit = int(request.args.get('limit', 20))
    category_id = request.args.get('category_id')
    sort_by = request.args.get('sort_by', 'created_at')
    order = request.args.get('order', 'DESC')
    
    # Calculate offset
    offset = (page - 1) * limit
    
    # Build query
    where_conditions = ["p.status = 'active'"]
    params = []
    
    if category_id:
        where_conditions.append("p.category_id = %s")
        params.append(category_id)
    
    # Validate sort options
    valid_sort_fields = ['created_at', 'price', 'product_name', 'discount_price']
    if sort_by not in valid_sort_fields:
        sort_by = 'created_at'
    
    if order.upper() not in ['ASC', 'DESC']:
        order = 'DESC'
    
    where_clause = " AND ".join(where_conditions)
    
    # Get products with pagination
    products = execute_query(f"""
        SELECT p.product_id, p.product_name, p.price, p.discount_price, p.brand,
               p.description, p.created_at, c.category_name,
               (SELECT pi.image_url FROM product_images pi 
                WHERE pi.product_id = p.product_id AND pi.is_primary = 1 
                LIMIT 1) as primary_image,
               (SELECT i.quantity FROM inventory i 
                WHERE i.product_id = p.product_id) as stock_quantity
        FROM products p 
        LEFT JOIN categories c ON p.category_id = c.category_id
        WHERE {where_clause}
        ORDER BY p.{sort_by} {order}
        LIMIT %s OFFSET %s
    """, params + [limit, offset], fetch_all=True)
    
    # Get total count for pagination
    count_result = execute_query(f"""
        SELECT COUNT(*) as total
        FROM products p
        WHERE {where_clause}
    """, params, fetch_one=True)
    
    total_products = count_result['total'] if count_result else 0
    total_pages = (total_products + limit - 1) // limit
    
    # Convert image URLs and add stock status
    products = convert_products_images(products)
    
    for product in products:
        product['in_stock'] = (product.get('stock_quantity') or 0) > 0
        if product.get('discount_price') and product.get('price'):
            product['savings'] = round(float(product['price']) - float(product['discount_price']), 2)
        else:
            product['savings'] = 0
    
    return jsonify({
        'products': products,
        'pagination': {
            'page': page,
            'limit': limit,
            'total': total_products,
            'total_pages': total_pages,
            'has_next': page < total_pages,
            'has_prev': page > 1
        }
    }), 200

@shared_bp.route('/public/products/search', methods=['POST'])
def public_products_search():
    """Search products by name, description, or category"""
    from flask import request
    
    data = request.get_json()
    query = data.get('query', '').strip()
    category_id = data.get('category_id')
    page = int(data.get('page', 1))
    limit = int(data.get('limit', 20))
    
    if not query:
        return jsonify({'error': 'Search query is required'}), 400
    
    # Calculate offset
    offset = (page - 1) * limit
    
    # Build search query
    search_conditions = [
        "p.status = 'active'",
        "(p.product_name LIKE %s OR p.description LIKE %s OR c.category_name LIKE %s)"
    ]
    
    search_term = f"%{query}%"
    params = [search_term, search_term, search_term]
    
    if category_id:
        search_conditions.append("p.category_id = %s")
        params.append(category_id)
    
    where_clause = " AND ".join(search_conditions)
    
    # Search products
    products = execute_query(f"""
        SELECT p.product_id, p.product_name, p.price, p.discount_price, p.brand,
               p.description, p.created_at, c.category_name,
               (SELECT pi.image_url FROM product_images pi 
                WHERE pi.product_id = p.product_id AND pi.is_primary = 1 
                LIMIT 1) as primary_image,
               (SELECT i.quantity FROM inventory i 
                WHERE i.product_id = p.product_id) as stock_quantity
        FROM products p 
        LEFT JOIN categories c ON p.category_id = c.category_id
        WHERE {where_clause}
        ORDER BY 
            CASE 
                WHEN p.product_name LIKE %s THEN 1 
                WHEN p.description LIKE %s THEN 2
                ELSE 3 
            END,
            p.created_at DESC
        LIMIT %s OFFSET %s
    """, params + [search_term, search_term, limit, offset], fetch_all=True)
    
    # Get total count
    count_result = execute_query(f"""
        SELECT COUNT(*) as total
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.category_id
        WHERE {where_clause}
    """, params, fetch_one=True)
    
    total_results = count_result['total'] if count_result else 0
    total_pages = (total_results + limit - 1) // limit
    
    # Convert image URLs and add stock status
    products = convert_products_images(products)
    
    for product in products:
        product['in_stock'] = (product.get('stock_quantity') or 0) > 0
        if product.get('discount_price') and product.get('price'):
            product['savings'] = round(float(product['price']) - float(product['discount_price']), 2)
        else:
            product['savings'] = 0
    
    return jsonify({
        'products': products,
        'search_query': query,
        'pagination': {
            'page': page,
            'limit': limit,
            'total': total_results,
            'total_pages': total_pages,
            'has_next': page < total_pages,
            'has_prev': page > 1
        }
    }), 200

@shared_bp.route('/states', methods=['GET'])
def get_indian_states():
    states = [
        {"code": "AN", "name": "Andaman and Nicobar Islands"},
        {"code": "AP", "name": "Andhra Pradesh"},
        {"code": "AR", "name": "Arunachal Pradesh"},
        {"code": "AS", "name": "Assam"},
        {"code": "BR", "name": "Bihar"},
        {"code": "CH", "name": "Chandigarh"},
        {"code": "CT", "name": "Chhattisgarh"},
        {"code": "DN", "name": "Dadra and Nagar Haveli"},
        {"code": "DD", "name": "Daman and Diu"},
        {"code": "DL", "name": "Delhi"},
        {"code": "GA", "name": "Goa"},
        {"code": "GJ", "name": "Gujarat"},
        {"code": "HR", "name": "Haryana"},
        {"code": "HP", "name": "Himachal Pradesh"},
        {"code": "JK", "name": "Jammu and Kashmir"},
        {"code": "JH", "name": "Jharkhand"},
        {"code": "KA", "name": "Karnataka"},
        {"code": "KL", "name": "Kerala"},
        {"code": "LD", "name": "Lakshadweep"},
        {"code": "MP", "name": "Madhya Pradesh"},
        {"code": "MH", "name": "Maharashtra"},
        {"code": "MN", "name": "Manipur"},
        {"code": "ML", "name": "Meghalaya"},
        {"code": "MZ", "name": "Mizoram"},
        {"code": "NL", "name": "Nagaland"},
        {"code": "OR", "name": "Odisha"},
        {"code": "PY", "name": "Puducherry"},
        {"code": "PB", "name": "Punjab"},
        {"code": "RJ", "name": "Rajasthan"},
        {"code": "SK", "name": "Sikkim"},
        {"code": "TN", "name": "Tamil Nadu"},
        {"code": "TG", "name": "Telangana"},
        {"code": "TR", "name": "Tripura"},
        {"code": "UP", "name": "Uttar Pradesh"},
        {"code": "UT", "name": "Uttarakhand"},
        {"code": "WB", "name": "West Bengal"}
    ]
    
    return jsonify({'states': states}), 200