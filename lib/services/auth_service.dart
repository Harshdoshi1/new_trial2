import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password, String username, String phone, String address) async {
    try {
      // Create user in Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Store user data in Firestore 'customers' collection
      await FirebaseFirestore.instance.collection('customers').doc(result.user!.uid).set({
        'username': username,
        'email': email,
        'phoneNumber': phone,
        'address': address,
      });
      
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
