import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/bloc/forum_bloc/forum_cubit.dart';
import 'package:helpifly/bloc/forum_bloc/forum_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/helper/helper_functions.dart';
import 'package:helpifly/models/post_model.dart';
import 'package:helpifly/models/user_info_model.dart';
import 'package:helpifly/widgets/comments_bottomsheet.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  void _showNewPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      builder: (BuildContext context) {
        return NewPostBottomSheet();
      },
    );
  }

  void _showCommentsBottomSheet(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      builder: (BuildContext context) {
        return CommentsBottomSheet(post: post);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      final userInfo = state.userInfo;
                      return Text("Welcome ${userInfo.firstName},", style: const TextStyle(
                      color: white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.6,
                    ),);
                    },
                  ),
            Text(
              "Share your problems\nfor community support",
              style: TextStyle(
                color: white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            CustomSearchBar(),
            SizedBox(height: 15),
            BlocBuilder<ForumCubit, ForumState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                       BlocProvider.of<ForumCubit>(context).setIsFiterMyPosts(!state.isFilterMyPosts);
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              border: Border.all(color: cardGrayColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: state.isFilterMyPosts ? Center(
                              child: Icon(
                                Icons.done,
                                size: 17,
                                color: CupertinoColors.activeGreen,
                              ),
                            ) : SizedBox(),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Filter my posts",
                            style: TextStyle(
                              fontSize: 16,
                              color: white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      onTap: () => _showNewPostBottomSheet(context),
                      buttonText: "New Post",
                      buttonType: ButtonType.Small,
                      leadingIcon: Icons.add,
                      iconColor: black,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 8),
            BlocBuilder<ForumCubit, ForumState>(
              builder: (context, state) {
                UserInfoModel userInfo = BlocProvider.of<AppCubit>(context).state.userInfo;
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: state.isFilterMyPosts ? state.posts.where((e) => e.createdBy == userInfo.uid).length : state.posts.length,
                    itemBuilder: (context, index) {
                      final post = state.isFilterMyPosts ? state.posts.where((e) => e.createdBy == userInfo.uid).toList()[index] : state.posts[index];
                      return GestureDetector(
                        onTap: () => _showCommentsBottomSheet(context, post),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: cardGrayColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                      '${post.firstName ?? ""} ${post.lastName ?? ""}', // Concatenate firstName and lastName
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: white, // Assuming white is a color variable
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                      ),
                                    )

                                    ],
                                  ),
                                  Text(
                                    // Format this according to your needs
                                    timeAgo(post.createdAt.toDate()), // Placeholder for timestamp
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: grayColor,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.24,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
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
                                post.description, // Use the actual description
                                style: TextStyle(
                                  fontSize: 12,
                                  color: grayColor,
                                  letterSpacing: 0.24,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${post.comments.length} Answered", // Placeholder for answer count
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: grayColor,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.24,
                                    ),
                                  ),
                                  CustomButton(
                                    onTap: () =>
                                        _showCommentsBottomSheet(context, post),
                                    buttonText: "Comments",
                                    buttonColor: cardGrayColor,
                                    textColor: lightGrayColor,
                                    iconColor: lightGrayColor,
                                    leadingIcon: Icons.comment,
                                    buttonType: ButtonType.Small,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
