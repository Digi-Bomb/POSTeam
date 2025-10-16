import 'package:flutter_test/flutter_test.dart';
import 'package:project5_first_steps/main.dart'; // adjust the path if your class is in a different file

void main() {
  group('TransactionRecorded', () {
    test('generateReceipt returns correct formatted receipt', () {
      // Create a transaction object
      final transaction = TransactionRecorded(101,500,12,49.99,9001,3,"2025-10-13 18:00","15%","Credit Card",true,);

      //Create a receipt
      final receipt = transaction.generateReceipt();

      // Assert — check that the receipt contains key details
      expect(receipt.contains("Transaction ID: 101"), isTrue);
      expect(receipt.contains("Customer ID: 500"), isTrue);
      expect(receipt.contains("Total Cost: \$49.99"), isTrue);
      expect(receipt.contains("Discount: 15%"), isTrue);
      expect(receipt.contains("Access Granted: Yes"), isTrue);
      expect(receipt.contains("Timestamp: 2025-10-13 18:00"), isTrue);
     });

    test('constructor correctly assigns all fields', () {
      // Create a transaction object
      final transaction = TransactionRecorded(101,500,12,49.99,9001,3,"2025-10-13 18:00","15%","Credit Card",true);

      // Assert — check that all fields are correctly assigned
      expect(transaction.transactionID, 101);
      expect(transaction.customerID, 500);
      expect(transaction.staffID, 12);
      expect(transaction.totalCost, 49.99);
      expect(transaction.ticketID, 9001);
      expect(transaction.items, 3);
      expect(transaction.timestamp, "2025-10-13 18:00");
      expect(transaction.discount, "15%");
      expect(transaction.paymentMethod, "Credit Card");
      expect(transaction.accessGranted, true);
    });
  });
}