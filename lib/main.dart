import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'providers/auth_provider.dart' as AppAuth;
import 'providers/chat_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD6IHO0RNHOto2VdJBtxZQUXmDPlBoLac8",
        appId: "1:766847077877:android:e203f5472d06b55006e4bc",
        messagingSenderId: "766847077877",
        projectId: "chat-app-8b68b",
        storageBucket: "chat-app-8b68b.firebasestorage.app",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Pre-create both test users so login works immediately
  await _seedTestUsers();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

/// Creates both test accounts if they don't already exist.
/// If accounts already exist, it silently ignores the error.
Future<void> _seedTestUsers() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // List of test users to create
  final testUsers = [
    {'email': 'baldev1@gmail.com', 'password': '123456', 'name': 'Baldev1'},
    {'email': 'baldev2@gmail.com', 'password': '678901', 'name': 'Baldev2'},
  ];

  for (var user in testUsers) {
    try {
      // Try to create the user in Firebase Auth
      UserCredential cred = await auth.createUserWithEmailAndPassword(
        email: user['email']!,
        password: user['password']!,
      );
      // Save user data to Firestore
      await firestore.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'name': user['name'],
        'email': user['email'],
        'profileImage': '',
        'isOnline': false,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
      });
      print('Created test user: ${user['email']}');
    } catch (e) {
      // User already exists — that's fine, skip it
      print('User ${user['email']} already exists or error: $e');
    }
  }

  // Sign out after seeding so the login screen shows
  await auth.signOut();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'WhatsApp Clone',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return HomeScreen();
        }
        return LoginScreen();
      },
    );
  }
}
