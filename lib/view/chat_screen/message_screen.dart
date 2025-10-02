import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docterapp/controllers/docter_list_controllers.dart';
import 'package:docterapp/controllers/message_controller.dart';
import 'package:docterapp/widgets/custom_textfield.dart';
import 'package:docterapp/widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorController doctorController = Get.put(DoctorController());
    final MessageController messageController = Get.put(MessageController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Messages",
          style: GoogleFonts.openSans(
            color: const Color(0xFF0B8FAC),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: "",
              hint: "Search a Doctor",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Active Now",
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: Obx(() {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: doctorController.doctor.length,
                  itemBuilder: (context, index) {
                    final doc = doctorController.doctor[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(
                              doc['image'] ??
                                  "assets/images/default_avatar.png",
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 4,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              "Doctors",
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: messageController.getRecentChats(),
                builder: (context, snapshot) {
                  Map<String, Timestamp> recentMap = {};
                  if (snapshot.hasData) {
                    for (var doc in snapshot.data!.docs) {
                      final participants = List<String>.from(
                        doc['participants'],
                      );
                      final otherId = participants.firstWhere(
                        (id) => id != messageController.currentUid,
                      );
                      recentMap[otherId] =
                          doc['lastMessageTime'] ?? Timestamp.now();
                    }
                  }

                  // Split doctors into recent and others
                  List<Map<String, dynamic>> recentDoctors = [];
                  List<Map<String, dynamic>> otherDoctors = [];
                  for (var doc in doctorController.doctor) {
                    if (recentMap.containsKey(doc['uid'])) {
                      recentDoctors.add({
                        ...doc,
                        'lastTime': recentMap[doc['uid']],
                      });
                    } else {
                      otherDoctors.add(doc);
                    }
                  }

                  // Sort recent doctors by last message time
                  recentDoctors.sort(
                    (a, b) => (b['lastTime'] as Timestamp).compareTo(
                      a['lastTime'] as Timestamp,
                    ),
                  );

                  final allDoctors = [...recentDoctors, ...otherDoctors];

                  return ListView.builder(
                    itemCount: allDoctors.length,
                    itemBuilder: (context, index) {
                      final doc = allDoctors[index];
                      return InkWell(
                        onTap: () {
                          Get.to(
                            () => ChatScreen(
                              name: doc['name'] ?? "Unknown",
                              image:
                                  doc['image'] ??
                                  "assets/images/default_avatar.png",
                              uid: doc['uid'], // 👈 ab unique hoga
                            ),
                          );
                        },
                        child: MessageTile(
                          name: doc['name'] ?? "Unknown",
                          message: "Tap to chat",
                          time: "",
                          image:
                              doc['image'] ??
                              "assets/images/default_avatar.png",
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
