import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpifly/bloc/forum_bloc/forum_cubit.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/widgets/custom_button.dart';
import 'package:helpifly/widgets/custom_textfield.dart';

class NewPostBottomSheet extends StatefulWidget {
  const NewPostBottomSheet({super.key});

  @override
  _NewPostBottomSheetState createState() => _NewPostBottomSheetState();
}

class _NewPostBottomSheetState extends State<NewPostBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
                child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.transparent, size: 20),
              ),
              Text(
                "New post",
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
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _titleController,
                    hintText: "Enter title here",
                    overlineText: "Title",
                    minLines: 5,
                    maxLines: 5,
                    backgroundColor: inCardColor,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: _descriptionController,
                    hintText: "Enter description here",
                    overlineText: "Description",
                    minLines: 12,
                    maxLines: null,
                    backgroundColor: inCardColor,
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    onTap: () {
                      context.read<ForumCubit>().createPost(
                        title: _titleController.text,
                        description: _descriptionController.text,
                      );
                      Navigator.of(context).pop(); // Close the bottom sheet after publishing
                    },
                    buttonText: "Publish",
                    enabled: _titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty,
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
