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


  Future<String> createPost(Uint8List file, String caption) async {
    try {
      String uid = getCurrentUid()!;
      String postId = DateTime.now().millisecondsSinceEpoch.toString();


      Map<String, dynamic>? userData = await getUserData();
      String username = userData?['username'] ?? 'Unknown';
      String profileImageUrl = userData?['profileImageUrl'] ?? '';


      String imageUrl = await CloudinaryService.uploadImage(file);

      await _db.collection('posts').doc(postId).set({
        'postId': postId,
        'uid': uid,
        'username': username,
        'imageUrl': imageUrl,
        'caption': caption,
        'profileImageUrl': profileImageUrl,
        'likes': [],
        'createdAt': Timestamp.now(),
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }


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



//   Delete function
  Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }



//   block
  Future<void> blockUser(String blockedUid) async {
    String uid = getCurrentUid()!;

    // Batch use kar rahe hain taake dono updates ek sath (atomically) hon
    WriteBatch batch = _db.batch();

    DocumentReference myDoc = _db.collection('users').doc(uid);
    DocumentReference theirDoc = _db.collection('users').doc(blockedUid);

    batch.update(myDoc, {
      'blockedUsers': FieldValue.arrayUnion([blockedUid]),
    });

    batch.update(theirDoc, {
      'blockedBy': FieldValue.arrayUnion([uid]),
    });

    await batch.commit();
  }

  // unblock
  Future<void> unblockUser(String blockedUid) async {
    String uid = getCurrentUid()!;

    WriteBatch batch = _db.batch();

    DocumentReference myDoc = _db.collection('users').doc(uid);
    DocumentReference theirDoc = _db.collection('users').doc(blockedUid);

    batch.update(myDoc, {
      'blockedUsers': FieldValue.arrayRemove([blockedUid]),
    });

    batch.update(theirDoc, {
      'blockedBy': FieldValue.arrayRemove([uid]),
    });

    await batch.commit();
  }





  Future<bool> checkEmailExists(String email) async {
    final snap = await _db.collection('users').where('email', isEqualTo: email).get();
    return snap.docs.isNotEmpty;
  }

  Future<bool> checkUsernameExists(String username) async {
    final snap = await _db.collection('users').where('username', isEqualTo: username).get();
    return snap.docs.isNotEmpty;
  }

  Future<void> createUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getUserPostsStream(String uid) {
    return _db.collection('posts')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getFeedStream() {
    return _db.collection('posts').orderBy('createdAt', descending: true).snapshots();
  }

}



