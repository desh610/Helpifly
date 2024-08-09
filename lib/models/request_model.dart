
import 'package:helpifly/models/item_model.dart';

class RequestModel {
  final String id;
  final String title;
  final String title2;
  final String description;
  final String category;
  final int credit;
  final String type;
  final List<Review> reviews;
  final String imageUrl;
  final String status;

  RequestModel({
    required this.id,
    required this.title,
    required this.title2,
    required this.description,
    required this.category,
    required this.credit,
    required this.type,
    required this.reviews,
    required this.imageUrl,
    required this.status,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      title: json['title'],
      title2: json['title2'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      category: json['category'],
      credit: json['credit'] is int ? json['credit'] : (json['credit'] as double).toInt(),
      type: json['type'],
      reviews: (json['reviews'] != null && json['reviews'] is List)
          ? (json['reviews'] as List<dynamic>)
              .map((item) => item is Map<String, dynamic> ? Review.fromJson(item) : null)
              .where((item) => item != null)
              .cast<Review>()
              .toList()
          : [],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title2': title2,
      'description': description,
      'category': category,
      'credit': credit,
      'type': type,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'imageUrl': imageUrl,
      'status': status,
    };
  }

  // Add copyWith method
  RequestModel copyWith({
    String? id,
    String? title,
    String? title2,
    String? description,
    String? category,
    int? credit,
    String? type,
    List<Review>? reviews,
    String? imageUrl,
    String? status,
  }) {
    return RequestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      title2: title2 ?? this.title2,
      description: description ?? this.description,
      category: category ?? this.category,
      credit: credit ?? this.credit,
      type: type ?? this.type,
      reviews: reviews ?? this.reviews,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
    );
  }
}
