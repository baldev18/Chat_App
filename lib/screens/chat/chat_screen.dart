import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';
import '../../utils/colors.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;
  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final ap = Provider.of<AuthProvider>(context, listen: false);
    final cp = Provider.of<ChatProvider>(context, listen: false);
    
    if (ap.userModel != null) {
      cp.sendTextMessage(ap.userModel!.uid, widget.receiver.uid, text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final cp = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.receiver.profileImage.isNotEmpty 
                  ? NetworkImage(widget.receiver.profileImage) 
                  : null,
              child: widget.receiver.profileImage.isEmpty ? Icon(Icons.person) : null,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiver.name, style: TextStyle(fontSize: 16)),
                Text(widget.receiver.isOnline ? "Online" : "Offline", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: ap.userModel != null ? cp.getMessages(ap.userModel!.uid, widget.receiver.uid) : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Say Hi!"));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true, // Show latest at bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == ap.userModel!.uid;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.secondaryColor : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10)
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
