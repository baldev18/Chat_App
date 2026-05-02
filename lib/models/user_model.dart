class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profileImage;
  final bool isOnline;
  final int lastSeen;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.isOnline,
    required this.lastSeen,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'] ?? '',
      isOnline: map['isOnline'] ?? false,
      lastSeen: map['lastSeen'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }
}
