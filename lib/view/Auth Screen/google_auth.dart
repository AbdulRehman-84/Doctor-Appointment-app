import 'dart:io';

import 'package:docterapp/view/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  try {
    // Check internet connection
    final result = await InternetAddress.lookup('google.com');
    if (result.isEmpty || result[0].rawAddress.isEmpty) {
      throw SocketException('No Internet connection');
    }

    // Trigger Google Sign-In
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign-In cancelled by user")),
      );
      return null;
    }

    // Get auth details
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create Firebase credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with Firebase
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    // Navigate to HomeScreen if successful
    if (userCredential.user != null) {
      Get.offAll(() => HomeScreen());
    }

    return userCredential;
  } on SocketException catch (_) {
    // Internet connection error
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No internet connection. Please try again."),
      ),
    );
    return null;
  } catch (e) {
    // Other errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Google Sign-In failed: ${e.toString()}")),
    );
    return null;
  }
}
