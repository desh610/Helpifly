import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/models/user_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helpifly/models/post_model.dart';
import 'forum_state.dart';

class ForumCubit extends Cubit<ForumState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _cacheKey = 'cached_posts';

  ForumCubit() : super(ForumState(posts: [], isLoading: false, isFilterMyPosts: false, searchQuery: '')) {
    loadPosts();
  }

    void setIsFiterMyPosts(bool isFilterMyPosts) {
    emit(state.copyWith(isFilterMyPosts: isFilterMyPosts));
  }

   void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

Future<void> createPost({
  required String title,
  required String description,
}) async {
  emit(state.copyWith(isLoading: true));
  try {
    // Get the current user UID
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(state.copyWith(isLoading: false, error: 'User not logged in'));
      return;
    }
    
    String createdBy = currentUser.uid; // Get the UID

    // Fetch user info for the current user
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(createdBy).get();
    UserInfoModel userInfo = UserInfoModel.fromJson(userDoc.data() ?? {});

    DocumentReference docRef = await _firestore.collection('posts').add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'comments': [], // Initially empty array
      'createdUser': userInfo.toJson(),
    });

    PostModel newPost = PostModel(
      id: docRef.id,
      title: title,
      description: description,
      createdAt: Timestamp.now(),
      createdBy: createdBy,
      comments: [],
       createdUser: userInfo,
    );

    await docRef.update({'id': docRef.id});
    
    emit(state.copyWith(isLoading: false));
    _fetchPostsAndUpdateCache(); // Refresh the list of posts
  } catch (e) {
    emit(state.copyWith(isLoading: false, error: 'Failed to create post: $e'));
  }
}


  Future<void> loadPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedPostsJson = prefs.getString(_cacheKey);

    if (cachedPostsJson != null) {
      List<PostModel> cachedPosts = (jsonDecode(cachedPostsJson) as List)
          .map((data) => PostModel.fromJson(data, data['id'] as String))
          .toList();

      emit(state.copyWith(posts: cachedPosts, isLoading: false));
      _fetchPostsAndUpdateCache();
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

    List<PostModel> posts = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      String createdBy = data['createdBy'] as String;

      // Fetch user info for each post
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(createdBy).get();
          UserInfoModel userInfo = UserInfoModel.fromJson(userDoc.data() ?? {});
      // final userData = userDoc.data() ?? {};
      // String firstName = userData['firstName'] ?? '';
      // String lastName = userData['lastName'] ?? '';

      // Create PostModel with additional fields
      PostModel post = PostModel.fromJson(data, doc.id).copyWith(
        // firstName: firstName,
        // lastName: lastName,
         createdUser: userInfo,
      );

      posts.add(post);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String postsJson = jsonEncode(posts.map((post) => post.toJson()).toList());
    await prefs.setString(_cacheKey, postsJson);

    emit(state.copyWith(posts: posts, isLoading: false));
  } catch (e) {
    print('Error fetching posts: $e'); // Detailed error logging
    emit(state.copyWith(isLoading: false, error: 'Failed to fetch posts'));
  }
}

Future<void> addComment({
  required String postId,
  required String commentText,
}) async {
  emit(state.copyWith(isLoading: true));
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(state.copyWith(isLoading: false, error: 'User not logged in'));
      return;
    }

    String uid = currentUser.uid;

    // Fetch user information
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(uid).get();

    UserInfoModel userInfo = UserInfoModel.fromJson(userDoc.data() ?? {});

    Comment newComment = Comment(
      commentText: commentText,
      commentedBy: uid,
      commentedUser: userInfo
    );

    // Update the comments field of the specified post
    await _firestore.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([newComment.toJson()]),
    });

    emit(state.copyWith(isLoading: false));
    _fetchPostsAndUpdateCache(); // Refresh the list of posts to include new comments
  } catch (e) {
    emit(state.copyWith(isLoading: false, error: 'Failed to add comment: $e'));
  }
}

Future<void> deleteComment({
  required String postId,
  required String commentText,
}) async {
  emit(state.copyWith(isLoading: true));
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(state.copyWith(isLoading: false, error: 'User not logged in'));
      return;
    }

    String uid = currentUser.uid;

    // Fetch the post document
    DocumentSnapshot<Map<String, dynamic>> postDoc =
        await _firestore.collection('posts').doc(postId).get();

    if (!postDoc.exists) {
      emit(state.copyWith(isLoading: false, error: 'Post not found'));
      return;
    }

    // Extract the comments
    List<dynamic> comments = postDoc.data()?['comments'] ?? [];

    // Find the comment to delete
    var commentToDelete;
    for (var comment in comments) {
      if (comment['commentText'] == commentText && comment['commentedBy'] == uid) {
        commentToDelete = comment;
        break;
      }
    }

    if (commentToDelete == null) {
      emit(state.copyWith(isLoading: false, error: 'Comment not found'));
      return;
    }

    // Remove the comment
    comments.remove(commentToDelete);

    // Update the post document with the new comments list
    await _firestore.collection('posts').doc(postId).update({
      'comments': comments,
    });

    emit(state.copyWith(isLoading: false));
    _fetchPostsAndUpdateCache(); // Refresh the list of posts to reflect the deletion
  } catch (e) {
    emit(state.copyWith(isLoading: false, error: 'Failed to delete comment: $e'));
  }
}



 Future<void> deletePost(String postId) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Delete the post from Firestore
      await _firestore.collection('posts').doc(postId).delete();

      emit(state.copyWith(isLoading: false));
      _fetchPostsAndUpdateCache(); // Refresh the list of posts after deletion
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to delete post: $e'));
    }
  }



}
