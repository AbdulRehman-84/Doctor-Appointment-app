import 'package:docterapp/view/payment_screen/payment_done_screen.dart';
import 'package:docterapp/widgets/custom_button.dart';
import 'package:docterapp/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Keyboard dismiss when tapping outside TextField
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0B8FAC),
        body: Column(
          children: [
            const SizedBox(height: 50),

            // Top AppBar style row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    "Payment",
                    style: GoogleFonts.openSans(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            const SizedBox(height: 80),

            // Amount
            Text(
              "\$120.00",
              style: GoogleFonts.openSans(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Bottom White Container
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading
                      Text(
                        "Doctor Chanaling Payment Method",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Payment Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Card Payment",
                              radius: 10,
                              color: const Color(0xFF0B8FAC),
                              textColor: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              text: "Cash Payment",
                              radius: 10,
                              color: Colors.grey[300]!,
                              textColor: Colors.black,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Card Number
                      CustomTextField(
                        keyboardType: TextInputType.number,
                        label: "Card Number",
                        hint: "1234 8896 1145 0896",
                      ),
                      const SizedBox(height: 15),

                      // Expiry Date & CVV
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "Expiry Date",
                              hint: "09/25",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              keyboardType: TextInputType.number,
                              label: "CVV",
                              hint: "204",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Name
                      CustomTextField(label: "Name", hint: "Abdul Rehman"),
                      const SizedBox(height: 25),

                      // Pay Now Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "Pay Now",
                          radius: 8,
                          color: const Color(0xFF0B8FAC),
                          textColor: Colors.white,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            // close keyboard
                            Get.to(() => const PaymentDoneScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
