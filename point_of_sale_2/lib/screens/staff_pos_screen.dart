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
      "total": 10.00
    },
    {
      "customerName": "Bob",
      "order": "VIP Ticket x1 + Large Token Bundle",
      "payment": "Completed",
      "total": 45.00
    },
  ];

  String? selectedStatus;
  bool showSuccess = false;

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
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Panel: Pending Orders
            Expanded(
              flex: 2,
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
                      "Pending Orders",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
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
                                "Customer: ${txn["customerName"]} | Total: \$${txn["total"].toStringAsFixed(2)}",
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
                              onTap: () => _showTransactionDetails(txn),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 30),

            // Right Panel: Payment and Ticket Issuance
            Expanded(
              flex: 1,
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
                      "Payment Processing",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Select Payment Method:",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      dropdownColor: const Color(0xFF1A082F),
                      items: const [
                        DropdownMenuItem(
                            value: "Cash", child: Text("Cash")),
                        DropdownMenuItem(
                            value: "Card", child: Text("Card")),
                        DropdownMenuItem(
                            value: "Wallet", child: Text("Digital Wallet")),
                      ],
                      onChanged: (value) =>
                          setState(() => selectedStatus = value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF140634),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.purple.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.purpleAccent, width: 1.5),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          showSuccess = true;
                        });
                      },
                      icon: const Icon(Icons.payment, color: Colors.white),
                      label: const Text(
                        "Process Payment",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (showSuccess)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.greenAccent, width: 1),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.greenAccent),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Payment processed successfully! Ticket issued.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> txn) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C1155),
        title: const Text(
          "Transaction Details",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer: ${txn["customerName"]}",
                style: const TextStyle(color: Colors.white)),
            Text("Order: ${txn["order"]}",
                style: const TextStyle(color: Colors.white)),
            Text("Total: \$${txn["total"].toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white)),
            Text("Payment: ${txn["payment"]}",
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.purpleAccent)),
          ),
        ],
      ),
    );
  }
}
