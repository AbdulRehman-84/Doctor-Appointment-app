import 'package:docterapp/controllers/docter_list_controllers.dart';
import 'package:docterapp/view/chat_screen/chat_screen.dart';
import 'package:docterapp/widgets/custom_textfield.dart';
import 'package:docterapp/widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorController doctorController = Get.put(DoctorController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
        title: Text(
          "Message",
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
              suffixIcon: const Icon(Icons.mic, color: Colors.grey),
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
                    var doc = doctorController.doctor[index];
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
              "Messages",
              style: GoogleFonts.openSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: doctorController.doctor.length,
                  itemBuilder: (context, index) {
                    var doc = doctorController.doctor[index];
                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => ChatScreen(
                            name: doc['name'] ?? "Unknown",
                            image:
                                doc['image'] ??
                                "assets/images/default_avatar.png",
                          ),
                        );
                      },
                      child: MessageTile(
                        name: doc['name'] ?? "Unknown",
                        message: "Hello, how can I help you?",
                        time: "12:50",
                        unreadCount: index.isEven ? 2 : 0,
                        image:
                            doc['image'] ?? "assets/images/default_avatar.png",
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
