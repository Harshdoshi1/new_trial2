import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_trial2/controllers/order_controller.dart';

class ProgressScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Progress'),
      ),
      body: Obx(() {
        if (orderController.orders.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: orderController.orders.length,
          itemBuilder: (context, orderIndex) {
            final order = orderController.orders[orderIndex];
            final tasks = order['tasks'] as List<Map<String, dynamic>>;
            final completedTasks = tasks.where((task) => task['completed'].value).length;
            final progressPercentage = (completedTasks / tasks.length) * 100;

            return ListTile(
              leading: CircularProgressIndicator(
                value: completedTasks / tasks.length,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                backgroundColor: Colors.grey.shade200,
              ),
              title: Text('Order by: ${order['customerName']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order date: ${order['orderDate']}'),
                  Text('Progress: ${progressPercentage.toStringAsFixed(2)}%'),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
