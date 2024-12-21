import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailsPage extends StatefulWidget {
  final QueryDocumentSnapshot product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? selectedCustomer;
  final TextEditingController _advancePaymentController =
      TextEditingController();
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? "Product Details"),
        backgroundColor: const Color.fromARGB(224, 138, 57, 57),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF4DBD8),
              Color(0xFFE7C6A5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    product['imageurl'] ?? '',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Details
              Text(
                "Name: ${product['name'] ?? 'N/A'}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Text(
                "Price: ₹${product['price'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 10),

              Text(
                "Mandatory Advance Amount: ₹${product['mandatoryAdvanceAmount'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 10),

              Text(
                "Category: ${product['category'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 10),

              Text(
                "Description:",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              Text(
                product['description'] ?? "No description available.",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Place Order Button
              Center(
                child: ElevatedButton(
                  onPressed: () => _showPlaceOrderDialog(context, product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(224, 138, 57, 57),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text("Place Order"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlaceOrderDialog(BuildContext context, QueryDocumentSnapshot product) {
    String? selectedCustomer;
    TextEditingController _advancePaymentController = TextEditingController();
    int quantity = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Place Order for ${product['name']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Customer Selection Dropdown
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('customers').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final customers = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    value: selectedCustomer,
                    hint: const Text("Select Customer"),
                    items: customers.map((customer) {
                      return DropdownMenuItem(
                        value: customer.id,
                        child: Text(customer['username'] ?? "Unnamed"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedCustomer = value;
                    },
                  );
                },
              ),
              const SizedBox(height: 10),

              // Quantity Field
              TextFormField(
                initialValue: quantity.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                ),
                onChanged: (value) {
                  quantity = int.tryParse(value) ?? 1;
                },
              ),

              const SizedBox(height: 10),

              // Advance Payment Field
              TextFormField(
                controller: _advancePaymentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Advance Payment",
                  prefixText: "₹",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  final advancePayment =
                      int.tryParse(_advancePaymentController.text) ?? 0;
                  final mandatoryAmount = product['mandatoryAdvanceAmount'] as int;
                  final totalPrice = product['price'] as int;

                  if (selectedCustomer == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a customer.")),
                    );
                    return;
                  }

                  if (advancePayment < mandatoryAmount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Advance payment must be at least ₹$mandatoryAmount.")),
                    );
                    return;
                  }

                  if (quantity > product['quantity']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Insufficient stock available.")),
                    );
                    return;
                  }

                  final remainingPayment = totalPrice - advancePayment;

                  // Save Order to Firestore
                  FirebaseFirestore.instance.collection('orders').add({
                    'productId': product.id,
                    'customerId': selectedCustomer,
                    'advancePayment': advancePayment.toString(),
                    'quantity': quantity,
                    'orderDate': DateTime.now(),
                    'totalPrice': totalPrice,
                    'remainingPayment': remainingPayment,
                    'status': "pending",
                  }).then((value) {
                    // Update Product Quantity in Firestore
                    FirebaseFirestore.instance.collection('products').doc(product.id).update({
                      'quantity': FieldValue.increment(-quantity),
                    });

                    Navigator.pop(context);

                    // Show Confirmation Dialog with Tick Mark
                    _showOrderConfirmation(context);
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error placing order: $error")),
                    );
                  });
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("An unexpected error occurred: $error")),
                  );
                }
              },
              child: const Text("Confirm Order"),
            ),
          ],
        );
      },
    );
  }

  void _showOrderConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          ),
          content: const Text("Your order has been successfully placed!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
