import 'package:firebase_core/firebase_core.dart';
import 'package:new_trial2/admin_dashboard_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:const AdminDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//hello
