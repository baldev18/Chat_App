import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _initAuthListener();
  }

  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        _userModel = await _databaseService.getUserData(user.uid);
        if (_userModel != null) {
           _databaseService.updateUserStatus(_userModel!.uid, true);
        }
      } else {
        if (_userModel != null) {
           _databaseService.updateUserStatus(_userModel!.uid, false);
        }
        _userModel = null;
      }
      notifyListeners();
    });
  }

  // Try to login. If user doesn't exist, auto-create the account.
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      // Check if the error is "user not found" — auto-create the account
      String errorMessage = e.toString().toLowerCase();
      bool isUserNotFound = errorMessage.contains('user-not-found') ||
          errorMessage.contains('no user record') ||
          errorMessage.contains('credential is incorrect') ||
          errorMessage.contains('invalid-credential');
      if (isUserNotFound) {
        try {
          UserCredential? cred = await _authService.signUpWithEmailAndPassword(email, password);
          if (cred != null && cred.user != null) {
            UserModel newUser = UserModel(
              uid: cred.user!.uid,
              name: email.split('@')[0],
              email: email,
              profileImage: '',
              isOnline: true,
              lastSeen: DateTime.now().millisecondsSinceEpoch,
            );
            await _databaseService.saveUserData(newUser);
          }
          _isLoading = false;
          notifyListeners();
          return null;
        } catch (signUpError) {
          _isLoading = false;
          notifyListeners();
          return signUpError.toString();
        }
      }
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      UserCredential? cred = await _authService.signUpWithEmailAndPassword(email, password);
      if (cred != null && cred.user != null) {
        UserModel newUser = UserModel(
          uid: cred.user!.uid,
          name: name,
          email: email,
          profileImage: '',
          isOnline: true,
          lastSeen: DateTime.now().millisecondsSinceEpoch,
        );
        await _databaseService.saveUserData(newUser);
      }
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> logout() async {
     if (_userModel != null) {
        await _databaseService.updateUserStatus(_userModel!.uid, false);
     }
    await _authService.signOut();
  }
}
