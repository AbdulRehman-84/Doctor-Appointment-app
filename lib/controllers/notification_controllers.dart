import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var unreadCount = 0.obs;
  var notifications = <Map<String, dynamic>>[].obs;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();

    // Live listener for notifications of current user
    _firestore
        .collection("notifications")
        .where("receiverId", isEqualTo: _auth.currentUser!.uid)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((query) {
          notifications.value = query.docs
              .map((doc) => {...doc.data(), "id": doc.id})
              .toList();

          final unread = query.docs.where((d) => d['seen'] == false).length;
          unreadCount.value = unread;
        });
  }

  // Mark single notification as read
  Future<void> markAsRead(String docId) async {
    await _firestore.collection("notifications").doc(docId).update({
      "seen": true,
    });
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    final snapshot = await _firestore
        .collection("notifications")
        .where("receiverId", isEqualTo: _auth.currentUser!.uid)
        .where("seen", isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({"seen": true});
    }
  }
}
