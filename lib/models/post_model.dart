import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentText;
  final String commentedBy;

  Comment({
    required this.commentText,
    required this.commentedBy,
  });

  // Convert Comment to JSON
  Map<String, dynamic> toJson() {
    return {
      'commentText': commentText,
      'commentedBy': commentedBy,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentText: json['commentText'] as String,
      commentedBy: json['commentedBy'] as String,
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

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.comments,
    this.firstName,
    this.lastName,
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
    );
  }
}
