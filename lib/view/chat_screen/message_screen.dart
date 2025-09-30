import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docterapp/controllers/docter_list_controllers.dart';
import 'package:docterapp/controllers/message_controller.dart';
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
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: messageController.getRecentChats(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  final recentChats = snapshot.data!.docs;
                  final doctorMap = {
                    for (var doc in doctorController.doctor) doc['uid']: doc,
                  };

                  List<Widget> chatTiles = [];

                  for (var chat in recentChats) {
                    final participants = List<String>.from(
                      chat['participants'],
                    );
                    final otherId = participants.firstWhere(
                      (id) => id != messageController.currentUid,
                    );
                    final doctor = doctorMap[otherId];
                    if (doctor == null) continue;

                    final lastMessage = chat['lastMessage'] ?? "";
                    final lastTime = chat['lastMessageTime'] as Timestamp?;

                    chatTiles.add(
                      InkWell(
                        onTap: () async {
                          // mark messages seen
                          await messageController.markMessagesSeen(otherId);
                          Get.to(
                            () => ChatScreen(
                              name: doctor['name'],
                              image: doctor['image'],
                              uid: doctor['uid'],
                            ),
                          );
                        },
                        child: MessageTile(
                          name: doctor['name'],
                          message: lastMessage,
                          time: lastTime != null
                              ? "${lastTime.toDate().hour}:${lastTime.toDate().minute}"
                              : "",
                          image: doctor['image'],
                        ),
                      ),
                    );
                  }

                  // Doctors without chats
                  for (var doctor in doctorController.doctor) {
                    if (!recentChats.any(
                      (chat) => List<String>.from(
                        chat['participants'],
                      ).contains(doctor['uid']),
                    )) {
                      chatTiles.add(
                        InkWell(
                          onTap: () {
                            Get.to(
                              () => ChatScreen(
                                name: doctor['name'],
                                image: doctor['image'],
                                uid: doctor['uid'],
                              ),
                            );
                          },
                          child: MessageTile(
                            name: doctor['name'],
                            message: "Tap to chat",
                            time: "",
                            image: doctor['image'],
                          ),
                        ),
                      );
                    }
                  }

                  return ListView(children: chatTiles);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
