import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpifly/constants/colors.dart';
import 'package:helpifly/widgets/custom_textfield.dart';
import 'package:helpifly/widgets/widgets_exporter.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class UrlResulsSccreen extends StatelessWidget {
  UrlResulsSccreen({super.key});

  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Check product quality\nby URL",
                style: TextStyle(
                  color: white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
               CustomTextField(controller: _urlController, hintText: "Enter product URL here", overlineText: "Product URL", minLines: 5, maxLines: 5),
              SizedBox(height: 15),
              Text("Results", style: TextStyle(fontSize: 20, color: white, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                CustomPercentage(
                  title: "Positive",
                  percentage: "56%",
                  fillPercentage: 56.0,
                  fillColor: CupertinoColors.activeGreen,
                ),
                SizedBox(height: 8),
                CustomPercentage(
                  title: "Negative",
                  percentage: "20%",
                  fillPercentage: 20.0,
                  fillColor: CupertinoColors.destructiveRed
                ),
                SizedBox(height: 8),
                CustomPercentage(
                  title: "Neutral",
                  percentage: "24%",
                  fillPercentage: 24.0,
                  fillColor: CupertinoColors.activeOrange,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Overall Product Quality", style: TextStyle(fontSize: 20, color: white, fontWeight: FontWeight.bold)),
                    Container(
                      height: 100,
                      width: 100,
                      child: LiquidCircularProgressIndicator(
                      value: 0.34, // Defaults to 0.5.
                      valueColor: AlwaysStoppedAnimation(CupertinoColors.activeGreen), // Defaults to the current Theme's accentColor.
                      backgroundColor: Colors.grey.shade300, // Defaults to the current Theme's backgroundColor.
                      borderColor: white,
                      borderWidth: 2.0,
                      direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                      center: Text("34%", style: TextStyle(fontSize: 18, color: black, fontWeight: FontWeight.w500)),
                    ),
                    )
                  ],
                ),
                SizedBox(height: 15),
                // Spacer(),
                 CustomButton(onTap: (){}, buttonText: "Check Quality"),
                SizedBox(height: 10),
                  CustomButton(onTap: (){}, buttonText: "Cancel", buttonColor: cardColor, textColor: white),
                  SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}