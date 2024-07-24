import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/models/item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCubit extends Cubit<AppState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppCubit() : super(AppState(categories: [], items: [], products: [], services: [], isLoading: false)) {
    _loadCategories();
    _loadItems();
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
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('categories').doc('categories').get();
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
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('items').get();
      
      // Print the raw data fetched from Firestore
      // print('Raw data fetched from Firestore: ${querySnapshot.docs.map((doc) => doc.data()).toList()}');

      List<ItemModel> items = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ItemModel.fromJson(data);
      }).toList();

      // Print the items list
      // print('Items list after parsing: ${items.map((item) => item.toJson()).toList()}');

      // Filter items based on type
      List<ItemModel> products = items.where((item) => item.type == 'Product').toList();
      List<ItemModel> services = items.where((item) => item.type == 'Service').toList();

      // Print filtered lists
      // print('Products list: ${products.map((item) => item.toJson()).toList()}');
      // print('Services list: ${services.map((item) => item.toJson()).toList()}');

      // Sort products and services by credit in descending order
      products.sort((a, b) => b.credit.compareTo(a.credit));
      services.sort((a, b) => b.credit.compareTo(a.credit));

      // Print sorted lists
      // print('Sorted Products list: ${products.map((item) => item.toJson()).toList()}');
      // print('Sorted Services list: ${services.map((item) => item.toJson()).toList()}');

      // Cache items
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('items', jsonEncode(items.map((item) => item.toJson()).toList()));

      // Emit the updated state with filtered and sorted lists
      emit(state.copyWith(items: items, products: products, services: services, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to fetch items from Firestore: $e'));
    }
  }
}
