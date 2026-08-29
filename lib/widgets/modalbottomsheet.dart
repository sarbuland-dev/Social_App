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
            "After blocking, you won't be able to see their posts, and they won't be able to see yours..",
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
    final bool isOwnPost = currentUserId != null && currentUserId == widget.posterUid;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff293038),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isOwnPost)
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
              if (!isOwnPost)
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
        ),
      ),
    );
  }
}