import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/views/login_screen.dart'; // Import LoginScreen for navigation

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      // Clear cached user data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_info');
      await prefs.remove('items');
      await prefs.remove('posts');


      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate to LoginScreen after logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // Handle any errors during logout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: inCardColor,
        title: const Text('Profile Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Call logout method when pressed
          ),
        ],
      ),
      body: Center(
        child: Text("Profile Screen", style: TextStyle(color: white)),
      ),
    );
  }
}
