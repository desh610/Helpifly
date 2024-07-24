import 'package:flutter/material.dart';
import 'package:helpifly/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String overlineText;
  final bool obscureText;
  final double borderRadius;
  final Color borderColor;
  final int? maxLines;
  final int minLines;
  final Color backgroundColor;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.overlineText,
    this.obscureText = false,
    this.borderRadius = 8.0,
    this.borderColor = Colors.transparent, 
    this.maxLines = 1, 
    this.minLines = 1, 
    this.backgroundColor = cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              overlineText,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: white),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          // height: 48,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              minLines: minLines,
              maxLines: maxLines,
              keyboardType: TextInputType.multiline,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                hintText: hintText,
                hintStyle: const TextStyle(color: grayColor),
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              obscureText: obscureText,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: white,
              style: const TextStyle(color: white),
            ),
          ),
        ),
      ],
    );
  }
}
