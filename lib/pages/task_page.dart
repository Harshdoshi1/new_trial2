import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_trial2/controllers/order_controller.dart';

import '../utils/color_utils.dart';


class TaskPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("E7C6A5"),
              hexStringToColor("F4DBD8"),
              hexStringToColor("F4DBD8"),
              hexStringToColor("E7C6A5"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer: ${order['customerName']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Order Date: ${order['orderDate']}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tasks:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 5),
                            // Display tasks for this order
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: order['tasks'].length,
                              itemBuilder: (context, taskIndex) {
                                final task = order['tasks'][taskIndex];
                                return Obx(() {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CheckboxListTile(
                                      title: Text(
                                        task['name'],
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      value: task['completed'].value,
                                      activeColor: Colors.green,
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          orderController.toggleTaskCompletion(
                                              orderIndex, taskIndex);
                                        }
                                      },
                                    ),
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
      ),
    );
  }
}
