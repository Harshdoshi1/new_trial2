import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_trial2/pages/add_customer_page.dart';
import 'package:new_trial2/pages/admin_placeorder.dart';
import 'package:new_trial2/pages/progress_screen.dart';
import 'package:new_trial2/pages/setting_page.dart';
import 'package:new_trial2/pages/task_page.dart';
import 'package:new_trial2/utils/color_utils.dart';

// import 'resuable_widgets.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ProgressScreen(), // Dashboard/Progress Page
    AdminPlaceOrderPage(), // Add Order Page
    AddCustomerScreen(), // Add Customer Page
    TaskPage(), // Tasks Page
    SettingsPage() // Settings Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 120, 60, 28),
          elevation: 0,
          title: Text(
            _selectedIndex == 1 ? "Admin Orders" : "Admin Dashboard",
            style: GoogleFonts.josefinSans(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  hexStringToColor("E7C6A5"),
                  hexStringToColor("E7C6A5"), // Customize the gradient colors
                  hexStringToColor("F4DBD8"),
                  hexStringToColor("F4DBD8"),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          _pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 124, 45, 45),
        unselectedItemColor: const Color.fromARGB(137, 11, 10, 10),
        backgroundColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Add orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add customer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}


// Placeholder page for Orders


// Placeholder page for Add Order
class DashboardMetric extends StatelessWidget {
  final String label;
  final String value;

  const DashboardMetric({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
