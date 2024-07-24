import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpifly/constants/colors.dart';

class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light gray background color
        borderRadius: BorderRadius.circular(8.0), // Border radius of 8.0
        border: Border.all(
          color: Colors.transparent, // Light gray border color
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, color: Colors.black), // Left side search icon
          SizedBox(width: 8.0), // Add some spacing between the icon and the text field
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search product or service',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16, color: grayColor)
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle the tap event for the list icon
              print('List icon tapped');
            },
            child: Icon(Icons.menu_rounded, color: Colors.black), // Right side list icon
          ),
        ],
      ),
    );
  }
}
