import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  // Fetch orders from Firestore
  Future<void> fetchOrders() async {
    try {
      // Fetch orders from Firestore
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance.collection('orders').get();

      List<Map<String, dynamic>> fetchedOrders = [];

      for (var doc in orderSnapshot.docs) {
        String customerId = doc['customerId'];

        // Fetch the customer's name using the customerId
        DocumentSnapshot customerDoc = await FirebaseFirestore.instance.collection('customers').doc(customerId).get();
        String customerName = customerDoc['username']; // Customer name is in the 'username' field
        Timestamp orderDate = doc['orderDate']; // Order date is a Timestamp field in Firestore

        // Add order to the list
        fetchedOrders.add({
          'id': doc.id,
          'customerName': customerName,
          'orderDate': orderDate.toDate(), // Convert Timestamp to DateTime
        });
      }

      // Sort orders by customer name and then by order date
      fetchedOrders.sort((a, b) {
        // First, sort by customer name (username)
        int nameCompare = a['customerName'].compareTo(b['customerName']);
        if (nameCompare != 0) {
          return nameCompare;
        } else {
          // If customer names are the same, then sort by order date
          return a['orderDate'].compareTo(b['orderDate']);
        }
      });

      // Update the orders list
      orders.value = fetchedOrders;
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }
}
