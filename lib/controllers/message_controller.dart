import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUid = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String receiverUid) {
    final chatId = _getChatId(currentUid, receiverUid);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // chat lis get
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecentChats() {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // send msj
  Future<void> sendMessage(String receiverUid, String text) async {
    if (text.trim().isEmpty) return;
    final chatId = _getChatId(currentUid, receiverUid);

    final messageData = {
      'text': text,
      'senderId': currentUid,
      'receiverId': receiverUid,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final chatRef = _firestore.collection('chats').doc(chatId);

    // Update Chat Metadata (last message + participants)
    await chatRef.set({
      'participants': [currentUid, receiverUid],
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Add message to messages subcollection
    await chatRef.collection('messages').add(messageData);
  }

  // genret id
  String _getChatId(String uid1, String uid2) {
    // Har user ke pair ke liye unique id banane ke liye sorting use karo
    List<String> uids = [uid1, uid2]..sort();
    return uids.join('_'); // e.g. doctor123_user456
  }
}
