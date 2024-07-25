import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/app_bloc/app_cubit.dart';
import 'package:helpifly/bloc/app_bloc/app_state.dart';
import 'package:helpifly/constants/colors.dart';
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
          CustomTextField(
            controller: _reviewController,
            hintText: "Enter review here",
            overlineText: "Review",
            minLines: 5,
            maxLines: 5,
            backgroundColor: inCardColor,
          ),
          SizedBox(height: 10),
          CustomButton(
            onTap: () {
              final reviewText = _reviewController.text.trim();
              if (reviewText.isEmpty) {
                // Show an error message or indication if the review text is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Review cannot be empty')),
                );
                return;
              }
              BlocProvider.of<AppCubit>(context).addReview(
                  itemId: widget.item.id, reviewText: reviewText);
              _reviewController.clear(); // Clear the text field after sending
            },
            buttonText: "Submit",
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Text("Your reviews", style: TextStyle(color: white, fontWeight: FontWeight.w500),),
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

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: userReviews.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                                color: inCardColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              userReviews[index].reviewText,
                              style: TextStyle(color: white),
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
