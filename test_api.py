import requests
import json
import time

def test_api():
    """Test the running API server"""
    base_url = "http://localhost:12500"
    
    print("=== Testing POS Calculator API ===\n")
    
    # Test health endpoint
    print("1. Testing /health endpoint:")
    try:
        response = requests.get(f"{base_url}/health")
        print(f"   Status: {response.status_code}")
        print(f"   Response: {response.json()}")
        print()
    except Exception as e:
        print(f"   ❌ Error: {e}")
        print("   Make sure the server is running on port 12500!")
        print("   Run: python run.py")
        return
    
    # Test get products
    print("2. Testing /get/products endpoint:")
    try:
        response = requests.get(f"{base_url}/get/products")
        print(f"   Status: {response.status_code}")
        data = response.json()
        print(f"   Found {len(data['tickets'])} tickets and {len(data['token_bundles'])} token bundles")
        print()
    except Exception as e:
        print(f"   Error: {e}")
    
    # Test order calculation
    print("3. Testing /calculate/order endpoint:")
    order_data = {
        "items": [
            {"id": "T1", "type": "ticket", "quantity": 3},
            {"id": "TB2", "type": "bundle", "quantity": 1}
        ],
        "discount_percentage": 10
    }
    
    try:
        response = requests.post(f"{base_url}/calculate/order", 
                               json=order_data)
        print(f"   Status: {response.status_code}")
        result = response.json()
        print(f"   Items: 3x Basic Ticket + 1x Medium Token Bundle")
        print(f"   Subtotal: ${result['order_summary']['subtotal']}")
        print(f"   Discount: {result['order_summary']['discount_percentage']}%")
        print(f"   Total: ${result['order_summary']['total']}")
        print(f"   Status: {result['status']}")
        print()
    except Exception as e:
        print(f"   Error: {e}")
    
    # Test payment validation
    print("4. Testing /validate/payment endpoint:")
    payment_data = {
        "total_amount": 40.00,
        "customer_balance": 35.00
    }
    
    try:
        response = requests.post(f"{base_url}/validate/payment", 
                               json=payment_data)
        print(f"   Status: {response.status_code}")
        result = response.json()
        print(f"   Need: $40.00, Have: $35.00")
        print(f"   Result: {result['status']}")
        print(f"   Message: {result['message']}")
        print()
    except Exception as e:
        print(f"   Error: {e}")

    print("🎉 API Testing Complete!")

if __name__ == "__main__":
    test_api()