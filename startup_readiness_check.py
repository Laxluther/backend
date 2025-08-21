#!/usr/bin/env python3
"""
Comprehensive Startup Readiness Assessment
Analyzes the entire codebase for production readiness
"""

import os
import requests
import json
import subprocess
import re
from datetime import datetime

class StartupReadinessChecker:
    def __init__(self):
        self.base_url = "https://web-production-8bfdb.up.railway.app"
        self.report = {
            'timestamp': datetime.now().isoformat(),
            'overall_score': 0,
            'categories': {},
            'recommendations': [],
            'critical_issues': [],
            'startup_ready': False
        }
        
    def check_api_functionality(self):
        """Test core API functionality"""
        print("CHECK Checking API Functionality...")
        
        tests = {
            'health': {'url': f'{self.base_url}/health', 'critical': True},
            'featured_products': {'url': f'{self.base_url}/api/public/products/featured', 'critical': True},
            'categories': {'url': f'{self.base_url}/api/public/categories', 'critical': True},
            'product_listing': {'url': f'{self.base_url}/api/public/products?limit=5', 'critical': True},
            'product_search': {'url': f'{self.base_url}/api/public/products/search', 'method': 'POST', 'data': {'query': 'honey'}, 'critical': True},
            'admin_login': {'url': f'{self.base_url}/api/admin/auth/login', 'method': 'POST', 'data': {'username': 'admin1', 'password': 'admin1234'}, 'critical': True}
        }
        
        passed = 0
        critical_passed = 0
        critical_total = 0
        
        for test_name, config in tests.items():
            try:
                if config.get('method') == 'POST':
                    response = requests.post(config['url'], json=config.get('data'), timeout=10)
                else:
                    response = requests.get(config['url'], timeout=10)
                
                if response.status_code == 200:
                    passed += 1
                    if config.get('critical'):
                        critical_passed += 1
                    print(f"  OK {test_name}: OK")
                else:
                    print(f"  FAIL {test_name}: Failed ({response.status_code})")
                    
                if config.get('critical'):
                    critical_total += 1
                    
            except Exception as e:
                print(f"  ERROR {test_name}: Error - {e}")
                if config.get('critical'):
                    critical_total += 1
        
        score = (passed / len(tests)) * 100
        critical_score = (critical_passed / critical_total) * 100
        
        self.report['categories']['api_functionality'] = {
            'score': score,
            'critical_score': critical_score,
            'passed': passed,
            'total': len(tests),
            'status': 'GOOD' if score >= 80 else 'NEEDS_WORK'
        }
        
        if critical_score < 100:
            self.report['critical_issues'].append("Critical API endpoints are failing")

    def check_database_health(self):
        """Check database configuration and connectivity"""
        print("DB Checking Database Health...")
        
        score = 0
        issues = []
        
        # Check if database tables exist by testing a product query
        try:
            response = requests.get(f'{self.base_url}/api/public/products/1', timeout=5)
            if response.status_code == 200:
                score += 40
                print("  OK Database connectivity: OK")
            else:
                issues.append("Database connectivity issues")
                print("  FAIL Database connectivity: Failed")
        except:
            issues.append("Cannot connect to database")
            print("  ERROR Database connectivity: Error")
        
        # Check if data exists
        try:
            response = requests.get(f'{self.base_url}/api/public/products/featured', timeout=5)
            if response.status_code == 200:
                data = response.json()
                if data.get('products') and len(data['products']) > 0:
                    score += 30
                    print(f"  OK Sample data: {len(data['products'])} featured products")
                else:
                    issues.append("No product data found")
                    print("  WARN Sample data: No featured products")
        except:
            issues.append("Cannot verify data existence")
        
        # Check categories
        try:
            response = requests.get(f'{self.base_url}/api/public/categories', timeout=5)
            if response.status_code == 200:
                data = response.json()
                if data.get('categories') and len(data['categories']) > 0:
                    score += 30
                    print(f"  OK Categories: {len(data['categories'])} categories")
                else:
                    issues.append("No categories configured")
        except:
            issues.append("Cannot verify categories")
        
        self.report['categories']['database'] = {
            'score': score,
            'status': 'GOOD' if score >= 80 else 'NEEDS_WORK',
            'issues': issues
        }
        
        if score < 60:
            self.report['critical_issues'].append("Database health is poor")

    def check_security_features(self):
        """Check security implementations"""
        print("SEC Checking Security Features...")
        
        score = 0
        features = []
        
        # Test authentication
        try:
            response = requests.get(f'{self.base_url}/api/admin/dashboard', timeout=5)
            if response.status_code == 401:
                score += 25
                features.append("Admin authentication protection")
                print("  OK Admin authentication: Protected")
            else:
                print("  FAIL Admin authentication: Not protected")
        except:
            pass
        
        # Check security headers
        try:
            response = requests.get(f'{self.base_url}/health', timeout=5)
            headers = response.headers
            
            security_headers = {
                'X-Frame-Options': 'Frame protection',
                'X-Content-Type-Options': 'MIME type protection', 
                'X-XSS-Protection': 'XSS protection',
                'Strict-Transport-Security': 'HTTPS enforcement'
            }
            
            for header, description in security_headers.items():
                if header in headers:
                    score += 15
                    features.append(description)
                    print(f"  OK {description}: Present")
                else:
                    print(f"  WARN {description}: Missing")
        except:
            pass
        
        # Check CORS configuration
        try:
            response = requests.options(f'{self.base_url}/api/public/products', timeout=5)
            if 'Access-Control-Allow-Origin' in response.headers:
                score += 10
                features.append("CORS configured")
                print("  OK CORS: Configured")
        except:
            pass
        
        self.report['categories']['security'] = {
            'score': score,
            'status': 'GOOD' if score >= 70 else 'NEEDS_WORK',
            'features': features
        }

    def check_performance_readiness(self):
        """Check performance and caching"""
        print("PERF Checking Performance Readiness...")
        
        score = 0
        features = []
        
        # Test response times
        response_times = []
        endpoints = [
            f'{self.base_url}/health',
            f'{self.base_url}/api/public/products/featured',
            f'{self.base_url}/api/public/categories'
        ]
        
        for url in endpoints:
            try:
                import time
                start = time.time()
                response = requests.get(url, timeout=5)
                end = time.time()
                response_time = (end - start) * 1000
                response_times.append(response_time)
                
                if response_time < 500:  # Under 500ms
                    score += 15
                    print(f"  OK {url.split('/')[-1]}: {response_time:.0f}ms")
                else:
                    print(f"  WARN {url.split('/')[-1]}: {response_time:.0f}ms (slow)")
            except:
                print(f"  ERROR {url.split('/')[-1]}: Timeout")
        
        avg_response_time = sum(response_times) / len(response_times) if response_times else 0
        
        # Check image serving
        try:
            response = requests.head(f'{self.base_url}/static/uploads/products/honey/raw-forest-honey-1.jpg', timeout=5)
            if response.status_code == 200:
                score += 25
                features.append("Image serving functional")
                print("  OK Image serving: Working")
        except:
            print("  ERROR Image serving: Failed")
        
        # Check caching headers
        try:
            response = requests.get(f'{self.base_url}/static/uploads/products/honey/raw-forest-honey-1.jpg', timeout=5)
            if 'Cache-Control' in response.headers or 'ETag' in response.headers:
                score += 10
                features.append("Caching headers present")
                print("  OK Caching: Headers present")
        except:
            pass
        
        self.report['categories']['performance'] = {
            'score': score,
            'status': 'GOOD' if score >= 70 else 'NEEDS_WORK',
            'features': features,
            'avg_response_time': avg_response_time
        }

    def check_business_features(self):
        """Check core business functionality"""
        print("BIZ Checking Business Features...")
        
        score = 0
        features = []
        
        # Product catalog
        try:
            response = requests.get(f'{self.base_url}/api/public/products?limit=1', timeout=5)
            if response.status_code == 200:
                data = response.json()
                if data.get('products') and len(data['products']) > 0:
                    product = data['products'][0]
                    required_fields = ['product_id', 'product_name', 'price', 'category_name', 'primary_image']
                    
                    if all(field in product for field in required_fields):
                        score += 30
                        features.append("Complete product catalog")
                        print("  OK Product catalog: Complete")
                    else:
                        print("  WARN Product catalog: Missing fields")
        except:
            print("  ERROR Product catalog: Failed")
        
        # Search functionality
        try:
            response = requests.post(f'{self.base_url}/api/public/products/search', 
                                   json={'query': 'honey', 'limit': 1}, timeout=5)
            if response.status_code == 200:
                score += 20
                features.append("Product search")
                print("  OK Product search: Working")
        except:
            print("  ERROR Product search: Failed")
        
        # Admin functionality
        try:
            # Test admin login
            response = requests.post(f'{self.base_url}/api/admin/auth/login',
                                   json={'username': 'admin1', 'password': 'admin1234'}, timeout=5)
            if response.status_code == 200:
                score += 25
                features.append("Admin management system")
                print("  OK Admin system: Working")
                
                # Test with token
                token = response.json().get('token')
                if token:
                    dashboard_response = requests.get(
                        f'{self.base_url}/api/admin/dashboard',
                        headers={'Authorization': f'Bearer {token}'}, timeout=5)
                    if dashboard_response.status_code == 200:
                        score += 25
                        features.append("Admin dashboard")
                        print("  OK Admin dashboard: Working")
        except:
            print("  ERROR Admin system: Failed")
        
        self.report['categories']['business'] = {
            'score': score,
            'status': 'GOOD' if score >= 80 else 'NEEDS_WORK',
            'features': features
        }
        
        if score < 60:
            self.report['critical_issues'].append("Core business features incomplete")

    def check_deployment_readiness(self):
        """Check deployment configuration"""
        print("DEPLOY Checking Deployment Readiness...")
        
        score = 0
        features = []
        
        # Check if app is accessible
        try:
            response = requests.get(f'{self.base_url}/health', timeout=5)
            if response.status_code == 200:
                score += 40
                features.append("Application accessible")
                print("  OK Accessibility: App is live")
        except:
            print("  ERROR Accessibility: App not reachable")
        
        # Check HTTPS
        if self.base_url.startswith('https://'):
            score += 30
            features.append("HTTPS enabled")
            print("  OK HTTPS: Enabled")
        else:
            print("  WARN HTTPS: Not enabled")
        
        # Check error handling
        try:
            response = requests.get(f'{self.base_url}/api/nonexistent-endpoint', timeout=5)
            if response.status_code == 404:
                score += 15
                features.append("Proper error handling")
                print("  OK Error handling: Working")
        except:
            pass
        
        # Check domain and branding
        if 'railway.app' in self.base_url:
            print("  WARN Domain: Using Railway subdomain (consider custom domain)")
            self.report['recommendations'].append("Set up custom domain for professional appearance")
        else:
            score += 15
            features.append("Custom domain")
        
        self.report['categories']['deployment'] = {
            'score': score,
            'status': 'GOOD' if score >= 80 else 'NEEDS_WORK',
            'features': features
        }

    def calculate_overall_score(self):
        """Calculate overall startup readiness score"""
        category_weights = {
            'api_functionality': 25,
            'database': 20,
            'business': 25,
            'security': 15,
            'performance': 10,
            'deployment': 5
        }
        
        weighted_score = 0
        total_weight = 0
        
        for category, weight in category_weights.items():
            if category in self.report['categories']:
                weighted_score += self.report['categories'][category]['score'] * (weight / 100)
                total_weight += weight
        
        self.report['overall_score'] = (weighted_score / total_weight * 100) if total_weight > 0 else 0
        
        # Determine startup readiness
        if self.report['overall_score'] >= 85 and len(self.report['critical_issues']) == 0:
            self.report['startup_ready'] = True
        
        # Add general recommendations
        if self.report['overall_score'] < 90:
            self.report['recommendations'].extend([
                "Consider adding user registration and authentication flow",
                "Implement order management system",
                "Add payment gateway integration",
                "Set up monitoring and logging",
                "Create backup and recovery procedures"
            ])

    def generate_report(self):
        """Generate comprehensive report"""
        self.check_api_functionality()
        self.check_database_health()
        self.check_security_features()
        self.check_performance_readiness()
        self.check_business_features()
        self.check_deployment_readiness()
        self.calculate_overall_score()
        
        print("\n" + "="*80)
        print("DEPLOY STARTUP READINESS ASSESSMENT")
        print("="*80)
        
        print(f"Overall Score: {self.report['overall_score']:.1f}/100")
        print(f"Startup Ready: {'YES' if self.report['startup_ready'] else 'ALMOST'}")
        
        print("\nCategory Breakdown:")
        for category, data in self.report['categories'].items():
            status_emoji = "OK" if data['status'] == 'GOOD' else "WARN"
            print(f"  {status_emoji} {category.replace('_', ' ').title()}: {data['score']:.1f}/100")
        
        if self.report['critical_issues']:
            print("\nCRITICAL Issues:")
            for issue in self.report['critical_issues']:
                print(f"  • {issue}")
        
        if self.report['recommendations']:
            print("\nRecommendations:")
            for rec in self.report['recommendations'][:5]:  # Top 5
                print(f"  • {rec}")
        
        print("\nSTARTUP READINESS VERDICT:")
        if self.report['startup_ready']:
            print("SUCCESS: Your e-commerce platform is READY for startup launch!")
            print("   • Core functionality is working")
            print("   • No critical blockers found")
            print("   • Production deployment successful")
        else:
            print("ALMOST: Your platform is ALMOST ready - few improvements needed:")
            if self.report['critical_issues']:
                print("   • Address critical issues first")
            print("   • Consider implementing recommended features")
            print("   • Test thoroughly before launch")
        
        return self.report

def main():
    checker = StartupReadinessChecker()
    report = checker.generate_report()
    
    # Save detailed report
    with open('startup_readiness_report.json', 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"\nDetailed report saved to: startup_readiness_report.json")

if __name__ == "__main__":
    main()