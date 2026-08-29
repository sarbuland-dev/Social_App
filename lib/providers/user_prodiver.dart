import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? userData;
  List<String> blockedUsers = [];
  List<String> blockedBy = [];
  bool isLoading = true;

  StreamSubscription? _subscription;


  String? _currentUid;

  void listenToUser(String uid) {
    if (_currentUid == uid && _subscription != null) {
      return;
    }


    _subscription?.cancel();
    _currentUid = uid;

    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((doc) {
      userData = doc.data();
      blockedUsers = List<String>.from(userData?['blockedUsers'] ?? []);
      blockedBy = List<String>.from(userData?['blockedBy'] ?? []);
      isLoading = false;
      notifyListeners();
    });
  }


  void clear() {
    _subscription?.cancel();
    _currentUid = null;
    userData = null;
    blockedUsers = [];
    blockedBy = [];
    isLoading = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}