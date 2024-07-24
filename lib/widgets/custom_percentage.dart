import 'package:flutter/material.dart';
import 'package:helpifly/constants/colors.dart';

class CustomPercentage extends StatelessWidget {
  final String title;
  final String percentage;
  final double fillPercentage;
  final Color fillColor;

  CustomPercentage({
    required this.title,
    required this.percentage,
    required this.fillPercentage,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 16,
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 15,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // color: cardColor,
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fillPercentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}