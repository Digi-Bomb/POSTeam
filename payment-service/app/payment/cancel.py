from flask import request, jsonify
from . import pay
from .data_store import ORDERS, PAYMENTS  

@pay.post("/cancel")
def cancel():
    # Get JSON data from the request
    data = request.get_json(force=True)
    order_id = data.get("orderId")

    # Check order ID
    if not order_id:
        return jsonify({"status": "error", "message": "orderId missing"}), 400

    # Find the order in memory
    order = ORDERS.get(order_id)
    if not order:
        return jsonify({"status": "error", "message": "order not found"}), 404

    # Mark the order as canceled
    order["status"] = "CANCELED"
    # Also cancel related payment if it exists
    for auth_id, payment in PAYMENTS.items():
        if payment.get("orderId") == order_id:
            payment["status"] = "CANCELED"

    # Return the response
    return jsonify({"status": "CANCELED", "orderId": order_id}), 200