import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';
import 'summary_screen.dart';

class TicketSelectionScreen extends StatefulWidget {
  const TicketSelectionScreen({super.key});

  @override
  State<TicketSelectionScreen> createState() => _TicketSelectionScreenState();
}

class _TicketSelectionScreenState extends State<TicketSelectionScreen> {
  String selectedTicket = "Single Entry";
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Selection"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomDropdown(
              label: "Select Ticket Type",
              value: selectedTicket,
              items: const [
                "Single Entry",
                "Day Pass",
                "Group Ticket",
              ],
              onChanged: (val) => setState(() => selectedTicket = val!),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Quantity", style: TextStyle(fontSize: 18)),
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        }),
                    Text(quantity.toString(),
                        style: const TextStyle(fontSize: 18)),
                    IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => quantity++)),
                  ],
                )
              ],
            ),
            const Spacer(),
            CustomButton(
              text: "Next → Summary",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(
                      ticketType: selectedTicket,
                      quantity: quantity,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
