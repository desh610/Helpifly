import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/models/user_info_model.dart';
import 'package:helpifly/views/home_screen.dart';
import 'package:helpifly/views/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image/image.dart' as img;

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignupCubit() : super(SignupState(isLoading: false));

  void setIsLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  Future<String> _uploadProfileImage(String uid, File profileImage) async {
  try {
    // Load the image
    img.Image? image = img.decodeImage(profileImage.readAsBytesSync());
    
    // Resize the image to a smaller size
    img.Image resizedImage = img.copyResize(image!, width: 100); // Resize to 100 pixels wide (maintaining aspect ratio)
    
    // Compress the image to reduce file size
    List<int> compressedImage = img.encodeJpg(resizedImage, quality: 50); // Adjust quality as needed
    
    // Convert to Uint8List
    Uint8List uint8list = Uint8List.fromList(compressedImage);

    // Upload the compressed image
    String filePath = 'profileImages/$uid.png';
    await FirebaseStorage.instance.ref(filePath).putData(uint8list);
    String downloadUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    return downloadUrl;
  } catch (e) {
    throw Exception('Error uploading image: $e');
  }
}

  Future<void> signup(BuildContext context, String firstName, String lastName, String email, String password, File? profileImage,) async {
    setIsLoading(true);
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {

        String? profileImageUrl;
      if (profileImage != null) {
        profileImageUrl = await _uploadProfileImage(user.uid, profileImage);
      }

        UserInfoModel userInfo = UserInfoModel(
          firstName: firstName,
          lastName: lastName,
          email: email,
          uid: user.uid, 
          profileUrl: profileImageUrl ?? '',
          
        );

        await _firestore.collection('users').doc(user.uid).set(userInfo.toJson());

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userInfoJson = jsonEncode(userInfo.toJson());
        await prefs.setString('user_info', userInfoJson);

        // emit(state.copyWith(isLoading: false, isSuccess: true));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Signup successful!')),
        // );
        context.read<AppCubit>().fetchUserInfoFromFirestore();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
      }
    } on FirebaseAuthException catch (e) {
      // emit(state.copyWith(isLoading: false, isSuccess: false, errorMessage: e.message ?? 'Signup failed'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Signup failed')),
      );
    } catch (e) {
      // emit(state.copyWith(isLoading: false, isSuccess: false, errorMessage: 'An unexpected error occurred'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }
}
