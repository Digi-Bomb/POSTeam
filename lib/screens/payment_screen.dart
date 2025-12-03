import 'package:flutter/material.dart';
import '../api_service.dart';
import 'ticket_screen.dart';
import 'customer_pos_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String customerName;
  final List<Map<String, dynamic>> cartItems;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.customerName,
    required this.cartItems,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedPayment;

  // ----------------------------------------------------------
  // 🔥 COMPLETE PAYMENT: Log in backend + go to ticket screen
  // ----------------------------------------------------------
  void completePayment() async {
    final success = await ApiService.logTransaction({
      "customerName": widget.customerName,
      "totalAmount": widget.totalAmount,
      "paymentMethod": selectedPayment,
      "items": widget.cartItems,
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to log transaction")),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TicketScreen(
          customerName: widget.customerName,
          totalAmount: widget.totalAmount,
          cartItems: widget.cartItems,
          paymentMethod: selectedPayment ?? "Unknown",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A082F),
      body: Center(
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2C1155),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.purpleAccent, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          // ----------------------------------------------------------
          //                    PAYMENT UI
          // ----------------------------------------------------------
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Payment Summary",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                "Customer: ${widget.customerName}",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 20),

              // ------------------ ORDER SUMMARY BOX ------------------
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A082F),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purpleAccent.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    ...widget.cartItems.map((item) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            "x${item['quantity']}  \$${item['price'].toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      );
                    }),
                    const Divider(color: Colors.purpleAccent),
                    Text(
                      "Total: \$${widget.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Payment Method:",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),

              // ------------------ PAYMENT OPTIONS ------------------
              _paymentRadio("Cash", Icons.money),
              _paymentRadio("Card", Icons.credit_card),
              _paymentRadio("Digital Wallet", Icons.phone_android),

              const SizedBox(height: 12),

              // ------------------ CONFIRM PAYMENT ------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedPayment == null ? null : completePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Confirm Payment",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // RADIO TILE FOR PAYMENT OPTIONS
  // ----------------------------------------------------------
  Widget _paymentRadio(String label, IconData icon) {
    return RadioListTile<String>(
      value: label,
      groupValue: selectedPayment,
      onChanged: (value) => setState(() => selectedPayment = value),
      activeColor: Colors.purpleAccent,
      title: Text(label, style: const TextStyle(color: Colors.white)),
      secondary: Icon(icon, color: Colors.purpleAccent),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
