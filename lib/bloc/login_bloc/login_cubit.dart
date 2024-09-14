import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/widgets/screen_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helpifly/models/user_info_model.dart';
import 'package:helpifly/views/main_screen.dart';
import 'dart:convert'; // Import jsonEncode and jsonDecode

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(isLoading: false));

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<void> login({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  String trimmedEmail = email.trim();
  String trimmedPassword = password.trim();

  // Start loading
  Loading().startLoading(context);

  try {
    // Firebase authentication
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: trimmedEmail,
      password: trimmedPassword,
    );

    User? user = userCredential.user;
    if (user == null) throw Exception('User not found');

    // Fetch user document
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) throw Exception('User data not found');

    // Deserialize user info
    UserInfoModel userInfo = UserInfoModel.fromJson(userDoc.data()!);

    // Save user info to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_info', jsonEncode(userInfo.toJson()));

    // Fetch updated user info and navigate
    context.read<AppCubit>().fetchUserInfoFromFirestore();
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );

  } catch (e) {
    // Display error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  } finally {
    // Ensure loading is stopped
    // Loading().stopLoading(context);
  }
}

}
