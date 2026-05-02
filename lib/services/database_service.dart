import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save or update user data in Firestore
  Future<void> saveUserData(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  // Get user details by UID
  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Stream all users except the current user
  Stream<List<UserModel>> streamUsers(String currentUserId) {
    return _firestore.collection('users').where('uid', isNotEqualTo: currentUserId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    });
  }

  // Update user online status
  Future<void> updateUserStatus(String uid, bool isOnline) async {
    await _firestore.collection('users').doc(uid).update({
      'isOnline': isOnline,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Send a message
  Future<void> sendMessage(String chatId, MessageModel message, String receiverId) async {
    // 1. Add message to messages subcollection
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.messageId)
        .set(message.toMap());

    // 2. Update the chat room's last message and time
    await _firestore.collection('chats').doc(chatId).set({
      'chatId': chatId,
      'lastMessage': message.type == 'image' ? '📸 Image' : message.text,
      'lastMessageTime': message.time,
      'participants': FieldValue.arrayUnion([message.senderId, receiverId]),
    }, SetOptions(merge: true));
  }

  // Stream messages for a chat
  Stream<List<MessageModel>> streamMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList();
    });
  }
}
