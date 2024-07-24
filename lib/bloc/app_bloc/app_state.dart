import 'package:helpifly/models/item_model.dart';
import 'package:helpifly/models/user_info_model.dart';

class AppState {
  final List<String> categories;
  final List<ItemModel> items;
  final List<ItemModel> products;
  final List<ItemModel> services;
  final bool isLoading;
  final String? error;
  final UserInfoModel userInfo;
  final int currentTabIndex;

  AppState({
    required this.categories,
    required this.items,
    required this.products,
    required this.services,
    required this.isLoading,
    this.error,
    required this.userInfo,
    this.currentTabIndex = 0
  });

  AppState copyWith({
    List<String>? categories,
    List<ItemModel>? items,
    List<ItemModel>? products,
    List<ItemModel>? services,
    bool? isLoading,
    String? error,
    UserInfoModel? userInfo,
    int? currentTabIndex,
  }) {
    return AppState(
      categories: categories ?? this.categories,
      items: items ?? this.items,
      products: products ?? this.products,
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userInfo: userInfo ?? this.userInfo,
      currentTabIndex: currentTabIndex ?? 0,
    );
  }
}
