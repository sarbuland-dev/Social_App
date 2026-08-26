import 'package:cloud_firestore/cloud_firestore.dart';

/// SeedService: app ko test karne ke liye 12 dummy posts (alag-alag random
/// usernames ke sath) Firestore mein daal deta hai.
///
/// Use karne ka tareeqa (kahin bhi call kar sakte ho — button, initState, etc):
///   await SeedService.seedDummyPostsIfNeeded();
///
/// Ek flag document ('meta/seedInfo') check karta hai taake dobara call karne
/// pe posts duplicate na ho jayen. Agar jaan bujh kar dobara seed karwana ho,
/// niche wala `forceSeed()` function use karo (flag ko ignore karta hai).
class SeedService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final List<Map<String, String>> _dummyUsers = [
    {'uid': 'dummy_001', 'username': 'ahmed_raza', 'avatar': 'https://i.pravatar.cc/150?img=1'},
    {'uid': 'dummy_002', 'username': 'sara_khan', 'avatar': 'https://i.pravatar.cc/150?img=2'},
    {'uid': 'dummy_003', 'username': 'bilal_dev', 'avatar': 'https://i.pravatar.cc/150?img=3'},
    {'uid': 'dummy_004', 'username': 'ayesha_m', 'avatar': 'https://i.pravatar.cc/150?img=4'},
    {'uid': 'dummy_005', 'username': 'usman_tech', 'avatar': 'https://i.pravatar.cc/150?img=5'},
    {'uid': 'dummy_006', 'username': 'hina_creates', 'avatar': 'https://i.pravatar.cc/150?img=6'},
    {'uid': 'dummy_007', 'username': 'faisal_writes', 'avatar': 'https://i.pravatar.cc/150?img=7'},
    {'uid': 'dummy_008', 'username': 'mahnoor_x', 'avatar': 'https://i.pravatar.cc/150?img=8'},
    {'uid': 'dummy_009', 'username': 'zain_codes', 'avatar': 'https://i.pravatar.cc/150?img=9'},
    {'uid': 'dummy_010', 'username': 'nida_arts', 'avatar': 'https://i.pravatar.cc/150?img=10'},
    {'uid': 'dummy_011', 'username': 'hamza_photos', 'avatar': 'https://i.pravatar.cc/150?img=11'},
    {'uid': 'dummy_012', 'username': 'iqra_vibes', 'avatar': 'https://i.pravatar.cc/150?img=12'},
  ];

  static final List<String> _captions = [
    "Beautiful day out here! 🌤️",
    "New setup, feeling great 🔥",
    "Coffee and code ☕💻",
    "Weekend vibes",
    "Just another day",
    "Loving this view 😍",
    "Grind never stops 💪",
    "Throwback to good times",
    "Nature never disappoints 🌿",
    "Simple things, big joy",
    "Late night thoughts",
    "New beginnings ✨",
  ];

  /// Sirf tab seed karta hai jab pehle kabhi seed nahi kiya gaya (flag check karta hai)
  static Future<void> seedDummyPostsIfNeeded() async {
    final flagDoc = _db.collection('meta').doc('seedInfo');
    final flagSnap = await flagDoc.get();

    if (flagSnap.exists && flagSnap.data()?['seeded'] == true) {
      return; // pehle se seed ho chuka hai, dobara mat karo
    }

    await _insertDummyData(flagDoc);
  }

  /// Flag ko ignore kar ke zabardasti dobara seed karta hai
  /// (testing ke dauran manually dubara data chahiye ho to)
  static Future<void> forceSeed() async {
    final flagDoc = _db.collection('meta').doc('seedInfo');
    await _insertDummyData(flagDoc);
  }

  static Future<void> _insertDummyData(DocumentReference flagDoc) async {
    WriteBatch batch = _db.batch();
    final now = DateTime.now();

    for (int i = 0; i < _dummyUsers.length; i++) {
      final user = _dummyUsers[i];
      final postId = "dummy_post_${i + 1}";

      // Dummy user document — taake block feature bhi in dummy users pe test ho sake
      batch.set(
        _db.collection('users').doc(user['uid']),
        {
          'username': user['username'],
          'firstname': user['username'],
          'lastname': '',
          'profileImageUrl': user['avatar'],
          'email': '${user['uid']}@dummy.com',
          'phone': '',
        },
        SetOptions(merge: true),
      );

      // Dummy post
      batch.set(_db.collection('posts').doc(postId), {
        'postId': postId,
        'uid': user['uid'],
        'username': user['username'],
        'profileImageUrl': user['avatar'],
        'imageUrl': 'https://picsum.photos/seed/${user['uid']}/500/500',
        'caption': _captions[i],
        'likes': [],
        // 👇 alag-alag timestamps taake feed mein variety dikhe
        'createdAt': Timestamp.fromDate(now.subtract(Duration(hours: i * 3))),
      });
    }

    // Flag set karo taake seedDummyPostsIfNeeded() dobara na chale
    batch.set(flagDoc, {'seeded': true, 'seededAt': Timestamp.now()});

    await batch.commit();
  }
}