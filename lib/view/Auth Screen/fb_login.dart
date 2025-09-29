// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:get/get.dart';

// Future<UserCredential?> signInWithFacebook(BuildContext context) async {
//   try {
//     // Trigger Facebook Login
//     final LoginResult result = await FacebookAuth.instance.login(
//       permissions: ['email', 'public_profile'],
//     );

//     if (result.status == LoginStatus.success) {
//       // Create a credential for Firebase
//       final OAuthCredential facebookCredential =
//           FacebookAuthProvider.credential(result.accessToken!.token);

//       // Sign in to Firebase
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(facebookCredential);

//       if (userCredential.user != null) {
//         Get.offAll(() => const HomeScreen());
//       }

//       return userCredential;
//     } else if (result.status == LoginStatus.cancelled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Facebook Sign-In cancelled by user")),
//       );
//       return null;
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Facebook Sign-In failed: ${result.message}")),
//       );
//       return null;
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Facebook Sign-In error: ${e.toString()}")),
//     );
//     return null;
//   }
// }
