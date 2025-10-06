import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppointmentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> bookAppointment({
    required String doctorUid,
    required String doctorName,
    required DateTime date,
    required String time,
    required double fee,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar(
        "Error",
        "User not logged in",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final appointmentData = {
        'doctorUid': doctorUid,
        'doctorName': doctorName,
        'patientUid': user.uid,
        'patientName': user.displayName ?? "Patient",
        'date': Timestamp.fromDate(date),
        'time': time,
        'fee': fee,
        'createdAt': FieldValue.serverTimestamp(),
      };

      print("Booking appointment: $appointmentData");

      // Appointment save karega
      await _firestore.collection('appointments').add(appointmentData);

      //  Notification doctor ke liye create hoga
      await _firestore.collection("notifications").add({
        "receiverId": doctorUid, // Doctor ko notification milegi
        "senderId": user.uid, // Patient UID
        "type": "appointment",
        "message":
            "New appointment booked on ${DateFormat('dd MMM yyyy').format(date)} at $time",
        "seen": false,
        "isRead": false,
        "timestamp": FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        "Success",
        "Appointment booked on ${DateFormat('dd MMM yyyy').format(date)} at $time",
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e, st) {
      print("Firestore error: $e\n$st");
      Get.snackbar(
        "Error",
        "Failed to book appointment: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
