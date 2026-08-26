
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/services/firestore_service.dart';
import 'package:social_app/screens/post/postscreen.dart';
import 'package:social_app/screens/auth/signup.dart';

import 'package:social_app/utils/loading_dialog.dart';
import 'package:social_app/services/seed_services.dart';
import 'package:get/get.dart';
import 'package:social_app/widgets/postcard_widget.dart';





class Homescreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomescreenState();



}
class _HomescreenState extends State<Homescreen>{


  // firestore get data
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
    SeedService.seedDummyPostsIfNeeded();
  }

  fetchUser() async {

    Map<String, dynamic>? data = await _firestoreService.getUserData();
    setState(() {
      userData = data;
      isLoading = false;
    });

  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:AppBar(
        
        toolbarHeight: 88,
        backgroundColor:Colors.black87,
        actions: [
          Padding(
              padding: EdgeInsetsGeometry.all(15),
              child: GestureDetector(
                onTap: (){

                },
                child: Image.asset('assets/pngs/message.png',height: 25,width: 25,color: Colors.white,),
              ))
        ],
        leading: Padding(padding: EdgeInsetsGeometry.all(15),child: 
          GestureDetector(
            onTap: (){Get.to(() => Postscreen());},
            child: Image.asset('assets/pngs/camera.png',width: 30,height: 30,color: Colors.white,),
          ),),
        title: Center(
          child: ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [Colors.green, Colors.blue], //
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },child:
              Text("Vibely",style: GoogleFonts.angkor(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                
              ))
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchUser();
        },              // 👈 neeche khinchne pe ye chalega
        color: Colors.white,
        backgroundColor: Colors.black87,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No posts yet"));
            }

            final posts = snapshot.data!.docs;
            // 👇 Blocked users ki filtering — dono taraf se
            List<String> blockedUsers = List<String>.from(userData?['blockedUsers'] ?? []);
            List<String> blockedBy = List<String>.from(userData?['blockedBy'] ?? []);
            print("BLOCKED USERS: $blockedUsers");
            print("BLOCKED BY: $blockedBy");
            for (var doc in posts) {
              final d = doc.data() as Map<String, dynamic>;
              print("POST UID: '${d['uid']}'  username: ${d['username']}");
            }

            final visiblePosts = posts.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final postUid = data['uid'] ?? '';
              // Agar maine isko block kiya hai, YA isne mujhe block kiya hai — post hide
              return !blockedUsers.contains(postUid) && !blockedBy.contains(postUid);
            }).toList();

            if (visiblePosts.isEmpty) {
              return const Center(child: Text("No posts yet", style: TextStyle(color: Colors.white)));
            }

            return ListView.builder(
              itemCount: visiblePosts.length,                         // ✅
              itemBuilder: (context, index) {
                final data = visiblePosts[index].data() as Map<String, dynamic>;


                return postcard(
                  postId: data['postId'] ?? '',
                  key: ValueKey(data['postId']),
                  uid: data['uid'] ?? '',

                  username: data['username'] ?? 'Unknown',
                  caption: data['caption'] ?? '',
                  photoUrl: data['imageUrl'] ?? '',
                  createdAt: data['createdAt'],
                  likes: data['likes'] ?? [],
                  avatarUrl: data['profileImageUrl'] ?? '',
                );
              },
            );
          },
        ),
      )

        );






  }
}









// ElevatedButton(onPressed: (()=>signout()),child:
// Text("signout",style: TextStyle(fontSize: 15),),
//
// ),



// ${userData?["firstname"]??""}