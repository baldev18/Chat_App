import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  // Generate a unique chat ID based on two user IDs
  String getChatId(String uid1, String uid2) {
    List<String> uids = [uid1, uid2];
    uids.sort(); // Sort so the ID is always the same for these two users
    return uids.join('_');
  }

  Future<void> sendTextMessage(String senderId, String receiverId, String text) async {
    String chatId = getChatId(senderId, receiverId);
    String messageId = const Uuid().v1(); // Generate unique message ID

    MessageModel message = MessageModel(
      messageId: messageId,
      senderId: senderId,
      text: text,
      imageUrl: '',
      type: 'text',
      time: DateTime.now().millisecondsSinceEpoch,
      status: 'sent',
    );

    await _databaseService.sendMessage(chatId, message, receiverId);
  }

  Future<void> sendImageMessage(String senderId, String receiverId, File imageFile) async {
    _isUploading = true;
    notifyListeners();

    String chatId = getChatId(senderId, receiverId);
    String messageId = const Uuid().v1();
    
    // Upload image to Firebase Storage
    String path = 'chat_images/$chatId/$messageId.jpg';
    String? imageUrl = await _storageService.uploadImage(imageFile, path);

    if (imageUrl != null) {
      MessageModel message = MessageModel(
        messageId: messageId,
        senderId: senderId,
        text: '',
        imageUrl: imageUrl,
        type: 'image',
        time: DateTime.now().millisecondsSinceEpoch,
        status: 'sent',
      );

      await _databaseService.sendMessage(chatId, message, receiverId);
    }
    
    _isUploading = false;
    notifyListeners();
  }

  Stream<List<MessageModel>> getMessages(String currentUserId, String otherUserId) {
    String chatId = getChatId(currentUserId, otherUserId);
    return _databaseService.streamMessages(chatId);
  }

  Stream<List<UserModel>> getUsers(String currentUserId) {
    return _databaseService.streamUsers(currentUserId);
  }
}
