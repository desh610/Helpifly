import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helpifly/models/post_model.dart';
import 'forum_state.dart';

class ForumCubit extends Cubit<ForumState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _cacheKey = 'cached_posts';

  ForumCubit() : super(ForumState(posts: [], isLoading: false, isFilterMyPosts: false)) {
    _loadPosts();
  }

    void setIsFiterMyPosts(bool isFilterMyPosts) {
    emit(state.copyWith(isFilterMyPosts: isFilterMyPosts));
  }

  Future<void> createPost({
    required String title,
    required String description,
    required String createdBy,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      DocumentReference docRef = await _firestore.collection('posts').add({
        'title': title,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': createdBy,
        'comments': [], // Initially empty array
      });

      PostModel newPost = PostModel(
        id: docRef.id,
        title: title,
        description: description,
        createdAt: Timestamp.now(),
        createdBy: createdBy,
        comments: [],
      );

      await docRef.update({'id': docRef.id});
      
      emit(state.copyWith(isLoading: false));
      _fetchPostsAndUpdateCache(); // Refresh the list of posts
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to create post'));
    }
  }

  Future<void> _loadPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedPostsJson = prefs.getString(_cacheKey);

    if (cachedPostsJson != null) {
      List<PostModel> cachedPosts = (jsonDecode(cachedPostsJson) as List)
          .map((data) => PostModel.fromJson(data, data['id'] as String))
          .toList();

      emit(state.copyWith(posts: cachedPosts, isLoading: false));
    } else {
      // No cache, fetch from Firestore
      _fetchPostsAndUpdateCache();
    }
  }

 Future<void> _fetchPostsAndUpdateCache() async {
  emit(state.copyWith(isLoading: true));
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('posts').get();

    List<PostModel> posts = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return PostModel.fromJson(data, doc.id);
    }).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String postsJson = jsonEncode(posts.map((post) => post.toJson()).toList());
    await prefs.setString(_cacheKey, postsJson);

    emit(state.copyWith(posts: posts, isLoading: false));
  } catch (e) {
    print('Error fetching posts: $e'); // Detailed error logging
    emit(state.copyWith(isLoading: false, error: 'Failed to fetch posts'));
  }
}


}
