import 'package:docterapp/view/Auth%20Screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.openSans(
            color: const Color(0xFF0B8FAC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Profile Image
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage(
                    "assets/images/profile.png",
                  ),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),

              /// Name
              Text(
                "Abdul Rehman",
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// Options
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildProfileTile(Icons.history, "History"),
                    buildProfileTile(Icons.person_2_rounded, "Personal Detail"),
                    buildProfileTile(Icons.location_city, "Location"),
                    buildProfileTile(Icons.payment, "Payment Method"),
                    buildProfileTile(Icons.settings, "Settings"),
                    buildProfileTile(Icons.help_center_rounded, "Help"),
                    buildProfileTile(Icons.logout, "Logout", isLogout: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom ListTile Widget
  Widget buildProfileTile(
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color(0xFF0B8FAC)),
          title: Text(
            title,
            style: GoogleFonts.openSans(
              color: isLogout ? Colors.red : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: isLogout
              ? null
              : const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () async {
            if (isLogout) {
              await FirebaseAuth.instance.signOut();

              // Navigation to Login Screen
              Get.offAll(() => const LoginScreen());
            }
          },
        ),
      ],
    );
  }
}
