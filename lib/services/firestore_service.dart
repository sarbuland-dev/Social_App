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

  // 👇 Naya function: post create karne ke liye
  Future<String> createPost(Uint8List file, String caption) async {
    try {
      String uid = getCurrentUid()!;
      String postId = DateTime.now().millisecondsSinceEpoch.toString();

      // 0. Current user ka username fetch karo (feed mein dikhane ke liye)
      Map<String, dynamic>? userData = await getUserData();
      String username = userData?['username'] ?? 'Unknown';

      // 1. Image ko Cloudinary pe upload karo (Firebase Storage ki jagah)
      String imageUrl = await CloudinaryService.uploadImage(file);

      // 3. Post ka data Firestore mein save karo
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

  /// Post ko like/unlike karta hai. `liked = true` karne se uid 'likes' array
  /// mein add hota hai, `liked = false` se remove hota hai. Ye idempotent hai —
  /// UI (LikeSection widget) jo bhi final state batata hai, wahi Firestore mein
  /// set ho jata hai (chahe double-tap ho ya button-tap).
  Future<void> setLikeStatus(String postId, bool liked) async {
    String? uid = getCurrentUid();
    if (uid == null) throw Exception("User logged in nahi hai");

    DocumentReference postRef = _db.collection('posts').doc(postId);

    if (liked) {
      await postRef.update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    } else {
      await postRef.update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    }
  }
}