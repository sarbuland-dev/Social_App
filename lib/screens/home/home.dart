import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/user_prodiver.dart';
import 'package:social_app/screens/post/postscreen.dart';
import 'package:get/get.dart';
import 'package:social_app/widgets/postcard_widget.dart';


class Homescreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomescreenState();
}
class HomescreenState extends State<Homescreen>{

  // @override
  // void initState() {
  //   super.initState();
  //
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid != null) {
  //     context.read<UserProvider>().listenToUser(uid);
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    final userProvider = context.watch<UserProvider>();
    final List<String> blockedUsers = userProvider.blockedUsers;
    final List<String> blockedBy = userProvider.blockedBy;

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
      body: StreamBuilder<QuerySnapshot>(
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


          final visiblePosts = posts.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final postUid = data['uid'] ?? '';
            return !blockedUsers.contains(postUid) && !blockedBy.contains(postUid);
          }).toList();

          if (visiblePosts.isEmpty) {
            return const Center(child: Text("No posts yet", style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: visiblePosts.length,
            itemBuilder: (context, index) {
              final data = visiblePosts[index].data() as Map<String, dynamic>;

              return postcard(
                key: ValueKey(data['postId']),
                postId: data['postId'] ?? '',
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
    );
  }
}
