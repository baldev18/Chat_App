class MessageModel {
  final String messageId;
  final String senderId;
  final String text;
  final String imageUrl;
  final String type; // 'text' or 'image'
  final int time;
  final String status; // 'sent', 'delivered', 'read'

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.imageUrl,
    required this.type,
    required this.time,
    required this.status,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'] ?? 'text',
      time: map['time'] ?? 0,
      status: map['status'] ?? 'sent',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'type': type,
      'time': time,
      'status': status,
    };
  }
}
