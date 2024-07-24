import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    emit(state.copyWith(isLoading: true));
    
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          UserInfoModel userInfo = UserInfoModel.fromJson(userDoc.data()!);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String userInfoJson = jsonEncode(userInfo.toJson());
          await prefs.setString('user_info', userInfoJson);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()), 
          );
        } else {
          throw Exception('User data not found');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
