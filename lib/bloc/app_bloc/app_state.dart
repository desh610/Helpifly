import 'package:helpifly/models/item_model.dart';

class AppState {
  final List<String> categories;
  final List<ItemModel> items;
  final List<ItemModel> products;
  final List<ItemModel> services;
  final bool isLoading;
  final String? error;

  AppState({
    required this.categories,
    required this.items,
    required this.products,
    required this.services,
    required this.isLoading,
    this.error,
  });

  AppState copyWith({
    List<String>? categories,
    List<ItemModel>? items,
    List<ItemModel>? products,
    List<ItemModel>? services,
    bool? isLoading,
    String? error,
  }) {
    return AppState(
      categories: categories ?? this.categories,
      items: items ?? this.items,
      products: products ?? this.products,
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
