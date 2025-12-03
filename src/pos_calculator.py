import json
import os
from typing import List, Dict, Optional

class POSCalculator:
    def __init__(self, config_path: str = "data/Pos_backup.json"):
        """Initialize calculator with configuration data"""
        self.config = self._load_config(config_path)
        self.tickets = {ticket["id"]: ticket for ticket in self.config.get("tickets", [])}
        self.token_bundles = {bundle["id"]: bundle for bundle in self.config.get("token_bundles", [])}
    
    def _load_config(self, config_path: str) -> Dict:
        """Load configuration from JSON file"""
        try:
            # Adjust path to be relative to src directory
            if not os.path.exists(config_path):
                config_path = os.path.join("..", config_path)
            
            with open(config_path, 'r') as file:
                return json.load(file)
        except FileNotFoundError:
            print(f"Config file {config_path} not found. Using empty configuration.")
            return {}
        except Exception as e:
            print(f"Error loading config: {e}")
            return {}
    
    def calculate_order_total(self, items: List[Dict]) -> float:
        """
        Calculate total price for a list of items
        Args:
            items: List of items with id, type, and quantity
        Returns:
            Total price as float
        """
        total = 0.0
        
        for item in items:
            item_id = item.get("id")
            quantity = item.get("quantity", 1)
            item_type = item.get("type")
            
            if item_type == "ticket" and item_id in self.tickets:
                total += self.tickets[item_id]["price"] * quantity
            elif item_type == "bundle" and item_id in self.token_bundles:
                total += self.token_bundles[item_id]["price"] * quantity
        
        return round(total, 2)
    
    def apply_discount(self, total: float, discount_percentage: float = 0) -> float:
        """
        Apply percentage discount to total
        Args:
            total: Original total
            discount_percentage: Discount percentage (0-100)
        Returns:
            Discounted total
        """
        if discount_percentage < 0 or discount_percentage > 100:
            raise ValueError("Discount percentage must be between 0 and 100")
        
        discount_amount = total * (discount_percentage / 100)
        return round(total - discount_amount, 2)
    
    def validate_payment(self, total_amount: float, customer_balance: float) -> Dict:
        """
        Validate if customer has sufficient balance
        Args:
            total_amount: Order total
            customer_balance: Customer's available balance
        Returns:
            Validation result with status and message
        """
        if customer_balance >= total_amount:
            return {
                "status": "success",
                "message": "Sufficient balance",
                "remaining_balance": round(customer_balance - total_amount, 2)
            }
        else:
            return {
                "status": "failure",
                "message": f"Insufficient balance. Need ${total_amount}, have ${customer_balance}",
                "shortfall": round(total_amount - customer_balance, 2)
            }
    
    def process_order(self, order_data: Dict, customer_balance: float = None) -> Dict:
        """
        Complete order processing with calculation and validation
        Args:
            order_data: Order information including items
            customer_balance: Optional customer balance for validation
        Returns:
            Complete order processing result
        """
        try:
            # Calculate total
            items = order_data.get("items", [])
            subtotal = self.calculate_order_total(items)
            
            # Apply any discounts
            discount = order_data.get("discount_percentage", 0)
            total = self.apply_discount(subtotal, discount)
            
            # Validate payment if balance provided
            payment_validation = None
            if customer_balance is not None:
                payment_validation = self.validate_payment(total, customer_balance)
            
            return {
                "status": "success",
                "order_summary": {
                    "subtotal": subtotal,
                    "discount_percentage": discount,
                    "discount_amount": round(subtotal - total, 2),
                    "total": total,
                    "items_count": len(items)
                },
                "payment_validation": payment_validation
            }
            
        except Exception as e:
            return {
                "status": "error",
                "message": str(e)
            }