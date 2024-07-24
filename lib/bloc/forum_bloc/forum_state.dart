import 'package:flutter/material.dart';
import 'package:helpifly/models/post_model.dart';

class ForumState {
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;
  final bool isFilterMyPosts;
  final String searchQuery; // Add this field

  ForumState({
    required this.posts,
    required this.isLoading,
    this.error,
    required this.isFilterMyPosts,
     required this.searchQuery,
  });

  ForumState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    String? error,
    bool? isFilterMyPosts,
    String? searchQuery,
  }) {
    return ForumState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isFilterMyPosts: isFilterMyPosts ?? this.isFilterMyPosts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
