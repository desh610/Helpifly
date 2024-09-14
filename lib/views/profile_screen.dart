import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/helper/helper_functions.dart';
import 'package:helpifly/models/user_info_model.dart';
import 'package:helpifly/widgets/alerts.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _emailController = TextEditingController();

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    setInitialValues();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void setInitialValues() {
    UserInfoModel userInfo = BlocProvider.of<AppCubit>(context).state.userInfo;
    setState(() {
      _firstNameController.text = userInfo.firstName;
      _lastNameController.text = userInfo.lastName;
      _emailController.text = userInfo.email;
    });
  }

  Future<void> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_info');
      await prefs.remove('items');
      await prefs.remove('posts');
      await prefs.remove('searchTextList');

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      context.read<AppCubit>().setCurrentTabIndex(0);
    } catch (e) {
      showAlert(context, 'Error signing out', red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(context),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true, // Allow resizing when keyboard appears
            backgroundColor: primaryColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: inCardColor,
              title: const Text('Profile', style: TextStyle(color: lightGrayColor, fontSize: 18),),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: lightGrayColor,),
                  onPressed: () => _logout(context),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: cardColor,
                            shape: BoxShape.circle,
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: state.userInfo.profileUrl.isNotEmpty
                                        ? NetworkImage(state.userInfo.profileUrl)
                                        : AssetImage('assets/images/default_profile.jpg')
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Tap to update profile image",
                          style: TextStyle(fontSize: 14, color: grayColor),
                        ),
                      ],
                    ),
                  ),
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
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Enter your email",
                    overlineText: "Email",
                    enabled: false,
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.28),
                  Spacer(),
                  CustomButton(
                    onTap: () {
                      context.read<AppCubit>().updateProfile(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        profileImage: _profileImage,
                        context: context
                      );
                    },
                    buttonText: 'Update',
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
