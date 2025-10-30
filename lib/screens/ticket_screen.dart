import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  final String customerName;
  final double totalAmount;

  const TicketScreen({
    super.key,
    required this.customerName,
    required this.totalAmount,
  });

  String _formatDate(DateTime dt) {
    // yyyy-MM-dd
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatTime(DateTime dt) {
    // hh:mm AM/PM
    final hour24 = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = ((hour24 + 11) % 12) + 1; // converts 0 -> 12, 13 -> 1 etc
    return '${hour12.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = _formatDate(now);
    final time = _formatTime(now);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.deepPurple, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "🎟️  Arcade Ticket",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date:", style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                  Text(date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Time:", style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                  Text(time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Customer:", style: TextStyle(fontSize: 16)),
                  Flexible(
                    child: Text(
                      customerName,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Amount Paid:", style: TextStyle(fontSize: 16)),
                  Text("\$${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 18),

              // Divider for ticket-like feel
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey.shade200,
              ),

              const SizedBox(height: 12),

              // Placeholder area for purchase details + additional info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Purchase Details:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Text("• Item / Bundle: ____________________", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 6),
                  Text("• Quantity: __________________________", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 6),
                  Text("• Tokens Issued: ____________________", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 6),
                  Text("• Arcade Zone: ______________________", style: TextStyle(fontSize: 14)),
                ],
              ),

              const SizedBox(height: 18),

              // Additional information placeholder
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Additional Info:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Text("______________________________________", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 6),
                  Text("______________________________________", style: TextStyle(fontSize: 14)),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Back"),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // finish: return to root or next step
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Finish"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
