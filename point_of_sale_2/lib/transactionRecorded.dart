import 'package:flutter/material.dart';
import 'dart:developer';

class TransactionRecorded {
  //attributes
  int transactionID = 0;
  int customerID = 0;
  int staffID = 0;
  double totalCost = 0;
  int ticketID = 0; 
  int items = 0; //this could be many different things, int, string, list of ints, list of strings etc
  String timestamp = "";
  String discount = "0%"; //whatever the discount just make the string that number, ex "33%"
  String paymentMethod = "";
  bool accessGranted = false; //can they play the games

  // var tokenBundle - how many tokens/credits
  // var deliveryMethod - how they recieve their reward

//constructor
TransactionRecorded(int transactionID, int customerID, int staffID, double totalCost, int ticketID, int items, String timeStamp, String discount, String paymentMethod, bool accessGranted){
  this.transactionID = transactionID;
  this.customerID = customerID;
  this.staffID = staffID;
  this.totalCost = totalCost;
  this.items = items;
  this.timestamp = timeStamp;
  this.discount = discount;
  this.paymentMethod = paymentMethod;
  this.accessGranted = accessGranted;
}
 
  //Functions
  // recieveData() // recieves data about the transaction and stores each piece in the appropriate variable
  // sendData() //send the data to the database or a different team
   //  Function to generate a receipt
  String generateReceipt() {
    return '''
----- RECEIPT -----
Transaction ID: $transactionID
Customer ID: $customerID
Staff ID: $staffID
Ticket ID: $ticketID
Items: $items
Total Cost: $${totalCost.toStringAsFixed(2)}
Discount: $discount
Payment Method: $paymentMethod
Access Granted: ${accessGranted ? "Yes" : "No"}
Timestamp: $timestamp
------------------
''';
  }
}