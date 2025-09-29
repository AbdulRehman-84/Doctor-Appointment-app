import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class mainProfileController extends GetxController {
  var userName = "".obs;
  var userEmail = "".obs;
  var userPhoto = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();
      if (doc.exists) {
        userName.value = doc["fullName"] ?? "";
        userEmail.value = doc["email"] ?? "";
        userPhoto.value = doc["photoUrl"] ?? "";
      }
    } catch (e) {
      print("Error loading profile: $e");
    }
  }
}
