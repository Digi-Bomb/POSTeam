from flask import Flask, request, jsonify
import sys
import os
from datetime import datetime

# Add src to path so we can import our modules
sys.path.append(os.path.dirname(__file__))

from pos_calculator import POSCalculator

# Initialize Flask app and calculator
app = Flask(__name__)
calculator = POSCalculator()

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy", 
        "service": "POS Calculator",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0"
    })

@app.route('/calculate/order', methods=['POST'])
def calculate_order():
    """
    Calculate order total
    Expected JSON:
    {
        "items": [
            {"id": "T1", "type": "ticket", "quantity": 2},
            {"id": "TB1", "type": "bundle", "quantity": 1}
        ],
        "discount_percentage": 10  # optional
    }
    """
    try:
        data = request.get_json()
        
        if not data or 'items' not in data:
            return jsonify({"status": "error", "message": "Missing items in request"}), 400
        
        result = calculator.process_order(data)
        return jsonify(result)
        
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400

@app.route('/validate/payment', methods=['POST'])
def validate_payment():
    """
    Validate customer payment
    Expected JSON:
    {
        "total_amount": 50.00,
        "customer_balance": 75.00
    }
    """
    try:
        data = request.get_json()
        total_amount = data.get("total_amount")
        customer_balance = data.get("customer_balance")
        
        if total_amount is None or customer_balance is None:
            return jsonify({"status": "error", "message": "Missing required fields"}), 400
        
        result = calculator.validate_payment(total_amount, customer_balance)
        return jsonify(result)
        
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400

@app.route('/calculate/discount', methods=['POST'])
def calculate_discount():
    """
    Calculate discounted price
    Expected JSON:
    {
        "original_price": 100.00,
        "discount_percentage": 15
    }
    """
    try:
        data = request.get_json()
        original_price = data.get("original_price")
        discount_percentage = data.get("discount_percentage", 0)
        
        if original_price is None:
            return jsonify({"status": "error", "message": "Missing original_price"}), 400
        
        discounted_price = calculator.apply_discount(original_price, discount_percentage)
        
        return jsonify({
            "status": "success",
            "original_price": original_price,
            "discount_percentage": discount_percentage,
            "discounted_price": discounted_price,
            "amount_saved": round(original_price - discounted_price, 2)
        })
        
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400

@app.route('/get/products', methods=['GET'])
def get_products():
    """Get available tickets and token bundles"""
    return jsonify({
        "tickets": calculator.tickets,
        "token_bundles": calculator.token_bundles
    })

if __name__ == '__main__':
    print("🚀 Starting POS Calculator Service on port 12500...")
    print("📊 Available endpoints:")
    print("  GET  /health")
    print("  POST /calculate/order")
    print("  POST /validate/payment")
    print("  POST /calculate/discount")
    print("  GET  /get/products")
    print("🔗 Server: http://localhost:12500")
    app.run(host='0.0.0.0', port=12500, debug=True)