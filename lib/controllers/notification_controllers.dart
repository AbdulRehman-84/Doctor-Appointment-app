import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NotificationController extends GetxController {
  var unreadCount = 0.obs;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _firestore
        .collection("notifications")
        .where("receiverId", isEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .listen((query) {
          final unread = query.docs.where((d) => d['isRead'] == false).length;
          unreadCount.value = unread;
        });
  }

  Future<void> markAsRead(String docId) async {
    await _firestore.collection("notifications").doc(docId).update({
      "isRead": true,
    });
  }
}
