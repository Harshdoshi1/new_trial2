import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_trial2/controllers/order_controller.dart';

class DashboardScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Dashboard'),
      ),
      body: FutureBuilder(
        future: orderController.fetchOrders(), // Fetch orders
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Obx(() {
              return ListView.builder(
                itemCount: orderController.orders.length,
                itemBuilder: (context, orderIndex) {
                  final order = orderController.orders[orderIndex];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      title: Text('Order by: ${order['customerName']}'),
                      subtitle: Text('Order date: ${order['orderDate'].toString()}'),
                      children: [
                        // Task list for each order
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: order['tasks'].length,
                          itemBuilder: (context, taskIndex) {
                            final task = order['tasks'][taskIndex];
                            return Obx(() {
                              return ListTile(
                                title: Text(task['taskName']),
                                trailing: Checkbox(
                                  value: task['completed'].value, // Ensure the checkbox reflects RxBool
                                  onChanged: (_) {
                                    // Update the completion status
                                    orderController.toggleTaskCompletion(orderIndex, taskIndex);
                                  },
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            });
          }
        },
      ),
    );
  }
}
