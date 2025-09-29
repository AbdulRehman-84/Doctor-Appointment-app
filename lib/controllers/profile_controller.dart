import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var userData = {}.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await _db.collection("users").doc(uid).get();
      if (doc.exists) {
        userData.value = doc.data()!;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }
}
