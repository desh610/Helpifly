import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/bloc/forum_bloc/forum_cubit.dart';
import 'package:helpifly/bloc/forum_bloc/forum_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/models/post_model.dart';
// import 'package:helpifly/models/comment_model.dart';

class CommentsBottomSheet extends StatefulWidget {
  final PostModel post;
  CommentsBottomSheet({super.key, required this.post});

  @override
  _CommentsBottomSheetState createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _responseController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Automatically scroll to bottom when widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Add some extra space (e.g., 100 pixels) to make sure the last comment is fully visible
      final double extraSpace = 100.0;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + extraSpace,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      color: cardColor,
      padding: EdgeInsets.only(top: 15),
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<ForumCubit, ForumState>(
              listener: (context, state) {
                // Auto-scroll to bottom when a comment is added
                _scrollToBottom();
              },
              builder: (context, state) {
                // Get the post with comments
                final postWithComments = state.posts.firstWhere(
                    (e) => e.id == widget.post.id,
                    orElse: () => widget.post);

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "${widget.post.createdUser!.firstName}'s post",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                BlocBuilder<AppCubit, AppState>(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () async {
                                        // Call the deletePost method and wait for it to complete
                                        try {
                                          await BlocProvider.of<ForumCubit>(context).deletePost(widget.post.id);
                                          // Optionally show a success message or handle post-deletion logic
                                        } catch (e) {
                                          // Handle the error if necessary
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Failed to delete post: $e')),
                                          );
                                        } finally {
                                          // Pop the current screen regardless of success or failure
                                          Navigator.of(context).pop();
                                        }
                                      },

                                      child: state.userInfo.uid == widget.post.createdBy ? Icon(Icons.delete,
                                          color: Colors.red, size: 22) : SizedBox(),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.post.title,
                              style: TextStyle(
                                fontSize: 18,
                                color: white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.36,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              widget.post.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: grayColor,
                                letterSpacing: 0.24,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < postWithComments.comments.length) {
                            Comment comment = postWithComments.comments[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${comment.firstName ?? ""} ${comment.lastName ?? ""}",
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
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                        childCount: postWithComments.comments.length,
                      ),
                    ),
                    // Adding padding at the bottom to ensure space for the last comment
                    SliverToBoxAdapter(
                      child:
                          SizedBox(height: 0), // Adjust this height if needed
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            color: inCardColor,
            padding: EdgeInsets.only(bottom: keyboardHeight),
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
                        postId: widget.post.id, commentText: commentText);
                    _responseController
                        .clear(); // Clear the text field after sending

                    // Scroll to bottom after adding a comment
                    // Future.delayed(Duration(milliseconds: 1000), (){
                    //   WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   _scrollToBottom();
                    // });
                    // });
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
        ],
      ),
    );
  }
}
