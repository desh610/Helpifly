import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpifly/models/user_info_model.dart';

class Comment {
  final String commentText;
  final String commentedBy;
  final String? firstName;
  final String? lastName;

  Comment({
    required this.commentText,
    required this.commentedBy,
    this.firstName,
    this.lastName,
  });

  // Convert Comment to JSON
  Map<String, dynamic> toJson() {
    return {
      'commentText': commentText,
      'commentedBy': commentedBy,
      'firstName': firstName ?? "",
      'lastName': lastName ?? "",
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentText: json['commentText'],
      commentedBy: json['commentedBy'],
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
    );
  }
}


class PostModel {
  final String id;
  final String title;
  final String description;
  final Timestamp createdAt;
  final String createdBy;
  final List<Comment> comments;
  String? firstName; // Changed to non-final
  String? lastName;  // Changed to non-final
   UserInfoModel? createdUser;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.comments,
    this.firstName,
    this.lastName,
        this.createdUser,
  });

  // Convert PostModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toDate().toIso8601String(), // Convert Timestamp to ISO 8601 string
      'createdBy': createdBy,
      'comments': comments.map((comment) => comment.toJson()).toList(), // Serialize list of comments
      'firstName': firstName, // Serialize new fields
      'lastName': lastName,   // Serialize new fields
       'createdUser': createdUser?.toJson(),  // Handle potential null value
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json, String id) {
    return PostModel(
      id: id,
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'] is Timestamp 
          ? json['createdAt'] as Timestamp 
          : Timestamp.fromDate(DateTime.parse(json['createdAt'])), // Handle both Timestamp and ISO8601
      createdBy: json['createdBy'],
      comments: (json['comments'] as List<dynamic>?)?.map((item) => Comment.fromJson(item as Map<String, dynamic>)).toList() ?? [], // Handle list of comments
      firstName: json['firstName'] as String?, // Handle new fields
      lastName: json['lastName'] as String?,  // Handle new fields
            createdUser: json['createdUser'] != null
          ? UserInfoModel.fromJson(json['createdUser'])
          : null,  // Handle potential null value
    );
  }

  // CopyWith method
  PostModel copyWith({
    String? id,
    String? title,
    String? description,
    Timestamp? createdAt,
    String? createdBy,
    List<Comment>? comments,
    String? firstName,
    String? lastName,
      UserInfoModel? createdUser,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      comments: comments ?? this.comments,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      createdUser: createdUser ?? this.createdUser,
    );
  }
}
