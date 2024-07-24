import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '${weeks} week${weeks > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '${months} month${months > 1 ? 's' : ''} ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '${years} year${years > 1 ? 's' : ''} ago';
  }
}

Future<Map<String, String>> getUserInfo(String uid) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      String firstName = data?['firstName'] ?? 'Unknown';
      String lastName = data?['lastName'] ?? 'User';
      return {'firstName': firstName, 'lastName': lastName};
    } else {
      return {'firstName': 'Unknown', 'lastName': 'User'};
    }
  } catch (e) {
    print('Error fetching user info: $e');
    return {'firstName': 'Unknown', 'lastName': 'User'};
  }
}

 void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
