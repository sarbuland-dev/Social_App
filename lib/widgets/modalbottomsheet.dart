import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sheet extends StatefulWidget {



  final String username;





  const Sheet({
    super.key,

    required this.username,


  });




  @override
  State<Sheet> createState() => SheetState();
}

class SheetState extends State<Sheet> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;


  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {},
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