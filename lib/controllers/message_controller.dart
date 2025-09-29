import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUid = FirebaseAuth.instance.currentUser!.uid;

  // Stream of messages for a chat
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String receiverUid) {
    final chatId = _getChatId(currentUid, receiverUid);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Send message to Firestore
  Future<void> sendMessage(String receiverUid, String text) async {
    if (text.trim().isEmpty) return;
    final chatId = _getChatId(currentUid, receiverUid);

    await _firestore.collection('chats').doc(chatId).set({
      'participants': [currentUid, receiverUid],
    }, SetOptions(merge: true));

    await _firestore.collection('chats').doc(chatId).collection('messages').add(
      {
        'text': text,
        'senderId': currentUid,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
  }

  // Chat ID generator (unique for two users)
  String _getChatId(String uid1, String uid2) {
    List<String> uids = [uid1, uid2]..sort();
    return uids.join('_');
  }
}

// import 'package:flutter/material.dart';

// // 🔹 MessageTile same as before
// class MessageTile extends StatelessWidget {
//   final String name;
//   final String message;
//   final String time;
//   final int unreadCount;
//   final String image;

//   const MessageTile({
//     super.key,
//     required this.name,
//     required this.message,
//     required this.time,
//     this.unreadCount = 0,
//     required this.image,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.teal.shade50,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(radius: 25, backgroundImage: AssetImage(image)),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   message,
//                   style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               Text(
//                 time,
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//               ),
//               if (unreadCount > 0)
//                 Container(
//                   margin: const EdgeInsets.only(top: 6),
//                   padding: const EdgeInsets.all(6),
//                   decoration: const BoxDecoration(
//                     color: Colors.teal,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Text(
//                     "$unreadCount",
//                     style: const TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
