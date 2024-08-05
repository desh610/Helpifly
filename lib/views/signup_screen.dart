import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/signup_bloc/signup_cubit.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/views/home_screen.dart'; // Import your HomeScreen
import 'package:helpifly/views/login_screen.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

   File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: const [
                  Text("Signup here",
                      style: TextStyle(
                          fontSize: 32,
                          color: white,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: const [
                  Text("Explore your journey with Helpifly!",
                      style: TextStyle(
                          fontSize: 14,
                          color: grayColor,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.6)),
                ],
              ),
              SizedBox(height: 25),
             GestureDetector(
                      onTap: _pickImage,
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              image: _profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(_profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _profileImage == null
                                ? Center(
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: grayColor,
                                      size: 26,
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Tap to set profile logo",
                            style: TextStyle(fontSize: 14, color: grayColor),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 25),
              CustomTextField(controller: _firstNameController, hintText: "Enter your first name", overlineText: "First Name"),
              SizedBox(height: 15),
              CustomTextField(controller: _lastNameController, hintText: "Enter your last name", overlineText: "Last Name"),
              SizedBox(height: 15),
              CustomTextField(controller: _emailController, hintText: "Enter your email", overlineText: "Email"),
              SizedBox(height: 15),
              CustomTextField(controller: _passwordController, hintText: "Enter your password", overlineText: "Password", obscureText: true,),
              SizedBox(height: 15),
              CustomTextField(controller: _confirmPasswordController, hintText: "Enter your password again", overlineText: "Confirm Password", obscureText: true,),
              const SizedBox(height: 30),
              BlocConsumer<SignupCubit, SignupState>(
                listener: (context, state) {
                  if (state.isSuccess) {
                    // Navigate to HomeScreen on successful signup
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                  if (state.errorMessage.isNotEmpty) {
                    // Show error message if there is an error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    onTap: () {
                      final cubit = context.read<SignupCubit>();
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      final confirmPassword = _confirmPasswordController.text.trim();
                      final firstName = _firstNameController.text.trim();
                      final lastName = _lastNameController.text.trim();

                      // Check if passwords match
                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match')),
                        );
                        return;
                      }

                      // Call signup method
                      cubit.signup(context, firstName, lastName, email, password, _profileImage);
                    },
                    buttonText: state.isLoading ? 'Signing up...' : 'Signup',
                  );
                },
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: grayColor, fontSize: 14),
                      ),
                      TextSpan(
                        text: "Login",
                        style: TextStyle(color: lightGrayColor, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
