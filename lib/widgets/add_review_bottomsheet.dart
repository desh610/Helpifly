import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/helper/helper_functions.dart';
import 'package:helpifly/models/item_model.dart';
import 'package:helpifly/widgets/custom_button.dart';
import 'package:helpifly/widgets/custom_textfield.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final ItemModel item;
  const AddReviewBottomSheet({super.key, required this.item});

  @override
  _AddReviewBottomSheetState createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  final TextEditingController _reviewController = TextEditingController();
  bool _isUpdating = false;
  String? _selectedReviewText;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardColor,
      padding: EdgeInsets.all(15.0),
      height: MediaQuery.of(context).size.height - 150,
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
                    color: Colors.transparent, size: 20),
              ),
              Text(
                "Add review for ${widget.item.title}",
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
                child: Icon(Icons.close_rounded, color: grayColor, size: 24),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Your valuable review supports ranking this product or service. You can add a maximum of 3 reviews per item.",
            style: TextStyle(color: grayColor, letterSpacing: 0.4, fontSize: 14),
          ),
          SizedBox(height: 15),
          BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              String uid = state.userInfo.uid;
              List<Review> userReviews = state.items
                  .firstWhere((e) => e.id == widget.item.id)
                  .reviews
                  .where((e2) => e2.reviewedBy == uid)
                  .toList();

              bool canAddReview = userReviews.length < 3;

              return Column(
                children: [
                  CustomTextField(
                    controller: _reviewController,
                    hintText: canAddReview ? "Enter review here" : "Select review to update",
                    overlineText: "Review",
                    minLines: 3,
                    maxLines: 3,
                    backgroundColor: inCardColor,
                    enabled: true, // Always enable text field
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                    onTap: () {
                      final reviewText = _reviewController.text.trim();
                      if (reviewText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Review cannot be empty')),
                        );
                        return;
                      }
                      if (_isUpdating && _selectedReviewText != null) {
                        BlocProvider.of<AppCubit>(context).updateReview(
                          itemId: widget.item.id,
                          newReviewText: reviewText,
                          originalReviewText: _selectedReviewText!,
                        );
                        setState(() {
                          _isUpdating = false;
                          _selectedReviewText = null;
                        });
                      } else {
                        if (canAddReview) {
                          BlocProvider.of<AppCubit>(context).addReview(
                            itemId: widget.item.id,
                            reviewText: reviewText,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Maximum reviews reached')),
                          );
                        }
                      }
                      _reviewController.clear(); // Clear the text field after sending
                      closeKeyboard(context);
                    },
                    buttonText: _isUpdating ? "Update" : "Submit",
                    enabled: canAddReview || _isUpdating, // Enable button based on condition
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Text(
                "Your reviews",
                style: TextStyle(color: white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      String uid = state.userInfo.uid;
                      List<Review> userReviews = state.items
                          .firstWhere((e) => e.id == widget.item.id)
                          .reviews
                          .where((e2) => e2.reviewedBy == uid)
                          .toList();

                      userReviews = userReviews.reversed.toList(); // Show latest reviews on top

                      return ListView.builder(
                        reverse: true, // Ensure latest reviews are on top
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: userReviews.length,
                        itemBuilder: (context, index) {
                          final review = userReviews[index];
                          final isSelected = _isUpdating && _selectedReviewText == review.reviewText;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  // Deselect if the same review is tapped again
                                  _isUpdating = false;
                                  _selectedReviewText = null;
                                  _reviewController.clear();
                                } else {
                                  _reviewController.text = review.reviewText;
                                  _isUpdating = true;
                                  _selectedReviewText = review.reviewText;
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blueGrey : inCardColor, // Change color if selected
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                review.reviewText,
                                style: TextStyle(color: white),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
