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

        var tasks = (doc['tasks'] as List).map((task) => {
          'name': task['name'],
          'completed': RxBool(task['completed'] as bool),
        }.obs).toList();

        fetchedOrders.add({
          'id': doc.id,
          'customerName': customerName,
          'orderDate': orderDate.toDate(),
          'tasks': tasks,
          'status': doc['status'], // Include status in fetched data
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
      var orderId = orders[orderIndex]['id'];
      
      // Toggle the completion status
      task['completed'].value = !task['completed'].value;
      
      // Get the updated completion status
      bool updatedCompletionStatus = task['completed'].value;
      var taskName = task['name'];

      // Update task in Firestore
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

      // Check if all tasks are completed
      bool allTasksCompleted = true;
      var tasks = orders[orderIndex]['tasks'] as List;
      
      for (var t in tasks) {
        if (!t['completed'].value) {
          allTasksCompleted = false;
          break;
        }
      }

      // Update order status if all tasks are completed
      if (allTasksCompleted) {
        await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
          'status': 'completed'
        });
        
        // Update local state
        orders[orderIndex]['status'] = 'completed';
      }

    } catch (e) {
      print('Error updating task completion status in Firestore: $e');
    }
  }

  // Helper method to check order completion status
  bool isOrderCompleted(int orderIndex) {
    var tasks = orders[orderIndex]['tasks'] as List;
    return tasks.every((task) => task['completed'].value);
  }
}