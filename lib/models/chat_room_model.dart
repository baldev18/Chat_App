class ChatRoomModel {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final int lastMessageTime;
  final Map<String, int> unReadCounts;

  ChatRoomModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unReadCounts,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      chatId: map['chatId'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] ?? 0,
      unReadCounts: Map<String, int>.from(map['unReadCounts'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unReadCounts': unReadCounts,
    };
  }
}
