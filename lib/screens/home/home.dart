
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/services/firestore_service.dart';
import 'package:social_app/screens/post/postscreen.dart';
import 'package:social_app/screens/auth/signup.dart';

import 'package:social_app/utils/loading_dialog.dart';
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
  }

  fetchUser() async {

    Map<String, dynamic>? data = await _firestoreService.getUserData();
    setState(() {
      userData = data;
      isLoading = false;
    });

  }






  signout()async{
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder:(context)=> SignupScreen()));
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
                      Get.to(signout());
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

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final data = posts[index].data() as Map<String, dynamic>;

              return postcard(
                postId: data['postId'] ?? '',

                username: data['username'] ?? 'Unknown',
                caption: data['caption'] ?? '',
                photoUrl: data['imageUrl'] ?? '',
                createdAt: data['createdAt'],
                likes: data['likes'] ?? [],
              );
            },
          );
        },
      )

        );






  }
}









// ElevatedButton(onPressed: (()=>signout()),child:
// Text("signout",style: TextStyle(fontSize: 15),),
//
// ),



// ${userData?["firstname"]??""}