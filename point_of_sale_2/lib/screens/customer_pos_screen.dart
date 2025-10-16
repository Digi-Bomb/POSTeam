import 'package:flutter/material.dart';

class CustomerPOSScreen extends StatefulWidget {
  const CustomerPOSScreen({super.key});

  @override
  State<CustomerPOSScreen> createState() => _CustomerPOSScreenState();
}

class _CustomerPOSScreenState extends State<CustomerPOSScreen> {
  int quantity = 1;
  String? ticketType;
  String? tokenBundle;
  final TextEditingController _nameController = TextEditingController();

  // Cart data stored here
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A082F), // dark purple background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Top bar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Customer POS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Navigate back to login page later
                      },
                      child: const Text(
                        "Back to Login",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      radius: 25,
                      child: const Icon(Icons.pets,
                          color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Text(
              "Place your arcade order",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 40),

            // Main content row (Left: form, Right: cart)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT PANEL - Order Details
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C1155),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildTextField("Customer Name", "Enter your name",
                              _nameController),

                          const SizedBox(height: 15),
                          _buildDropdown(
                            label: "Ticket Type",
                            value: ticketType,
                            items: const [
                              "Basic Ticket",
                              "Premium Ticket",
                              "VIP Ticket"
                            ],
                            onChanged: (val) =>
                                setState(() => ticketType = val),
                          ),

                          const SizedBox(height: 15),
                          _buildDropdown(
                            label: "Token Bundle",
                            value: tokenBundle,
                            items: const [
                              "Small Token Bundle",
                              "Medium Token Bundle",
                              "Large Token Bundle"
                            ],
                            onChanged: (val) =>
                                setState(() => tokenBundle = val),
                          ),

                          const SizedBox(height: 15),
                          const Text(
                            "Quantity",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _quantityButton("-", () {
                                if (quantity > 1) setState(() => quantity--);
                              }),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purple.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "$quantity",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              _quantityButton("+", () {
                                setState(() => quantity++);
                              }),
                            ],
                          ),

                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (ticketType != null ||
                                        tokenBundle != null) {
                                      setState(() {
                                        final selectedItem = {
                                          'name': ticketType ?? tokenBundle,
                                          'quantity': quantity,
                                          'price': _calculatePrice(
                                              ticketType ?? tokenBundle,
                                              quantity),
                                        };
                                        cartItems.add(selectedItem);
                                        totalPrice = cartItems.fold(
                                            0.0,
                                            (sum, item) =>
                                                sum + item['price']);
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purpleAccent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: const Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    _nameController.clear();
                                    setState(() {
                                      ticketType = null;
                                      tokenBundle = null;
                                      quantity = 1;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Colors.purpleAccent),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: const Text(
                                    "Clear Selection",
                                    style: TextStyle(
                                        color: Colors.purpleAccent,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  // RIGHT PANEL - Cart Preview
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C1155),
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(color: Colors.purple.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.shopping_cart_outlined,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      "Cart Preview",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // 🛒 Dynamic cart display
                                Expanded(
                                  child: cartItems.isEmpty
                                      ? const Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.shopping_cart,
                                                  color: Colors.purpleAccent,
                                                  size: 60),
                                              SizedBox(height: 10),
                                              Text("Your Cart is Empty",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: cartItems.length,
                                          itemBuilder: (context, index) {
                                            final item = cartItems[index];
                                            return ListTile(
                                              title: Text(item['name'],
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                              subtitle: Text(
                                                  "Qty: ${item['quantity']} | \$${item['price'].toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                      color: Colors.white70)),
                                              trailing: IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.redAccent),
                                                onPressed: () {
                                                  setState(() {
                                                    totalPrice -=
                                                        item['price'];
                                                    cartItems.removeAt(index);
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C1155),
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Colors.purple.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Items in Cart: ${cartItems.length}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Total: \$${totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets and Methods
  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF140634),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.purple.shade200, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.purpleAccent, width: 1.2),
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
          dropdownColor: const Color(0xFF1A082F),
          items: items
              .map((item) =>
                  DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF140634),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.purple.shade200, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.purpleAccent, width: 1.2),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _quantityButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purpleAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  double _calculatePrice(String? item, int qty) {
    switch (item) {
      case "Basic Ticket":
        return 5.0 * qty;
      case "Premium Ticket":
        return 10.0 * qty;
      case "VIP Ticket":
        return 20.0 * qty;
      case "Small Token Bundle":
        return 8.0 * qty;
      case "Medium Token Bundle":
        return 15.0 * qty;
      case "Large Token Bundle":
        return 25.0 * qty;
      default:
        return 0.0;
    }
  }
}
