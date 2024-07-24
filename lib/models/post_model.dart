import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String title;
  final String description;
  final Timestamp createdAt;
  final String createdBy;
  final List<dynamic> comments;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.comments,
  });

  // Convert PostModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toDate().toIso8601String(), // Convert Timestamp to ISO 8601 string
      'createdBy': createdBy,
      'comments': comments,
    };
  }

  // Create a PostModel from JSON
  // factory PostModel.fromJson(Map<String, dynamic> json, String id) {
  //   return PostModel(
  //     id: id,
  //     title: json['title'],
  //     description: json['description'],
  //     createdAt: Timestamp.fromDate(DateTime.parse(DateTime.now().toIso8601String())), // Convert ISO 8601 string to Timestamp
  //     createdBy: json['createdBy'],
  //     comments: List<dynamic>.from(json['comments']),
  //   );
  // }

  factory PostModel.fromJson(Map<String, dynamic> json, String id) {
  return PostModel(
    id: id,
    title: json['title'],
    description: json['description'],
    createdAt: json['createdAt'] is Timestamp 
        ? json['createdAt'] as Timestamp 
        : Timestamp.fromDate(DateTime.parse(json['createdAt'])), // Handle both Timestamp and ISO8601
    createdBy: json['createdBy'],
    comments: List<dynamic>.from(json['comments'] ?? []), // Handle null case
  );
}

}
