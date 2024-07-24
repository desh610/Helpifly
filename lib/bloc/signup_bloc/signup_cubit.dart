import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpifly/models/user_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignupCubit() : super(SignupState(isLoading: false));

  void setIsLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  Future<void> signup(BuildContext context, String firstName, String lastName, String email, String password) async {
    setIsLoading(true);
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        UserInfoModel userInfo = UserInfoModel(
          firstName: firstName,
          lastName: lastName,
          email: email,
          uid: user.uid,
        );

        await _firestore.collection('users').doc(user.uid).set(userInfo.toJson());

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userInfoJson = jsonEncode(userInfo.toJson());
        await prefs.setString('user_info', userInfoJson);

        emit(state.copyWith(isLoading: false, isSuccess: true));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful!')),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isLoading: false, isSuccess: false, errorMessage: e.message ?? 'Signup failed'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Signup failed')),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, isSuccess: false, errorMessage: 'An unexpected error occurred'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }
}
