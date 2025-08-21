#!/usr/bin/env python3
import requests
import json
import uuid
import time
from datetime import datetime

class APITester:
    def __init__(self, base_url="https://web-production-8bfdb.up.railway.app"):
        self.base_url = base_url
        self.admin_token = None
        self.user_token = None
        self.test_results = []
        self.session = requests.Session()
        
    def log_result(self, endpoint, method, status, expected_status, response_time, notes=""):
        result = {
            'endpoint': endpoint,
            'method': method,
            'status': status,
            'expected': expected_status,
            'success': status == expected_status,
            'response_time': response_time,
            'notes': notes
        }
        self.test_results.append(result)
        
        status_icon = "OK" if result['success'] else "FAIL"
        print(f"{status_icon} {method} {endpoint} - {status} ({response_time:.2f}s) {notes}")
        
    def test_endpoint(self, endpoint, method="GET", data=None, headers=None, expected_status=200, notes=""):
        url = f"{self.base_url}{endpoint}"
        start_time = time.time()
        
        try:
            if method == "GET":
                response = self.session.get(url, headers=headers, timeout=10)
            elif method == "POST":
                response = self.session.post(url, json=data, headers=headers, timeout=10)
            elif method == "PUT":
                response = self.session.put(url, json=data, headers=headers, timeout=10)
            elif method == "DELETE":
                response = self.session.delete(url, headers=headers, timeout=10)
            
            response_time = time.time() - start_time
            
            # Try to parse JSON response
            try:
                json_data = response.json()
                if response.status_code != expected_status:
                    notes += f" | Response: {json_data.get('error', json_data.get('message', ''))}"
            except:
                pass
                
            self.log_result(endpoint, method, response.status_code, expected_status, response_time, notes)
            return response
            
        except Exception as e:
            response_time = time.time() - start_time
            self.log_result(endpoint, method, "ERROR", expected_status, response_time, f"Exception: {str(e)}")
            return None

    def test_public_endpoints(self):
        print("\n=== TESTING PUBLIC ENDPOINTS ===")
        
        # Health check
        self.test_endpoint("/health", notes="Health check")
        self.test_endpoint("/api/health", notes="API Health check")
        
        # Public product endpoints
        self.test_endpoint("/api/public/products/featured", notes="Featured products")
        self.test_endpoint("/api/public/categories", notes="Product categories")
        self.test_endpoint("/api/public/products", notes="All products")
        self.test_endpoint("/api/public/products/1", notes="Product details")
        self.test_endpoint("/api/public/products/search", method="POST", 
                          data={"query": "honey"}, notes="Product search")

    def test_auth_endpoints(self):
        print("\n=== TESTING AUTHENTICATION ENDPOINTS ===")
        
        # User registration
        test_email = "sanidhyarana1@gmail.com"
        register_data = {
            "email": test_email,
            "password": "testpass123",
            "first_name": "Test",
            "last_name": "User",
            "phone": "9876543210"
        }
        
        response = self.test_endpoint("/api/user/auth/register", method="POST", 
                                    data=register_data, notes="User registration")
        
        # User login
        login_data = {"email": test_email, "password": "testpass123"}
        response = self.test_endpoint("/api/user/auth/login", method="POST", 
                                    data=login_data, notes="User login")
        
        if response and response.status_code == 200:
            try:
                self.user_token = response.json().get('token')
                print(f"    User token obtained: {self.user_token[:20]}...")
            except:
                pass
        
        # Admin login
        admin_login_data = {"username": "admin1", "password": "admin1234"}
        response = self.test_endpoint("/api/admin/auth/login", method="POST", 
                                    data=admin_login_data, notes="Admin login")
        
        if response and response.status_code == 200:
            try:
                self.admin_token = response.json().get('token')
                print(f"    Admin token obtained: {self.admin_token[:20]}...")
            except:
                pass

    def test_user_endpoints(self):
        print("\n=== TESTING USER ENDPOINTS ===")
        
        if not self.user_token:
            print("    Skipping user tests - no user token")
            return
            
        headers = {"Authorization": f"Bearer {self.user_token}"}
        
        # User profile
        self.test_endpoint("/api/user/profile", headers=headers, notes="User profile")
        
        # User addresses
        self.test_endpoint("/api/user/addresses", headers=headers, notes="User addresses")
        
        # User orders
        self.test_endpoint("/api/user/orders", headers=headers, notes="User orders")
        
        # User cart
        self.test_endpoint("/api/user/cart", headers=headers, notes="User cart")
        
        # Add to cart
        cart_data = {"product_id": 1, "quantity": 1}
        self.test_endpoint("/api/user/cart/add", method="POST", data=cart_data, 
                          headers=headers, notes="Add to cart")
        
        # Wishlist
        self.test_endpoint("/api/user/wishlist", headers=headers, notes="User wishlist")

    def test_admin_endpoints(self):
        print("\n=== TESTING ADMIN ENDPOINTS ===")
        
        if not self.admin_token:
            print("    Skipping admin tests - no admin token")
            return
            
        headers = {"Authorization": f"Bearer {self.admin_token}"}
        
        # Admin dashboard
        self.test_endpoint("/api/admin/dashboard", headers=headers, notes="Admin dashboard")
        
        # Products management
        self.test_endpoint("/api/admin/products", headers=headers, notes="Admin products list")
        self.test_endpoint("/api/admin/products/1", headers=headers, notes="Admin product details")
        
        # Categories management
        self.test_endpoint("/api/admin/categories", headers=headers, notes="Admin categories")
        
        # Orders management
        self.test_endpoint("/api/admin/orders", headers=headers, notes="Admin orders")
        
        # Users management
        self.test_endpoint("/api/admin/users", headers=headers, notes="Admin users list")
        
        # Inventory
        self.test_endpoint("/api/admin/inventory", headers=headers, notes="Admin inventory")

    def test_image_endpoints(self):
        print("\n=== TESTING IMAGE ENDPOINTS ===")
        
        # Test existing images
        test_images = [
            "/static/uploads/products/honey/raw-forest-honey-1.jpg",
            "/static/uploads/products/coffee/arabica-beans-1.jpg",
            "/static/uploads/products/nuts/california-almonds-1.jpg"
        ]
        
        for image_path in test_images:
            self.test_endpoint(image_path, notes=f"Image serving: {image_path.split('/')[-1]}")

    def test_error_endpoints(self):
        print("\n=== TESTING ERROR HANDLING ===")
        
        # Test non-existent endpoints
        self.test_endpoint("/api/nonexistent", expected_status=404, notes="Non-existent endpoint")
        
        # Test unauthorized access
        self.test_endpoint("/api/admin/products", expected_status=401, notes="Unauthorized admin access")
        self.test_endpoint("/api/user/profile", expected_status=401, notes="Unauthorized user access")
        
        # Test invalid methods
        self.test_endpoint("/health", method="POST", expected_status=405, notes="Invalid method")

    def generate_report(self):
        print("\n" + "="*80)
        print("API ENDPOINT TEST REPORT")
        print("="*80)
        
        total_tests = len(self.test_results)
        passed_tests = sum(1 for r in self.test_results if r['success'])
        failed_tests = total_tests - passed_tests
        
        print(f"Total Tests: {total_tests}")
        print(f"Passed: {passed_tests}")
        print(f"Failed: {failed_tests}")
        print(f"Success Rate: {(passed_tests/total_tests)*100:.1f}%")
        
        if failed_tests > 0:
            print("\nFAILED TESTS:")
            for result in self.test_results:
                if not result['success']:
                    print(f"  FAIL {result['method']} {result['endpoint']} - Expected {result['expected']}, Got {result['status']} | {result['notes']}")
        
        print("\nENDPOINT CATEGORIES:")
        categories = {
            'Public': [r for r in self.test_results if '/api/public/' in r['endpoint'] or r['endpoint'] in ['/health', '/api/health']],
            'Auth': [r for r in self.test_results if '/auth/' in r['endpoint']],
            'User': [r for r in self.test_results if '/api/user/' in r['endpoint'] and '/auth/' not in r['endpoint']],
            'Admin': [r for r in self.test_results if '/api/admin/' in r['endpoint'] and '/auth/' not in r['endpoint']],
            'Images': [r for r in self.test_results if '/static/' in r['endpoint']],
            'Error': [r for r in self.test_results if r['expected'] >= 400]
        }
        
        for category, results in categories.items():
            if results:
                passed = sum(1 for r in results if r['success'])
                total = len(results)
                print(f"  {category}: {passed}/{total} passed")

    def run_all_tests(self):
        print("Starting comprehensive API endpoint testing...")
        print(f"Base URL: {self.base_url}")
        print("="*80)
        
        self.test_public_endpoints()
        self.test_auth_endpoints()
        self.test_user_endpoints()
        self.test_admin_endpoints()
        self.test_image_endpoints()
        self.test_error_endpoints()
        
        self.generate_report()

def main():
    tester = APITester()
    tester.run_all_tests()

if __name__ == "__main__":
    main()