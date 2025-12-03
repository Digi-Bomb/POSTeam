// import 'package:flutter/material.dart';
// import '../widgets/custom_button.dart';
// import 'payment_screen.dart';

// class SummaryScreen extends StatelessWidget {
//   final String ticketType;
//   final int quantity;

//   const SummaryScreen({
//     super.key,
//     required this.ticketType,
//     required this.quantity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double price = 10.0;
//     double total = price * quantity;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Summary"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Text("Ticket Type: $ticketType", style: const TextStyle(fontSize: 18)),
//             Text("Quantity: $quantity", style: const TextStyle(fontSize: 18)),
//             Text("Total: \$${total.toStringAsFixed(2)}",
//                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const Spacer(),
//             CustomButton(
//               text: "Proceed to Payment",
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PaymentScreen(totalAmount: total),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
