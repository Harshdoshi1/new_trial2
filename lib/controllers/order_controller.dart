import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class OrderController extends GetxController {
  RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  Future<void> fetchOrders() async {
    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance.collection('orders').get();
      List<Map<String, dynamic>> fetchedOrders = [];

      for (var doc in orderSnapshot.docs) {
        String customerId = doc['customerId'];
        DocumentSnapshot customerDoc = await FirebaseFirestore.instance.collection('customers').doc(customerId).get();
        String customerName = customerDoc['username'];
        Timestamp orderDate = doc['orderDate'];

        // Convert tasks to RxMap instead of a regular Map
        var tasks = (doc['tasks'] as List).map((task) => {
          'name': task['name'],
          'completed': RxBool(task['completed'] as bool), // Create RxBool here
        }.obs).toList(); // Make each task observable

        fetchedOrders.add({
          'id': doc.id,
          'customerName': customerName,
          'orderDate': orderDate.toDate(),
          'tasks': tasks,
        });
      }

      fetchedOrders.sort((a, b) {
        int nameCompare = a['customerName'].compareTo(b['customerName']);
        if (nameCompare != 0) return nameCompare;
        return a['orderDate'].compareTo(b['orderDate']);
      });

      orders.value = fetchedOrders;
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> toggleTaskCompletion(int orderIndex, int taskIndex) async {
    try {
      // Get the current task
      var task = orders[orderIndex]['tasks'][taskIndex];
      
      // Toggle the completion status
      task['completed'].value = !task['completed'].value;
      
      // Get the updated completion status
      bool updatedCompletionStatus = task['completed'].value;
      
      var orderId = orders[orderIndex]['id'];
      var taskName = task['name'];

      // Update Firestore
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'tasks': FieldValue.arrayRemove([
          {
            'name': taskName,
            'completed': !updatedCompletionStatus,
          },
        ]),
      });

      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'tasks': FieldValue.arrayUnion([
          {
            'name': taskName,
            'completed': updatedCompletionStatus,
          },
        ]),
      });
    } catch (e) {
      print('Error updating task completion status in Firestore: $e');
    }
  }
}