import 'package:docterapp/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:docterapp/widgets/custom_button.dart';
import 'package:get/get.dart';
// apna home screen import karo

class PaymentDoneScreen extends StatelessWidget {
  const PaymentDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.15),
            Lottie.asset(
              "assets/images/Completed Successfully.json",
              height: size.height * 0.4,
              repeat: false,
            ),
            SizedBox(height: size.height * 0.03),
            Text(
              "Congratulations",
              style: GoogleFonts.openSans(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0B8FAC),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Your Payment is Successful",
              style: GoogleFonts.openSans(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: CustomButton(
                text: "Back to Home",
                radius: 12,
                onPressed: () {
                  Get.offAll(() => HomeScreen()); // ✅ direct home
                },
              ),
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
