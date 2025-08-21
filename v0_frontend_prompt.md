

## Backend API Base URL
```
https://web-production-8bfdb.up.railway.app
```

---

# COMPLETE API DOCUMENTATION

## Authentication Endpoints

### User Authentication
```typescript
// User Registration
POST /api/user/auth/register
Body: {
  email: string,
  password: string,
  first_name: string,
  last_name: string,
  phone: string,
  referral_code?: string
}
Response: { token: string, user: UserObject, message: string }

// User Login  
POST /api/user/auth/login
Body: { email: string, password: string }
Response: { token: string, user: UserObject, message: string }

// Get Current User
GET /api/user/auth/me
Headers: { Authorization: "Bearer <token>" }
Response: { user: UserObject }
```

### Admin Authentication
```typescript
// Admin Login
POST /api/admin/auth/login  
Body: { username: string, password: string }
Response: { token: string, admin: AdminObject, message: string }
```

## Public Product Endpoints (No Auth Required)

```typescript
// Get Featured Products
GET /api/public/products/featured
Response: { products: Product[] }

// Get All Products (with pagination)
GET /api/public/products?page=1&limit=20&category_id=1&sort_by=price&order=ASC
Response: {
  products: Product[],
  pagination: {
    page: number,
    limit: number, 
    total: number,
    total_pages: number,
    has_next: boolean,
    has_prev: boolean
  }
}

// Get Single Product
GET /api/public/products/{product_id}
Response: { product: ProductDetail }

// Search Products
POST /api/public/products/search
Body: { 
  query: string, 
  category_id?: number, 
  page?: number, 
  limit?: number 
}
Response: {
  products: Product[],
  search_query: string,
  pagination: PaginationObject
}

// Get Categories
GET /api/public/categories
Response: { categories: Category[] }
```

## User Dashboard Endpoints (Auth Required)

```typescript
// Get User Profile
GET /api/user/profile
Headers: { Authorization: "Bearer <token>" }
Response: {
  user: UserObject,
  default_address: AddressObject,
  stats: {
    total_orders: number,
    completed_orders: number,
    total_spent: number,
    wallet_balance: number
  }
}

// Update User Profile
PUT /api/user/profile
Headers: { Authorization: "Bearer <token>" }
Body: { first_name?: string, last_name?: string, phone?: string }
Response: { message: string }

// Get User Addresses
GET /api/user/addresses
Headers: { Authorization: "Bearer <token>" }
Response: { addresses: Address[] }

// Get User Orders
GET /api/user/orders
Headers: { Authorization: "Bearer <token>" }
Response: { orders: Order[] }

// Get User Cart
GET /api/user/cart
Headers: { Authorization: "Bearer <token>" }
Response: { cart: CartItem[] }

// Add to Cart
POST /api/user/cart/add
Headers: { Authorization: "Bearer <token>" }
Body: { product_id: number, quantity: number }
Response: { message: string }

// Get Wishlist
GET /api/user/wishlist
Headers: { Authorization: "Bearer <token>" }
Response: { wishlist: WishlistItem[] }
```

## Admin Dashboard Endpoints (Admin Auth Required)

```typescript
// Get Dashboard Stats
GET /api/admin/dashboard
Headers: { Authorization: "Bearer <admin_token>" }
Response: {
  stats: {
    total_products: number,
    total_users: number,
    total_orders: number,
    total_revenue: number
  }
}

// Products Management
GET /api/admin/products?page=1&per_page=20&search=query&status=active
POST /api/admin/products (Create Product)
PUT /api/admin/products/{product_id} (Update Product)  
DELETE /api/admin/products/{product_id} (Delete Product)

// Categories Management
GET /api/admin/categories
POST /api/admin/categories (Create Category)
PUT /api/admin/categories/{category_id} (Update Category)
DELETE /api/admin/categories/{category_id} (Delete Category)

// Users Management  
GET /api/admin/users?page=1&per_page=20&search=query&status=active
Response: { users: User[], pagination: PaginationObject }

// Orders Management
GET /api/admin/orders?page=1&per_page=20&status=pending
PUT /api/admin/orders/{order_id}/status
Body: { status: 'pending'|'confirmed'|'processing'|'shipped'|'delivered'|'cancelled' }

// Inventory Management
GET /api/admin/inventory?page=1&limit=50&status=low_stock&search=query
PUT /api/admin/inventory/{product_id}
Body: { 
  quantity: number, 
  low_stock_threshold?: number, 
  location?: string 
}
```

## Data Types

```typescript
interface Product {
  product_id: number;
  product_name: string;
  price: string;
  discount_price?: string;
  brand: string;
  category_name: string;
  primary_image: string;
  stock_quantity: number;
  in_stock: boolean;
  savings: number;
  created_at: string;
}

interface ProductDetail extends Product {
  description: string;
  images: ProductImage[];
  category_id: number;
  sku?: string;
  weight?: number;
  dimensions?: string;
  is_featured: boolean;
}

interface ProductImage {
  image_url: string;
  alt_text: string;
  is_primary: boolean;
  sort_order: number;
}

interface Category {
  category_id: number;
  category_name: string;
  description: string;
  image_url: string;
  product_count: number;
  status: string;
}

interface UserObject {
  user_id: string;
  email: string;
  first_name: string;
  last_name: string;
  phone: string;
  referral_code: string;
  email_verified: boolean;
  created_at: string;
}

interface Address {
  address_id: number;
  full_name: string;
  phone: string;
  address_line1: string;
  address_line2?: string;
  city: string;
  state: string;
  postal_code: string;
  country: string;
  is_default: boolean;
}

interface CartItem {
  cart_id: number;
  product_id: number;
  product_name: string;
  price: string;
  quantity: number;
  image_url: string;
}

interface Order {
  order_id: string;
  total_amount: string;
  status: string;
  created_at: string;
  items: OrderItem[];
}

---

# SPECIFIC IMPLEMENTATION NOTES

## Authentication Flow
```typescript
// Store JWT token in httpOnly cookie or localStorage
// Create auth context/store with Zustand:
interface AuthStore {
  user: User | null;
  admin: Admin | null;
  isAuthenticated: boolean;
  login: (credentials) => Promise<void>;
  logout: () => void;
  register: (userData) => Promise<void>;
}
```

## API Client Setup
```typescript
// Create axios instance with base URL and interceptors
const api = axios.create({
  baseURL: 'https://web-production-8bfdb.up.railway.app',
  headers: { 'Content-Type': 'application/json' }
});

// Add auth token to requests
api.interceptors.request.use((config) => {
  const token = getToken(); // from localStorage or cookie
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

## Image Handling
```tsx
// Use Next.js Image component for optimization
<Image 
  src={product.primary_image}
  alt={product.product_name}
  width={300}
  height={300}
  className="object-cover"
  placeholder="blur"
  blurDataURL="data:image/jpeg;base64,..."
/>
```

## Form Validation Examples
```typescript
// Product search form schema
const searchSchema = z.object({
  query: z.string().min(1, "Search query is required"),
  category_id: z.number().optional(),
  page: z.number().default(1),
  limit: z.number().default(20)
});

// User registration schema
const registerSchema = z.object({
  email: z.string().email("Invalid email format"),
  password: z.string().min(6, "Password must be at least 6 characters"),
  first_name: z.string().min(1, "First name is required"),
  last_name: z.string().min(1, "Last name is required"),
  phone: z.string().regex(/^[6-9]\d{9}$/, "Invalid phone number")
});
```

## State Management Pattern
```typescript
// Example cart store with Zustand
interface CartStore {
  items: CartItem[];
  totalItems: number;
  totalAmount: number;
  addItem: (productId: number, quantity: number) => Promise<void>;
  removeItem: (cartId: number) => Promise<void>;
  updateQuantity: (cartId: number, quantity: number) => Promise<void>;
  clearCart: () => void;
  fetchCart: () => Promise<void>;
}
```

---
