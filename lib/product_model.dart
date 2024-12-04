import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Cast to Map
    return Product(
      id: doc.id,
      name: data?['name'] ?? 'No Name',
      description: data?['description'] ?? 'No Description',
      price: (data?['price'] ?? 0).toDouble(),
      imageUrl: data != null && data.containsKey('imageurl') ? data['imageurl'] : '', // Check for 'imageurl' key
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageurl': imageUrl,
    };
  }
}
