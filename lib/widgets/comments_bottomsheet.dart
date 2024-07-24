import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/forum_bloc/forum_cubit.dart';
import 'package:helpifly/bloc/forum_bloc/forum_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/models/post_model.dart';

class CommentsBottomSheet extends StatelessWidget {
  final PostModel post;
  CommentsBottomSheet({super.key, required this.post});

  final TextEditingController _responseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardColor,
      padding: EdgeInsets.only(top: 15),
      height: MediaQuery.of(context).size.height - 150,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: grayColor, size: 20),
                    ),
                    Text(
                      "${post.firstName}'s post",
                      style: TextStyle(
                        fontSize: 16,
                        color: white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child:
                          Icon(Icons.close_rounded, color: grayColor, size: 24),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.36,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          post.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: grayColor,
                            letterSpacing: 0.24,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Example comments

                        BlocBuilder<ForumCubit, ForumState>(
                          builder: (context, state) {
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.posts.firstWhere((e) => e.id == post.id).comments.length,
                                itemBuilder: (context, index) {
                                  Comment comment = state.posts.firstWhere((e) => e.id == post.id).comments[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.commentedBy,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: grayColor,
                                          letterSpacing: 0.36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        comment.commentText,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: white,
                                          letterSpacing: 0.36,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  );
                                });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: Container(
              color: inCardColor,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _responseController,
                      style: TextStyle(color: white),
                      cursorColor: white,
                      decoration: InputDecoration(
                        hintText: 'Type your response...',
                        hintStyle: TextStyle(color: grayColor),
                        filled: true,
                        fillColor: inCardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  // SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      final commentText = _responseController.text.trim();
                      if (commentText.isEmpty) {
                        // Show an error message or indication if the comment text is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Comment cannot be empty')),
                        );
                        return;
                      }

                      // COMMENT SEND ACTION
                      BlocProvider.of<ForumCubit>(context).addComment(
                          postId: post.id, commentText: commentText);
                      _responseController
                          .clear(); // Clear the text field after sending
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        backgroundColor: inCardColor,
                        child: Icon(Icons.send, color: white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
