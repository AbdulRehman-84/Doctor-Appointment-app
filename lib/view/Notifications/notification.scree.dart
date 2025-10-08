import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docterapp/controllers/notification_controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUid = FirebaseAuth.instance.currentUser!.uid;

  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: GoogleFonts.openSans(
            color: const Color(0xFF0B8FAC),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.teal),
            onPressed: () {
              notificationController.markAllAsRead();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection("notifications")
            .where("receiverId", isEqualTo: currentUid)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final message = data["message"] ?? "";
              final type = data["type"] ?? "";
              final timestamp = (data["timestamp"] as Timestamp?)?.toDate();
              final seen = data["seen"] ?? false;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: seen ? Colors.grey : const Color(0xFF0B8FAC),
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),
                title: Text(
                  message,
                  style: TextStyle(
                    fontWeight: seen ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: timestamp != null
                    ? Text(
                        "${timestamp.toLocal()}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      )
                    : null,
                trailing: type.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : null,
                onTap: () async {
                  await notificationController.markAsRead(docs[index].id);
                  Get.snackbar(
                    "Notification",
                    "Marked as read",
                    snackPosition: SnackPosition.TOP,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
