import 'package:flutter/material.dart';
import 'package:helpifly/constants/colors.dart';

enum ButtonType { Medium, Small }

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color buttonColor;
  final Color textColor;
  final String buttonText;
  final ButtonType buttonType;
  final IconData? leadingIcon;
  final Color? iconColor;
  final double? iconSize;
  final bool enabled; // Added enabled property

  const CustomButton({
    Key? key,
    required this.onTap,
    this.buttonColor = secondaryColor,
    this.textColor = black,
    required this.buttonText,
    this.buttonType = ButtonType.Medium,
    this.leadingIcon,
    this.iconColor,
    this.iconSize,
    this.enabled = true, // Default to true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null, // Enable or disable the onTap callback
      child: Container(
        height: buttonType == ButtonType.Medium ? 48 : 32,
        width: buttonType == ButtonType.Medium ? MediaQuery.of(context).size.width : null,
        padding: buttonType == ButtonType.Small ? EdgeInsets.symmetric(horizontal: 12) : null,
        decoration: BoxDecoration(
          color: enabled ? buttonColor : Colors.grey, // Change color if disabled
          borderRadius: BorderRadius.circular(buttonType == ButtonType.Medium ? 8 : 6),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  color: iconColor ?? textColor,
                  size: iconSize ?? 20,
                ),
                SizedBox(width: 8),
              ],
              Text(
                buttonText,
                style: TextStyle(
                  color: enabled ? textColor : Colors.black.withOpacity(0.5), // Change text color if disabled
                  fontSize: buttonType == ButtonType.Medium ? 16 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
