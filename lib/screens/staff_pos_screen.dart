import 'package:flutter/material.dart';

class StaffPOSScreen extends StatefulWidget {
  const StaffPOSScreen({super.key});

  @override
  State<StaffPOSScreen> createState() => _StaffPOSScreenState();
}

class _StaffPOSScreenState extends State<StaffPOSScreen> {
  final List<Map<String, dynamic>> transactions = [
    {
      "customerName": "Alice",
      "order": "Basic Ticket x2",
      "payment": "Pending",
      "total": 20.00,
      "datetime": "2025-01-10 11:45 AM"
    },
    {
      "customerName": "Bob",
      "order": "VIP Ticket x1 + Tokens",
      "payment": "Completed",
      "total": 45.00,
      "datetime": "2025-01-10 10:10 AM"
    },
    {
      "customerName": "John",
      "order": "Family Pass x1",
      "payment": "Completed",
      "total": 60.00,
      "datetime": "2025-01-09 04:55 PM"
    }
  ];

  Map<String, dynamic>? selectedOrder;
  String? paymentMethod;
  TextEditingController discountController = TextEditingController();
  bool showSidePanel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A082F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C1155),
        title: const Text("Staff POS System"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildOrderHistory(),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: showSidePanel ? 380 : 0,
            child: showSidePanel ? _buildSidePanel() : null,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHistory() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color(0xFF2C1155),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.purple.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order History",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final txn = transactions[index];
                  return Card(
                    color: const Color(0xFF3A1C6E),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        txn["order"],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${txn["customerName"]} | ${txn["datetime"]}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: txn["payment"] == "Completed"
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          txn["payment"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () => _openRightPanel(txn),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openRightPanel(Map<String, dynamic> txn) {
    setState(() {
      selectedOrder = txn;
      showSidePanel = true;
      paymentMethod = null;
      discountController.clear();
    });
  }

  Widget _buildSidePanel() {
    final isPending = selectedOrder?["payment"] == "Pending";
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1155),
        border: Border(left: BorderSide(color: Colors.purpleAccent)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isPending ? "Process Payment" : "Ticket Information",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => setState(() => showSidePanel = false),
              )
            ],
          ),

          const SizedBox(height: 10),
          _buildOrderInfo(),

          if (isPending) _buildPaymentSection() else _buildTicketView(),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer: ${selectedOrder!["customerName"]}",
            style: const TextStyle(color: Colors.white)),
        Text("Order: ${selectedOrder!["order"]}",
            style: const TextStyle(color: Colors.white)),
        Text("Total: \$${selectedOrder!["total"].toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white)),
        Text("Date: ${selectedOrder!["datetime"]}",
            style: const TextStyle(color: Colors.white)),
        const Divider(color: Colors.purpleAccent),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Payment Method",
              style: TextStyle(color: Colors.white, fontSize: 14)),

          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: paymentMethod,
            dropdownColor: const Color(0xFF1A082F),
            items: const [
              DropdownMenuItem(value: "Cash", child: Text("Cash")),
              DropdownMenuItem(value: "Card", child: Text("Card")),
              DropdownMenuItem(
                  value: "Wallet", child: Text("Digital Wallet")),
            ],
            onChanged: (val) => setState(() => paymentMethod = val),
            decoration: _inputDecoration(),
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 15),
          const Text("Discount (%)",
              style: TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            controller: discountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration(),
          ),

          const Spacer(),
          ElevatedButton(
            onPressed: _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text("Complete Payment",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
      ),
    );
  }

  void _processPayment() {
    if (paymentMethod == null) return;

    setState(() {
      selectedOrder!["payment"] = "Completed";
      showSidePanel = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment completed successfully")),
    );
  }

  Widget _buildTicketView() {
    return Expanded(
      child: Center(
        child: Text(
          "Display Ticket Here",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF140634),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.purple.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.purpleAccent, width: 1.5),
      ),
    );
  }
}
