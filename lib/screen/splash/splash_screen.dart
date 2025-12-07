import 'dart:async';
import 'package:flutter/material.dart';
import 'package:purchaseproject/utils/app_color.dart';
import 'package:purchaseproject/utils/responsive.dart';
import 'package:purchaseproject/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();


    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = Responsive.height(context);
    final w = Responsive.width(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "Manage\nCustomer Order",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.08,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
              ),
            ),

            SizedBox(height: h * 0.04),

            const CircularProgressIndicator(color: Colors.white),

            SizedBox(height: h * 0.02),

            const Text(
              "Loading...",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
