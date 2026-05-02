import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Print the error for debugging
      print('SignUp Error: ${e.message}');
      rethrow;
    }
  }

  // Login with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('SignIn Error: ${e.message}');
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
