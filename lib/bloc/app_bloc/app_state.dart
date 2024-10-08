import 'package:helpifly/models/item_model.dart';
import 'package:helpifly/models/request_model.dart';
import 'package:helpifly/models/user_info_model.dart';

class AppState {
  final List<String> categories;
  final List<ItemModel> items;
  final List<RequestModel> requests;
  final List<ItemModel> products;
  final List<ItemModel> services;
  final List<ItemModel> recommendItems;
  final bool isLoading;
  final String? error;
  final UserInfoModel userInfo;
  final int currentTabIndex;
  final String chipSelectedCategory;
  final List<String> searchTextList;

  AppState({
    required this.categories,
    required this.items,
    required this.requests,
    required this.products,
    required this.services,
    required this.recommendItems,
    required this.isLoading,
    this.error,
    required this.userInfo,
    this.currentTabIndex = 0,
    this.chipSelectedCategory = "",
    required this.searchTextList
  });

  AppState copyWith({
    List<String>? categories,
    List<ItemModel>? items,
    List<RequestModel>? requests,
    List<ItemModel>? products,
    List<ItemModel>? services,
    List<ItemModel>? recommendItems,
    bool? isLoading,
    String? error,
    UserInfoModel? userInfo,
    int? currentTabIndex,
    String? chipSelectedCategory,
    List<String>? searchTextList,
  }) {
    return AppState(
      categories: categories ?? this.categories,
      items: items ?? this.items,
      requests: requests ?? this.requests,
      products: products ?? this.products,
      services: services ?? this.services,
      recommendItems: recommendItems ?? this.recommendItems,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userInfo: userInfo ?? this.userInfo,
      currentTabIndex: currentTabIndex ?? 0,
      chipSelectedCategory: chipSelectedCategory ?? this.chipSelectedCategory,
      searchTextList: searchTextList ?? this.searchTextList,
    );
  }
}
