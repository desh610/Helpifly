import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helpifly/models/user_info_model.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/models/item_model.dart';

class AppCubit extends Cubit<AppState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppCubit()
      : super(AppState(
            categories: [],
            searchTextList: [],
            items: [],
            products: [],
            services: [],
            isLoading: false,
            chipSelectedCategory: "Institutes",
            userInfo: UserInfoModel(firstName: '', lastName: '', email: '', uid: ''), currentTabIndex: 0)) {
    _loadCategories();
    _loadItems();
    _loadUserInfo();
    _loadSearchTextList(); // Load search text list during initialization
  }

  void setCurrentTabIndex(int currentTabIndex) {
    emit(state.copyWith(currentTabIndex: currentTabIndex));
  }

  void setChipSelectedCategory(String chipSelectedCategory) {
    emit(state.copyWith(chipSelectedCategory: chipSelectedCategory));
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedCategories = prefs.getString('categories');

      if (cachedCategories != null) {
        List<dynamic> cachedList = jsonDecode(cachedCategories);
        List<String> categories = List<String>.from(cachedList);
        emit(state.copyWith(categories: categories, isLoading: false));
        // Fetch from Firestore to update cache (if needed)
        _fetchCategoriesFromFirestore();
      } else {
        _fetchCategoriesFromFirestore(); // Fetch from Firestore if not cached
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load categories: $e'));
    }
  }

  Future<void> _fetchCategoriesFromFirestore() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('categories').doc('categories').get();
      if (doc.exists) {
        List<String> categories = List<String>.from(doc.data()?['data'] ?? []);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('categories', jsonEncode(categories));
        emit(state.copyWith(categories: categories, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, error: 'Categories document does not exist'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to fetch categories from Firestore: $e'));
    }
  }

  Future<void> _loadItems() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedItems = prefs.getString('items');

      if (cachedItems != null) {
        List<dynamic> cachedList = jsonDecode(cachedItems);
        List<ItemModel> items = cachedList.map((item) => ItemModel.fromJson(item)).toList();
        emit(state.copyWith(items: items, isLoading: false));
        // Fetch from Firestore to update cache (if needed)
        _fetchItemsFromFirestore();
      } else {
        _fetchItemsFromFirestore(); // Fetch from Firestore if not cached
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load items: $e'));
    }
  }

  Future<void> _fetchItemsFromFirestore() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('items').get();

      List<ItemModel> items = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ItemModel.fromJson(data);
      }).toList();

      // Filter items based on type
      List<ItemModel> products =
          items.where((item) => item.type == 'Product').toList();
      List<ItemModel> services =
          items.where((item) => item.type == 'Service').toList();

      // Sort products and services by credit in descending order
      products.sort((a, b) => b.credit.compareTo(a.credit));
      services.sort((a, b) => b.credit.compareTo(a.credit));

      // Cache items
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('items', jsonEncode(items.map((item) => item.toJson()).toList()));

      // Emit the updated state with filtered and sorted lists
      emit(state.copyWith(
          items: items,
          products: products,
          services: services,
          isLoading: false));

      // Update search text list after fetching items
      _updateSearchTextList();

    } catch (e) {
      emit(state.copyWith(
          isLoading: false, error: 'Failed to fetch items from Firestore: $e'));
    }
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoJson = prefs.getString('user_info');
    if (userInfoJson != null) {
      try {
        Map<String, dynamic> userMap = jsonDecode(userInfoJson);
        UserInfoModel userInfo = UserInfoModel.fromJson(userMap);
        emit(state.copyWith(userInfo: userInfo));
      } catch (e) {
        // Handle JSON decode error
        emit(state.copyWith(userInfo: UserInfoModel(firstName: 'User', lastName: '', email: '', uid: '')));
        print('Error decoding user info: $e');
      }
    } else {
      // Fetch from Firestore if not cached
      _fetchUserInfoFromFirestore();
    }
  }

  Future<void> _fetchUserInfoFromFirestore() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          UserInfoModel userInfo = UserInfoModel.fromJson(doc.data()!);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_info', jsonEncode(userInfo.toJson()));
          emit(state.copyWith(userInfo: userInfo));
        } else {
          emit(state.copyWith(
              userInfo: UserInfoModel(firstName: 'User', lastName: '', email: '', uid: ''),
              error: 'User document does not exist'));
        }
      } else {
        emit(state.copyWith(
            userInfo: UserInfoModel(firstName: 'User', lastName: '', email: '', uid: ''),
            error: 'No logged-in user'));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to fetch user info from Firestore: $e'));
    }
  }

  Future<void> _loadSearchTextList() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedSearchTextList = prefs.getString('searchTextList');

      if (cachedSearchTextList != null) {
        List<dynamic> cachedList = jsonDecode(cachedSearchTextList);
        List<String> searchTextList = List<String>.from(cachedList);
        emit(state.copyWith(searchTextList: searchTextList, isLoading: false));
      } else {
        _updateSearchTextList();
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load search text list: $e'));
    }
  }

  Future<void> _updateSearchTextList() async {
    try {
      // Combine categories and item titles
      List<String> searchTextList = [
        ...state.categories,
        ...state.items.map((item) => item.title)
      ];

      // Cache search text list
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('searchTextList', jsonEncode(searchTextList));

      // Emit the updated state
      emit(state.copyWith(searchTextList: searchTextList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to update search text list: $e'));
    }
  }
}
