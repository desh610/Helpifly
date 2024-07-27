import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/views/login_screen.dart'; // Import LoginScreen for navigation

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});

    final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

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
      context.read<AppCubit>().setCurrentTabIndex(0);
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
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Call logout method when pressed
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
        child: Column(
          children: [
            SizedBox(height: 25),
                CustomTextField(controller: _firstNameController, hintText: "Enter your first name", overlineText: "First Name"),
                SizedBox(height: 15),
                CustomTextField(controller: _lastNameController, hintText: "Enter your last name", overlineText: "Last Name"),
                SizedBox(height: 15),
                Spacer(),
                CustomButton(
                    onTap: () {
                    },
                    buttonText: 'Update',
                  ),
                SizedBox(height: 15),
          ],
        ),
      )
    );
  }
}
