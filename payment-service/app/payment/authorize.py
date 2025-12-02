from flask import request, jsonify
from . import pay
from .data_store import ORDERS, PAYMENTS

@pay.post("/authorize")
def authorize():
    # Get JSON data from the request
    data = request.get_json(force=True)
    order_id = data.get("orderId")
    total = data.get("total", 0)

    # Check if order ID exists
    if not order_id:
        return jsonify({"status": "error", "message": "orderId missing"}), 400

    # Save order details in memory
    ORDERS[order_id] = {
        "status": "AUTHORIZED",
        "total": total,
        "items": data.get("items", [])
    }

    # Create unique authorization ID (used to uniquely track each payment)
    import uuid
    authorization_id = "AUTH-" + str(uuid.uuid4())

    # Create unique authorization ID
    PAYMENTS[authorization_id] = {
        "orderId": order_id,
        "status": "AUTHORIZED"
    }

    # Return success response
    return jsonify({
        "status": "AUTHORIZED",
        "authorizationId": authorization_id,
        "orderId": order_id,
        "expiresInSec": 600
    }), 200