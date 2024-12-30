import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Function to fetch orders and generate PDF
  Future<void> _generateOrderReport(BuildContext context) async {
    // Fetch pending and completed orders from Firestore
    var completedOrders = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'completed')
        .get();

    var pendingOrders = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .get();

    // Create a PDF document
    final pdf = pw.Document();

    // Add completed orders section
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Orders Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Completed Orders: ${completedOrders.docs.length}', style: pw.TextStyle(fontSize: 18)),
            pw.ListView.builder(
              itemCount: completedOrders.docs.length,
              itemBuilder: (context, index) {
                var order = completedOrders.docs[index];
                return pw.Text('Order ID: ${order.id}, Product: ${order['productId']}');
              },
            ),
            pw.SizedBox(height: 20),
            pw.Text('Pending Orders: ${pendingOrders.docs.length}', style: pw.TextStyle(fontSize: 18)),
            pw.ListView.builder(
              itemCount: pendingOrders.docs.length,
              itemBuilder: (context, index) {
                var order = pendingOrders.docs[index];
                return pw.Text('Order ID: ${order.id}, Product: ${order['productId']}');
              },
            ),
          ],
        );
      },
    ));

    // Save the PDF and provide a download link
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Admin Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _generateOrderReport(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 163, 36, 36),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Download Orders Report (PDF)', style: TextStyle(
                        color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
