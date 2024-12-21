import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_trial2/models/product_model.dart';
import 'product_details_page.dart';

class AdminPlaceOrderPage extends StatelessWidget {
  const AdminPlaceOrderPage({Key? key}) : super(key: key);

  Color hexStringToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 56.0), // Space for AppBar height
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("#F4DBD8"),
                hexStringToColor("#E7C6A5"),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = snapshot.data!.docs;

              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  if (screenWidth > 600) crossAxisCount = 3;
                  if (screenWidth > 900) crossAxisCount = 4;

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: constraints.maxWidth * 0.05,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return ProductCard(
                        product: product,
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(product: product),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
