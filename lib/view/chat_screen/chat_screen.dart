import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docterapp/controllers/message_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String image;
  final String uid;

  const ChatScreen({
    super.key,
    required this.name,
    required this.image,
    required this.uid,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final MessageController messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B8FAC),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //  Messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: messageController.getMessages(widget.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                if (messages.isEmpty) {
                  return const Center(
                    child: Text("Start chatting with the doctor!"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data();
                    final isMe =
                        msg['senderId'] == messageController.currentUid;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color(0xFF0B8FAC)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe
                                ? const Radius.circular(12)
                                : Radius.zero,
                            bottomRight: isMe
                                ? Radius.zero
                                : const Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          msg['text'] ?? "",
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input field
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.camera_alt_rounded),
                          hintText: "Write here",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF0B8FAC),
                    child: IconButton(
                      onPressed: () {
                        if (_controller.text.trim().isEmpty) return;
                        messageController.sendMessage(
                          widget.uid,
                          _controller.text.trim(),
                        );
                        _controller.clear();
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
