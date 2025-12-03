import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:12500";

  /// ---------------------------
  /// GET: Product List (Tickets + Bundles)
  /// ---------------------------
  static Future<Map<String, dynamic>?> getProducts() async {
    final uri = Uri.parse("$baseUrl/get/products");

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(" getProducts ERROR: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print(" Exception in getProducts(): $e");
      return null;
    }
  }

  /// ---------------------------
  /// POST: Calculate Order Total
  /// ---------------------------
  static Future<Map<String, dynamic>?> calculateOrder(
      List<Map<String, dynamic>> items) async {
    final uri = Uri.parse("$baseUrl/calculate/order");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"items": items}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(" calculateOrder ERROR: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception in calculateOrder(): $e");
      return null;
    }
  }

  /// ---------------------------
  /// POST: Validate Payment
  /// ---------------------------
  static Future<Map<String, dynamic>?> validatePayment(
      double total, double balance) async {
    final uri = Uri.parse("$baseUrl/validate/payment");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "total_amount": total,
          "customer_balance": balance,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(" validatePayment ERROR: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print(" Exception validatePayment(): $e");
      return null;
    }

    
  }
  static Future<bool> logTransaction(Map<String, dynamic> data) async {
  final uri = Uri.parse("$baseUrl/log/transaction");

  try {
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;

  } catch (e) {
    print(" logTransaction error: $e");
    return false;
  }
}

}
