import 'package:docterapp/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Agar user already login hai to direct home bhej do
        Get.offNamed(AppRoutes.home);
      } else {
        // Agar login nahi hai to login screen par bhej do
        Get.offNamed(AppRoutes.login);
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/Medinova.png", height: 100),
            const SizedBox(height: 12),
            Text(
              "Medica",
              style: GoogleFonts.lexend(
                fontSize: 58,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0B8FAC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
