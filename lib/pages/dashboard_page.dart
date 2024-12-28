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
                itemBuilder: (context, index) {
                  final order = orderController.orders[index];
                  return ListTile(
                    title: Text('Order by: ${order['customerName']}'),
                    subtitle: Text('Order date: ${order['orderDate'].toString()}'),
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
