import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  // Controllers for text fields
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // Firestore instance
  final _firestore = FirebaseFirestore.instance;

  // To show a loading indicator
  bool _isLoading = false;

  // Function to add customer to Firestore
  Future<void> _addCustomer() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Add customer to Firestore
      await _firestore.collection('customers').add({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer added successfully!')),
      );

      // Clear the input fields
      _usernameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _addressController.clear();
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding customer: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingItem('Username', _usernameController),
            _buildSettingItem('Email', _emailController, keyboardType: TextInputType.emailAddress),
            _buildSettingItem('Phone Number', _phoneController, keyboardType: TextInputType.phone),
            _buildSettingItem('Address', _addressController),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _addCustomer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Add Customer'),
                  ),
          ],
        ),
      ),
    );
  }

  // Reusable widget for setting-like items
  Widget _buildSettingItem(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter $label',
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          keyboardType: keyboardType,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
