import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_trial2/controllers/order_controller.dart';

class TaskPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
      ),
      body: FutureBuilder(
        future: orderController.fetchOrders(),
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
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer: ${order['customerName']}'),
                          Text('Order Date: ${order['orderDate']}'),
                          SizedBox(height: 10),
                          // Display tasks for this order
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // Prevent scroll conflict
                            itemCount: order['tasks'].length,
                            itemBuilder: (context, taskIndex) {
                              final task = order['tasks'][taskIndex];
                              return Obx(() {
                                return CheckboxListTile(
                                  title: Text(task['name']),
                                  value: task['completed']
                                      .value, // Reactively observe the value
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      orderController.toggleTaskCompletion(
                                          orderIndex, taskIndex);
                                    }
                                  },
                                );
                              });
                            },
                          ),
                        ],
                      ),
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
