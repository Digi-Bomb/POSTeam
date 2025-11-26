import sys
import os

# Add the src directory to the path
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'src'))

from pos_calculator import POSCalculator

def run_tests():
    """Test the POS calculator with sample data"""
    calculator = POSCalculator()
    
    print("=== POS Calculator Test ===\n")
    
    # Test 1: Basic order calculation
    print("1. Basic Order Calculation:")
    sample_order = {
        "items": [
            {"id": "T2", "type": "ticket", "quantity": 2},  # Premium Ticket x2 = $20
            {"id": "TB1", "type": "bundle", "quantity": 1}   # Small Token Bundle = $8
        ]
    }
    
    result = calculator.process_order(sample_order)
    print(f"   Items: 2x Premium Ticket + 1x Small Token Bundle")
    print(f"   Expected: $28.00")
    print(f"   Calculated: ${result['order_summary']['total']}")
    print(f"   Status: {'PASS' if result['order_summary']['total'] == 28.00 else 'FAIL'}")
    print()
    
    # Test 2: Order with discount
    print("2. Order with 10% Discount:")
    sample_order_with_discount = {
        "items": [
            {"id": "T3", "type": "ticket", "quantity": 1},  # VIP Ticket = $20
            {"id": "TB3", "type": "bundle", "quantity": 1}   # Large Token Bundle = $25
        ],
        "discount_percentage": 10  # 10% discount
    }
    
    result = calculator.process_order(sample_order_with_discount)
    print(f"   Items: 1x VIP Ticket + 1x Large Token Bundle")
    print(f"   Subtotal: ${result['order_summary']['subtotal']}")
    print(f"   Discount: {result['order_summary']['discount_percentage']}%")
    print(f"   Total: ${result['order_summary']['total']}")
    print(f"   Status: {'PASS' if result['order_summary']['total'] == 40.50 else 'FAIL'}")
    print()
    
    # Test 3: Payment validation
    print("3. Payment Validation:")
    print("   Testing sufficient balance:")
    validation = calculator.validate_payment(50.00, 75.00)
    print(f"   Need: $50.00, Have: $75.00")
    print(f"   Result: {validation['status']}")
    print(f"   Status: {'PASS' if validation['status'] == 'success' else 'FAIL'}")
    
    print("   Testing insufficient balance:")
    validation = calculator.validate_payment(50.00, 30.00)
    print(f"   Need: $50.00, Have: $30.00")
    print(f"   Result: {validation['status']}")
    print(f"   Status: {'PASS' if validation['status'] == 'failure' else 'FAIL'}")
    print()
    
    # Test 4: Individual calculations
    print("4. Individual Calculations:")
    items = [{"id": "T1", "type": "ticket", "quantity": 5}]  # 5 Basic Tickets
    total = calculator.calculate_order_total(items)
    print(f"   5 Basic Tickets: ${total}")
    print(f"   Status: {'PASS' if total == 25.00 else 'FAIL'}")
    
    discounted = calculator.apply_discount(total, 20)  # 20% discount
    print(f"   After 20% discount: ${discounted}")
    print(f"   Status: {'PASS' if discounted == 20.00 else 'FAIL'}")
    
    print("\n=== Test Complete ===")

if __name__ == "__main__":
    run_tests()