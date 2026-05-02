import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload an image file to Firebase Storage and return the download URL
  Future<String?> uploadImage(File file, String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }
}
