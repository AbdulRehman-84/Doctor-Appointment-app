import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docterapp/widgets/custom_button.dart';
import 'package:docterapp/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool isLoading = false; //  Loading state

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "Create New Account",
                    style: GoogleFonts.lexend(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0B8FAC),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Full Name
                CustomTextField(
                  label: "Full Name",
                  hint: "Enter Your Full Name",
                  controller: _nameController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 20),

                // Password
                CustomTextField(
                  label: "Password",
                  hint: "Enter Your Password",
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter password";
                    if (value.length < 6)
                      return "Password must be at least 6 characters";
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF0B8FAC),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                CustomTextField(
                  label: "Email",
                  hint: "Enter Your Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter email";
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value))
                      return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Phone
                CustomTextField(
                  label: "Mobile Number",
                  hint: "Enter Your Phone Number",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty
                      ? "Enter phone number"
                      : null,
                ),
                const SizedBox(height: 30),

                // Sign Up Button with loading
                CustomButton(
                  text: "Sign Up",
                  onPressed: isLoading ? null : _signUp,
                  isLoading: isLoading,
                  color: const Color(0xFF0B8FAC),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Text(
                    "OR",
                    style: GoogleFonts.averiaSansLibre(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => print("Facebook clicked"),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Colors.grey[200],
                        elevation: 0,
                      ),
                      child: Image.asset('assets/images/fb.png', height: 28),
                    ),
                    const SizedBox(width: 25),
                    ElevatedButton(
                      onPressed: () => print("Google clicked"),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Colors.grey[200],
                        elevation: 0,
                      ),
                      child: Image.asset(
                        'assets/images/google.png',
                        height: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: Text(
                        "Sign In",
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0B8FAC),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  SignUp logic with loading, snackbar, Firestore save, and navigation
  void _signUp() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(_nameController.text.trim());

        // Save extra info to Firestore
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "fullName": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "photoUrl": "", // add this for future profile pic
          "createdAt": Timestamp.now(),
        });

        // Success snackbar
        Get.snackbar(
          "Success",
          "Account created successfully!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFF0B8FAC),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Delay then navigate
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(AppRoutes.login);
      }
    } on FirebaseAuthException catch (e) {
      String message = "Signup failed. Try again.";
      if (e.code == 'email-already-in-use')
        message = "Email is already registered.";
      if (e.code == 'weak-password')
        message = "Password must be at least 6 characters.";
      if (e.code == 'invalid-email') message = "Invalid email.";

      Get.snackbar(
        "Signup Error",
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
