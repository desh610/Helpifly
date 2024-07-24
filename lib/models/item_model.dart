class ItemModel {
  final String id;
  final String title;
  final String title2;
  final String description;
  final String category;
  final int credit; // Changed to int
  final String type;

  ItemModel({
    required this.id,
    required this.title,
    required this.title2,
    required this.description,
    required this.category,
    required this.credit,
    required this.type,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      title: json['title'],
      title2: json['title2'],
      description: json['description'],
      category: json['category'],
      credit: json['credit'] is int ? json['credit'] : (json['credit'] as double).toInt(), // Convert if needed
      type: json['type'],
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
    };
  }
}
