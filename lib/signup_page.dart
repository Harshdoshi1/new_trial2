
import 'resuable_widgets.dart';
import 'color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _phoneError;
  String? _passwordError;
  String? _emailError;

  // Validate Phone Number (must be 10 digits)
  String? _validatePhone(String value) {
    if (value.length != 10) {
      return "Phone number must be 10 digits";
    }
    return null;
  }

  // Validate Password (min 8 chars, at least one uppercase, one number)
  String? _validatePassword(String value) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return "Password must be at least 8 characters, with uppercase, lowercase, and number.";
    }
    return null;
  }

  Future<void> _signup() async {
    setState(() {
      _phoneError = _validatePhone(_phoneController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_phoneError != null || _passwordError != null) {
      return;
    }

    try {
      // Call signUp function from AuthService
      await AuthService().signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
        _phoneController.text.trim(),
        _addressController.text.trim(),
      );

      // Navigate to login page on successful signup
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _emailError = 'This email is already in use.';
        });
      } else {
        print('Signup failed: ${e.message}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField("Enter Username", Icons.person_outline, false, _usernameController),
                const SizedBox(height: 20),
                reusableTextField("Enter Email Id", Icons.person_outline, false, _emailController,
                    errorText: _emailError),
                const SizedBox(height: 20),
                reusableTextField("Enter Phone Number", Icons.phone, false, _phoneController,
                    errorText: _phoneError),
                const SizedBox(height: 20),
                reusableTextField("Enter Address", Icons.home, false, _addressController),
                const SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outlined, true, _passwordController,
                    errorText: _passwordError),
                const SizedBox(height: 20),

                // Logo section
                const SizedBox(height: 10),
                Opacity(
                  opacity: 0.6,  // Adjust transparency
                  child: Image.asset(
                    'assets/images/logo6.png',  // Path to your logo
                    width: MediaQuery.of(context).size.width * 0.4,  // 40% of screen width
                    height: MediaQuery.of(context).size.width * 0.4, // Maintain aspect ratio
                    fit: BoxFit.contain,  // Ensure the logo fits within the area
                  ),
                ),

                // Signup button
                ElevatedButton(
                  onPressed: _signup,
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
