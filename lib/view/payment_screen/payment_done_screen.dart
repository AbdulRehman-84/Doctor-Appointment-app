import 'package:docterapp/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentDoneScreen extends StatelessWidget {
  const PaymentDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: size.height * 0.9, // responsive height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.20),

                /// Success Image
                Center(
                  child: Image.asset(
                    "assets/images/done.png",
                    height: size.height * 0.25,
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                /// Title
                Text(
                  "Congratulations",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: size.width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0B8FAC),
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                /// Subtitle
                Text(
                  "Your Payment is Successful",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const Spacer(),

                /// Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: CustomButton(
                    text: "Back to Home",
                    radius: 12,
                    onPressed: () {
                      Navigator.pop(context); // or navigate to home
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
