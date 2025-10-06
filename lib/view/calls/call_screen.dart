import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CallScreen extends StatelessWidget {
  final String name;
  final String image;
  final String phone;

  const CallScreen({
    super.key,
    required this.name,
    required this.image,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Call $name",
          style: GoogleFonts.openSans(
            color: const Color(0xFF0B8FAC),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 60, backgroundImage: AssetImage(image)),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              phone,
              style: const TextStyle(fontSize: 18, color: Colors.teal),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                final Uri callUri = Uri(scheme: 'tel', path: phone);
                if (await canLaunchUrl(callUri)) {
                  await launchUrl(callUri);
                } else {
                  Get.snackbar(
                    "Error",
                    "Cannot launch phone dialer",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              icon: const Icon(Icons.call, color: Colors.white),
              label: const Text(
                "Call Now",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B8FAC),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
