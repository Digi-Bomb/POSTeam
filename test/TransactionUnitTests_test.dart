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
  });
}
