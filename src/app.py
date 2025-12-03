from flask import Flask, request, jsonify
from datetime import datetime
import json, os

from pos_calculator import POSCalculator

app = Flask(__name__)
calculator = POSCalculator()

TRANSACTION_LOG = os.path.join("data", "transactions.json")


# Utility — write to JSON log
def append_transaction(entry):
    try:
        if not os.path.exists(TRANSACTION_LOG):
            with open(TRANSACTION_LOG, "w") as f:
                json.dump([], f)

        with open(TRANSACTION_LOG, "r") as f:
            existing = json.load(f)

        existing.append(entry)

        with open(TRANSACTION_LOG, "w") as f:
            json.dump(existing, f, indent=4)

        return True

    except Exception as e:
        print("Error writing log:", e)
        return False


@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "service": "POS", "time": datetime.now().isoformat()})


@app.route('/get/products', methods=['GET'])
def get_products():
    return jsonify({
        "tickets": calculator.tickets,
        "token_bundles": calculator.token_bundles
    })


@app.route('/calculate/order', methods=['POST'])
def calculate_order():
    data = request.get_json()
    items = data.get("items", [])
    subtotal = calculator.calculate_order_total(items)

    return jsonify({
        "total_price": subtotal,
        "status": "success"
    })


@app.route('/validate/payment', methods=['POST'])
def validate_payment():
    data = request.get_json()
    total = data.get("total_amount")
    balance = data.get("customer_balance")

    result = calculator.validate_payment(total, balance)
    return jsonify(result)


# 🚨 NEW: LOG TRANSACTION
@app.route('/log/transaction', methods=['POST'])
def log_transaction():
    data = request.get_json()

    entry = {
        "customerName": data.get("customerName"),
        "items": data.get("items"),     # list of {name, quantity, price}
        "totalAmount": data.get("totalAmount"),
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M"),
        "paymentMethod": data.get("paymentMethod", "Unknown")
    }

    success = append_transaction(entry)

    if success:
        return jsonify({"status": "success", "message": "Logged"})
    else:
        return jsonify({"status": "error", "message": "Failed to log"}), 500


if __name__ == "__main__":
    print("🔥 POS Backend Running on http://127.0.0.1:12500")
    app.run(host="0.0.0.0", port=12500, debug=True)
