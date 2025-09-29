import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final bool isOutlined;
  final bool isLoading;
  final double radius; // ✅ Add radius

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF0B8FAC),
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.isLoading = false,
    this.radius = 8, // default radius
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius), // use radius here
            side: isOutlined
                ? BorderSide(color: color, width: 1.5)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: isOutlined ? color : textColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isOutlined ? color : textColor,
                ),
              ),
      ),
    );
  }
}
