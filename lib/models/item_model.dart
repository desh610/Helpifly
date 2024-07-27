class Review {
  final String reviewText;
  final String reviewedBy;
  final String? firstName;
  final String? lastName;
  final String? sentimentLabel;

  Review({
    required this.reviewText,
    required this.reviewedBy,
    this.firstName,
    this.lastName,
    this.sentimentLabel,
  });

  // Convert Review to JSON
  Map<String, dynamic> toJson() {
    return {
      'reviewText': reviewText,
      'reviewedBy': reviewedBy,
      'firstName': firstName ?? "",
      'lastName': lastName ?? "",
      'sentimentLabel': sentimentLabel ?? "",
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewText: json['reviewText'],
      reviewedBy: json['reviewedBy'],
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
      sentimentLabel: json['sentimentLabel'] ?? "",
    );
  }
}

class ItemModel {
  final String id;
  final String title;
  final String title2;
  final String description;
  final String category;
  final int credit;
  final String type;
  final List<Review> reviews;

  ItemModel({
    required this.id,
    required this.title,
    required this.title2,
    required this.description,
    required this.category,
    required this.credit,
    required this.type,
    required this.reviews,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      title: json['title'],
      title2: json['title2'],
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
    };
  }

  // Add copyWith method
  ItemModel copyWith({
    String? id,
    String? title,
    String? title2,
    String? description,
    String? category,
    int? credit,
    String? type,
    List<Review>? reviews,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      title2: title2 ?? this.title2,
      description: description ?? this.description,
      category: category ?? this.category,
      credit: credit ?? this.credit,
      type: type ?? this.type,
      reviews: reviews ?? this.reviews,
    );
  }
}
