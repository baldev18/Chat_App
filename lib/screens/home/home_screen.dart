import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/user_model.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final cp = Provider.of<ChatProvider>(context, listen: false);

    // If userModel is still loading, show a spinner
    if (ap.userModel == null) {
      return Scaffold(
        appBar: AppBar(title: Text("WhatsApp Clone")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp Clone"),
        backgroundColor: Color(0xFF075E54),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to Search Screen
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
               ap.logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Show logged-in user info at the top
          Container(
            padding: EdgeInsets.all(12),
            color: Color(0xFFE8F5E9),
            child: Row(
              children: [
                Icon(Icons.person, color: Color(0xFF075E54)),
                SizedBox(width: 10),
                Expanded(
                  child: Text("Logged in as: ${ap.userModel!.name} (${ap.userModel!.email})",
                      style: TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          // User list
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: cp.getUsers(ap.userModel!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("No other users found.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text("Login with a second account to start chatting!",
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                final users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF128C7E),
                        backgroundImage: user.profileImage.isNotEmpty
                            ? NetworkImage(user.profileImage)
                            : null,
                        child: user.profileImage.isEmpty
                            ? Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                            : null,
                      ),
                      title: Text(user.name, style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(user.email),
                      trailing: user.isOnline
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text("Online", style: TextStyle(color: Colors.white, fontSize: 11)),
                            )
                          : Text("Offline", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(receiver: user)));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
