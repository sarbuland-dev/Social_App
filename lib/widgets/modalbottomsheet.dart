import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/services/firestore_service.dart';

class Sheet extends StatefulWidget {
  final String username;
  final String posterUid;

  const Sheet({
    super.key,
    required this.username,
    required this.posterUid,
  });

  @override
  State<Sheet> createState() => SheetState();
}

class SheetState extends State<Sheet> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final FirestoreService _firestoreService = FirestoreService();

  void _confirmBlock() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Color(0xff293038),
          title: Text("Block ${widget.username}?", style: TextStyle(color: Colors.white)),
          content: Text(
            "Block karne ke baad na tum inki posts dekh paoge, na wo tumhari.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
                await _firestoreService.blockUser(widget.posterUid);
              },
              child: Text("Block", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 👇 SELF-BLOCK PREVENTION:
    // Agar ye post/profile khud logged-in user ka hai (posterUid == currentUserId),
    // to "Block This User" option dikhaya hi nahi jaye ga — taake user khud ko
    // block na kar sake. Yahi check "Unfollow" pe bhi laga diya hai (khud ko
    // unfollow karna bhi mana nahi karta but logically valid nahi hota).
    final bool isOwnPost = currentUserId != null && currentUserId == widget.posterUid;

    return Container(
      height: MediaQuery.of(context).size.height / 3.5,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isOwnPost)   // 👈 sirf tab dikhao jab apni post na ho
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  "Unfollow ${widget.username}",
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                "Report This Post",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
          ),
          if (!isOwnPost)   // 👈 sirf tab dikhao jab apni post na ho — SELF-BLOCK FIX
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: _confirmBlock,
                child: const Text(
                  "Block This User",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}