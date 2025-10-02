import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUid = FirebaseAuth.instance.currentUser!.uid;

  /// Generate unique chatId from two UIDs
  String getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? "${uid1}_$uid2" : "${uid2}_$uid1";
  }

  /// Send message
  Future<void> sendMessage(String receiverUid, String text) async {
    final chatId = getChatId(currentUid, receiverUid);
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    final messageData = {
      'senderId': currentUid,
      'receiverId': receiverUid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'seen': false,
    };

    await messageRef.set(messageData);

    // Update lastMessage in chat root
    await _firestore.collection('chats').doc(chatId).set({
      'participants': [currentUid, receiverUid],
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Mark messages as seen
  Future<void> markMessagesSeen(String receiverUid) async {
    final chatId = getChatId(currentUid, receiverUid);
    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUid)
        .where('seen', isEqualTo: false)
        .get();

    for (var msg in messages.docs) {
      msg.reference.update({'seen': true});
    }
  }

  /// Get messages for a specific chat
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String receiverUid) {
    final chatId = getChatId(currentUid, receiverUid);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Get recent chats for current user
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecentChats() {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }
}
