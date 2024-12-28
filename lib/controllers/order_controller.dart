import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  // Predefined tasks for each order
  final List<String> taskList = [
    "Design", "Modeling", "Casting", "Finishing", "Inspection", "Packaging"
  ];

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

        // Add order to the list with predefined tasks
        fetchedOrders.add({
          'id': doc.id,
          'customerName': customerName,
          'orderDate': orderDate.toDate(), // Convert Timestamp to DateTime
          'tasks': taskList.map((task) => {'taskName': task, 'completed': false.obs}).toList(),
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

  // Mark task as completed for a specific order
  void toggleTaskCompletion(int orderIndex, int taskIndex) {
    // Toggle the completion status of the task
    bool currentStatus = orders[orderIndex]['tasks'][taskIndex]['completed'].value;
    orders[orderIndex]['tasks'][taskIndex]['completed'].value = !currentStatus; // Toggle manually
  }
}
