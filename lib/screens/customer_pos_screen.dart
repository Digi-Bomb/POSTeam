import 'package:flutter/material.dart';
import '../api_service.dart';
import 'payment_screen.dart';
import '../main.dart';

class CustomerPOSScreen extends StatefulWidget {
  const CustomerPOSScreen({super.key});

  @override
  State<CustomerPOSScreen> createState() => _CustomerPOSScreenState();
}

class _CustomerPOSScreenState extends State<CustomerPOSScreen> {
  // user input
  int quantity = 1;
  String? ticketType;
  String? tokenBundle;
  final TextEditingController _nameController = TextEditingController();

  // backend data
  List<String> backendTickets = [];
  List<String> backendBundles = [];

  // cart
  List<Map<String, dynamic>> cartItems = [];
  double totalPriceAPI = 0.0;
  double lastUnitPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // ---------------------------
  // BACKEND: FETCH PRODUCT LIST
  // ---------------------------
  void fetchProducts() async {
    final result = await ApiService.getProducts();

    if (result != null) {
      setState(() {
      backendTickets =
    (result["tickets"] as Map<String, dynamic>).keys.cast<String>().toList();

backendBundles =
    (result["token_bundles"] as Map<String, dynamic>).keys.cast<String>().toList();

      });
    }
  }

  // ---------------------------
  // BACKEND: ADD ITEM TO CART
  // ---------------------------
  void addToCart() async {
    if (ticketType == null && tokenBundle == null) return;

    final selectedName = ticketType ?? tokenBundle;

    final result = await ApiService.calculateOrder([
      {
        "id": selectedName,
        "type": ticketType != null ? "ticket" : "bundle",
        "quantity": quantity,
      }
    ]);

    if (result == null) return;

    final itemTotal = result["total_price"] ?? 0.0;
    final unitPrice = itemTotal / quantity;

    setState(() {
      cartItems.add({
        'name': selectedName,
        'quantity': quantity,
        'price': itemTotal,
      });

      lastUnitPrice = unitPrice;
      totalPriceAPI += itemTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A082F),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Customer POS",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const POSApp()),
                        );
                      },
                      child: const Text("Back to Login",
                          style:
                              TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      radius: 25,
                      child: Icon(Icons.pets, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            Expanded(
              child: Row(
                children: [
                  // LEFT PANEL FORM
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: _boxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Order Details",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),

                          _buildTextField(
                              "Customer Name", "Enter your name"),

                          const SizedBox(height: 15),

                          _buildDropdown(
                            label: "Ticket Type",
                            value: ticketType,
                            items: backendTickets,
                            onChanged: (val) =>
                                setState(() => ticketType = val),
                          ),

                          const SizedBox(height: 15),

                          _buildDropdown(
                            label: "Token Bundle",
                            value: tokenBundle,
                            items: backendBundles,
                            onChanged: (val) =>
                                setState(() => tokenBundle = val),
                          ),

                          const SizedBox(height: 15),

                          const Text("Quantity",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              _qtyButton("-", () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              }),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: _borderBox(),
                                child: Text("$quantity",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                              _qtyButton("+", () {
                                setState(() => quantity++);
                              }),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // ADD TO CART BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: addToCart,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purpleAccent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16)),
                              child: const Text(
                                "Add to Cart",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  // RIGHT PANEL CART
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            decoration: _boxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Cart Preview",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 15),

                                Expanded(
                                  child: cartItems.isEmpty
                                      ? const Center(
                                          child: Text("Cart Empty",
                                              style: TextStyle(
                                                  color: Colors.grey)))
                                      : ListView.builder(
                                          itemCount: cartItems.length,
                                          itemBuilder: (context, i) {
                                            final item = cartItems[i];
                                            return ListTile(
                                              title: Text("${item['name']}",
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                              subtitle: Text(
                                                  "Qty: ${item['quantity']} | \$${item['price'].toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                      color:
                                                          Colors.white70)),
                                              trailing: IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  setState(() {
                                                    totalPriceAPI -=
                                                        item['price'];
                                                    cartItems.removeAt(i);
                                                  });
                                                },
                                              ),
                                            );
                                          }),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          decoration: _boxDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Items: ${cartItems.length}",
                                  style: const TextStyle(
                                      color: Colors.white)),
                              Text(
                                "Total: \$${totalPriceAPI.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.payment),
                            label: const Text("Proceed to Payment"),
                            onPressed: () {
                              if (cartItems.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Cart is empty")),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaymentScreen(
                                    totalAmount: totalPriceAPI,
                                    customerName: _nameController.text,
                                    cartItems: cartItems,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              foregroundColor: Colors.black,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI HELPERS
  // ---------------------------------------------------------------------------

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: const Color(0xFF2C1155),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.purple.shade200),
    );
  }

  BoxDecoration _borderBox() {
    return BoxDecoration(
      border: Border.all(color: Colors.purple.shade300),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _qtyButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: _borderBox(),
        child: Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF140634),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) =>
                  DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFF1A082F),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF140634),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
