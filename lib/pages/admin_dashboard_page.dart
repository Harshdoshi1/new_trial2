import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:new_trial2/pages/add_customer_page.dart';
import 'package:new_trial2/pages/admin_placeorder.dart';
import 'package:new_trial2/pages/login_page.dart';
import 'package:new_trial2/pages/progress_screen.dart';
import 'package:new_trial2/pages/setting_page.dart';
import 'package:new_trial2/pages/task_page.dart';

import 'package:new_trial2/utils/color_utils.dart';



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
    SettingsPage(), // Settings Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pop(context); // Close the drawer
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
  await FirebaseAuth.instance.signOut(); // Sign out from Firebase
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()), // Navigate to the login page
  );
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
      drawer: Drawer(
        child: Container(
          color: hexStringToColor("6D4C41"), // Darker shade for the entire drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      hexStringToColor("5D4037"), // Darker shade
                      hexStringToColor("4E342E"),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Admin Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard, color: Colors.white),
                title: const Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _onDrawerItemTapped(0),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.white),
                title: const Text(
                  'Add Orders',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _onDrawerItemTapped(1),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.white),
                title: const Text(
                  'Add Customer',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _onDrawerItemTapped(2),
              ),
              ListTile(
                leading: const Icon(Icons.task, color: Colors.white),
                title: const Text(
                  'Tasks',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _onDrawerItemTapped(3),
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _onDrawerItemTapped(4),
              ),
              const Divider(color: Colors.white), // Separator
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: _logout, // Call the logout function
              ),
            ],
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
