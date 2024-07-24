import 'package:flutter/material.dart';
import 'package:helpifly/constants/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logo_dev, size: 60, color: secondaryColor),
            Text("Helpifly", style: TextStyle(color: white, fontSize: 32, fontWeight: FontWeight.w500, letterSpacing: 1.2))
          ],
        ),
      ),
    );
  }
}