import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/services/cloudinary_services.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? getCurrentUid() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    String? uid = getCurrentUid();
    if (uid == null) return null;

    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }

  // 👇 post create karne ke liye
  Future<String> createPost(Uint8List file, String caption) async {
    try {
      String uid = getCurrentUid()!;
      String postId = DateTime.now().millisecondsSinceEpoch.toString();

      // 0. Current user ka username fetch karo (feed mein dikhane ke liye)
      Map<String, dynamic>? userData = await getUserData();
      String username = userData?['username'] ?? 'Unknown';

      // 1. Image ko Cloudinary pe upload karo (Firebase Storage NAHI)
      String imageUrl = await CloudinaryService.uploadImage(file);

      // 2. Post ka data Firestore mein save karo
      await _db.collection('posts').doc(postId).set({
        'postId': postId,
        'uid': uid,
        'username': username,
        'imageUrl': imageUrl,
        'caption': caption,
        'likes': [],
        'createdAt': Timestamp.now(),
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }
}