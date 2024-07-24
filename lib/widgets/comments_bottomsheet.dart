import 'package:flutter/material.dart';
import 'package:helpifly/constants/colors.dart';

class CommentsBottomSheet extends StatelessWidget {
  CommentsBottomSheet({super.key});

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
                      "Julie's post",
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
                      bottom: MediaQuery.of(context).viewInsets.bottom + 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Is this a sample community question?",
                          style: TextStyle(
                            fontSize: 18,
                            color: white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.36,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "With Chrome profiles you can separate all your Chrome stuff. Create profiles for friends and family, or split between work and fun. Read more.",
                          style: TextStyle(
                            fontSize: 12,
                            color: grayColor,
                            letterSpacing: 0.24,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Example comments
                        for (int i = 0; i < 10; i++) ...[
                          Text(
                            "Test user",
                            style: TextStyle(
                              fontSize: 16,
                              color: grayColor,
                              letterSpacing: 0.36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "This is a sample comment from test user right.",
                            style: TextStyle(
                              fontSize: 14,
                              color: white,
                              letterSpacing: 0.36,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  // SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Add your send action here
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
