import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Confirm and update payment
  Future<void> confirmPayment({
    required String paymentId,
    required String appointmentId,
    required String method,
  }) async {
    try {
      // Update payment record
      await _firestore.collection("payments").doc(paymentId).update({
        "status": "success",
        "method": method,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // Update appointment record
      await _firestore.collection("appointments").doc(appointmentId).update({
        "paymentStatus": "success",
      });

      Get.snackbar(
        "Success",
        "Payment confirmed",
        backgroundColor: const Color(0xFF0B8FAC),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Payment update failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
