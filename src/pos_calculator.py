import json
import os
from typing import List, Dict


class POSCalculator:
    def __init__(self, config_path: str = "data/Pos_backup.json"):
        """Load product configuration"""
        self.config = self._load_config(config_path)

        # Convert arrays into lookup dictionaries
        self.tickets = {t["id"]: t for t in self.config.get("tickets", [])}
        self.token_bundles = {b["id"]: b for b in self.config.get("token_bundles", [])}

    def _load_config(self, config_path: str) -> Dict:
        """Loads Pos_backup.json safely from any OS"""

        # Absolute path resolution
        base_dir = os.path.dirname(os.path.abspath(__file__))
        resolved_path = os.path.join(base_dir, "..", config_path)

        if not os.path.exists(resolved_path):
            print(f" JSON NOT FOUND at: {resolved_path}")
            return {}

        try:
            with open(resolved_path, "r") as f:
                print(f"✔ Loaded config: {resolved_path}")
                return json.load(f)
        except Exception as e:
            print(" ERROR loading JSON:", e)
            return {}

    def calculate_order_total(self, items: List[Dict]) -> float:
        """Calculates full price for all items in cart"""
        total = 0.0

        for item in items:
            item_id = item.get("id")
            qty = item.get("quantity", 1)
            item_type = item.get("type")

            if item_type == "ticket" and item_id in self.tickets:
                total += self.tickets[item_id]["price"] * qty
            elif item_type == "bundle" and item_id in self.token_bundles:
                total += self.token_bundles[item_id]["price"] * qty

        return round(total, 2)

    def apply_discount(self, total: float, discount_percentage: float = 0) -> float:
        """Applies percentage discount"""
        discount_amount = total * (discount_percentage / 100)
        return round(total - discount_amount, 2)

    def validate_payment(self, total: float, balance: float) -> Dict:
        """Checks if customer has enough money"""
        if balance >= total:
            return {
                "status": "success",
                "remaining_balance": round(balance - total, 2)
            }
        return {
            "status": "failure",
            "shortfall": round(total - balance, 2)
        }

    # -------------------------------
    # FIXED MAIN ENDPOINT PROCESSOR
    # -------------------------------
    def process_order(self, data: Dict, customer_balance=None) -> Dict:
        """Core calculation logic"""

        items = data.get("items", [])
        discount = data.get("discount_percentage", 0)

        subtotal = self.calculate_order_total(items)
        total_after_discount = self.apply_discount(subtotal, discount)

        response = {
            "status": "success",
            "subtotal": subtotal,
            "discount_percentage": discount,
            "discount_amount": round(subtotal - total_after_discount, 2),
            "total_price": total_after_discount,
        }

        if customer_balance is not None:
            response["payment_validation"] = self.validate_payment(
                total_after_discount, customer_balance
            )

        return response

    # -------------------------------
    # FIXED GET PRODUCTS
    # -------------------------------
    def get_products(self):
        """Returns list of tickets and bundles with name + price"""
        return {
            "tickets": list(self.tickets.values()),
            "token_bundles": list(self.token_bundles.values()),
        }
