import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/screens/auth/signup.dart';
import 'package:social_app/services/firestore_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {

  final FirestoreService _firestoreService = FirestoreService();

  // to delete
  void _showPostOptions(String postId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xff293038),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  "Delete this post",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(postId);
                },
              ),
              ListTile(
                leading: Icon(Icons.close, color: Colors.white),
                title: Text("Cancel", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }



  void _confirmDelete(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff293038),
          title: Text("Delete Post?", style: TextStyle(color: Colors.white)),
          content: Text(
            "Are You Sure! You Want To Delete This Post  .",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // dialog band karo
                await _firestoreService.deletePost(postId);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }








  // to signout
  void _showSignoutOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xff293038),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.assignment_ind_outlined, color: Colors.red),
                title: Text(
                  "SignOut",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                onTap: () {

                  Navigator.pop(context);
                  _confirmSignout();

                },
              ),
              ListTile(
                leading: Icon(Icons.close, color: Colors.white),
                title: Text("Cancel", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }



  void _confirmSignout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff293038),
          title: Text("SignOut?", style: TextStyle(color: Colors.white)),
          content: Text(
            "Are You Sure! You Want To SignOut  .",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                context.read<UserProvider>().clear();
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                      (route) => false,
                );
              },
              child: Text("SignOut", style: TextStyle(color: Colors.red)),
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    final userProvider = context.watch<UserProvider>();
    final userData = userProvider.userData;

    String uid = FirebaseAuth.instance.currentUser!.uid;
    String fullName =
    "${userData?['firstname'] ?? ''} ${userData?['lastname'] ?? ''}".trim();
    String username = userData?['username'] ?? '';
    String photoUrl = userData?['profileImageUrl'] ?? '';
    String bio = userData?['bio'] ?? '';

    if (userProvider.isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                _showSignoutOptions();
              },
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
        ],

        title: Align(
          alignment: Alignment.center,
          child: Text(
            username.isNotEmpty ? username : "User",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Profile Photo
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 50,
                    backgroundImage: photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : AssetImage("assets/avatar/manager.png") as ImageProvider,
                  ),

                  SizedBox(width: 20),

                  // Name + Stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Name
                        Row(
                          children: [
                            Text(
                              fullName.isNotEmpty ? fullName : "User",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),

                          ],
                        ),

                        SizedBox(height: 15),

                        // Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirestoreService().getUserPostsStream(uid),

                                  builder: (context, snapshot) {
                                    int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                                    return Text(
                                      "$count",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  "posts",
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "47",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "followers",
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "189",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "following",
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  bio.isNotEmpty ? bio : "No bio yet",
                  style: TextStyle(
                    color: bio.isNotEmpty ? Colors.white : Colors.white38,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),


              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff293038),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Edit Profile", style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff293038),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Share Profile", style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getUserPostsStream(uid),

                builder: (context, snapshot) {

                  if (snapshot.hasError) {
                    return Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: TextStyle(color: Colors.red, fontSize: 9),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: CircularProgressIndicator(color: Colors.white)),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          "No posts yet",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                    );
                  }

                  final posts = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      final data = posts[index].data() as Map<String, dynamic>;
                      final imageUrl = data['imageUrl'] ?? '';
                      final postId = data['postId'] ?? '';

                      return GestureDetector(
                        onTap: () {

                        },
                        onLongPress: () => _showPostOptions(postId),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(color: Colors.grey[900]);
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[850],
                              child: Icon(Icons.broken_image, color: Colors.white54),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}