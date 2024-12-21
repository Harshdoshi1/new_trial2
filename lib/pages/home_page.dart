import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_trial2/widgets/product_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          final products = snapshot.data!.docs.map((doc) => Product.fromDocument(doc)).toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
                      )
                    : const Icon(Icons.image_not_supported, size: 50),
                title: Text(product.name),
                subtitle: Text("\$${product.price}"),
                trailing: ElevatedButton(
                  onPressed: () => _placeOrder(product),
                  child: const Text("Order"),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _placeOrder(Product product) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // Ensure the user is logged in

    await FirebaseFirestore.instance.collection('orders').add({
      'customerId': currentUser.uid,
      'productId': product.id,
      'productName': product.name,
      'quantity': 1,
      'orderDate': Timestamp.now(),
      'status': 'pending',
    });
  }
}
