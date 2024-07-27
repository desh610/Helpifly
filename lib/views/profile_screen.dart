import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/views/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String _originalFirstName = '';
  String _originalLastName = '';
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _firstNameController.addListener(_checkButtonEnable);
    _lastNameController.addListener(_checkButtonEnable);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_checkButtonEnable);
    _lastNameController.removeListener(_checkButtonEnable);
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          String firstName = userData['firstName'] ?? '';
          String lastName = userData['lastName'] ?? '';

          _originalFirstName = firstName;
          _originalLastName = lastName;

          _firstNameController.text = firstName;
          _lastNameController.text = lastName;
          _checkButtonEnable();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user info: ${e.toString()}')),
      );
    }
  }

  void _checkButtonEnable() {
    setState(() {
      _isButtonEnabled = _firstNameController.text.trim().isNotEmpty &&
                         _lastNameController.text.trim().isNotEmpty &&
                         (_firstNameController.text.trim() != _originalFirstName ||
                          _lastNameController.text.trim() != _originalLastName);
    });
  }

  Future<void> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_info');
      await prefs.remove('items');
      await prefs.remove('posts');

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      context.read<AppCubit>().setCurrentTabIndex(0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateProfile(BuildContext context) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('First name and last name cannot be empty')),
      );
      return;
    }

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      String uid = currentUser.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': firstName,
        'lastName': lastName,
      });

      // Update the user info in AppCubit
      context.read<AppCubit>().updateUserInfo(firstName, lastName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      _originalFirstName = firstName;
      _originalLastName = lastName;
      _checkButtonEnable();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state.userInfo.firstName != _firstNameController.text ||
            state.userInfo.lastName != _lastNameController.text) {
          _firstNameController.text = state.userInfo.firstName;
          _lastNameController.text = state.userInfo.lastName;
          _originalFirstName = state.userInfo.firstName;
          _originalLastName = state.userInfo.lastName;
          _checkButtonEnable();
        }
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: inCardColor,
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            children: [
              SizedBox(height: 25),
              CustomTextField(
                controller: _firstNameController,
                hintText: "Enter your first name",
                overlineText: "First Name",
              ),
              SizedBox(height: 15),
              CustomTextField(
                controller: _lastNameController,
                hintText: "Enter your last name",
                overlineText: "Last Name",
              ),
              SizedBox(height: 15),
              Spacer(),
              CustomButton(
                onTap: () => _updateProfile(context),
                buttonText: 'Update',
                enabled: _isButtonEnabled,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
