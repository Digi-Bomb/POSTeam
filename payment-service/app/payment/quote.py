from flask import request, jsonify
from . import pay

#TEST
@pay.post("/quote")
def quote():
    # Return a example response
    return jsonify({
        "subtotal": 30.00,
        "discount": 0.00,
        "tax": 4.99,
        "total": 34.99,
        "currency": "USD"
    })