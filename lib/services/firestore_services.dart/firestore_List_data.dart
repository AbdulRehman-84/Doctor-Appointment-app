import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getChatId(String uid1, String uid2) {
    // alphabetically to avoid duplicates
    List<String> uids = [uid1, uid2]..sort();
    return uids.join("_");
  }

  Future<void> sendMessage(
    String senderId,
    String receiverId,
    String text,
  ) async {
    String chatId = getChatId(senderId, receiverId);

    await _firestore.collection('chats').doc(chatId).set({
      'participants': [senderId, receiverId],
    }, SetOptions(merge: true));

    await _firestore.collection('chats').doc(chatId).collection('messages').add(
      {
        'text': text,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
    String uid1,
    String uid2,
  ) {
    String chatId = getChatId(uid1, uid2);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
