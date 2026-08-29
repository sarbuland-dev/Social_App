// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:social_app/screens/home/bottomnavigation.dart';
// import 'package:social_app/screens/auth/signin.dart';
// import 'package:social_app/screens/auth/signup.dart';
// import 'package:social_app/screens/auth/emailverify.dart';
// import 'package:social_app/screens/auth/profile_setup.dart';
//
// class wrapper extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => _wrapperState();
// }
// class _wrapperState extends State<wrapper>{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
//         if (snapshot.hasData){
//           if(snapshot.data!.emailVerified){
//             return StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(snapshot.data!.uid)
//                   .snapshots(),
//               builder: (context, userSnap) {
//                 if (!userSnap.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 final data = userSnap.data!.data() as Map<String, dynamic>?;
//                 final bool profileSetupDone = data?['profileSetupDone'] ?? false;
//
//                 if (profileSetupDone) {
//                   return BottomNav();
//                 } else {
//                   return ProfileSetupScreen();
//                 }
//               },
//             );
//           }else{
//             return Verify();
//           }
//
//
//         }else{
//           return SignupScreen();
//         }
//       }
//
//
//
//       ),
//     );
//
//   }
// }




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/user_prodiver.dart';

import 'package:social_app/screens/home/bottomnavigation.dart';
import 'package:social_app/screens/auth/signin.dart';
import 'package:social_app/screens/auth/signup.dart';
import 'package:social_app/screens/auth/emailverify.dart';
import 'package:social_app/screens/auth/profile_setup.dart';

class wrapper extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _wrapperState();
}
class _wrapperState extends State<wrapper>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
        if (snapshot.hasData){
          if(snapshot.data!.emailVerified){
            // 👇 UserProvider ko yahin, sabse pehle, listen karna shuru
            // karwa dete hain — BottomNav (Home/Profile) banne se PEHLE.
            context.read<UserProvider>().listenToUser(snapshot.data!.uid);

            // 👇 PEHLE yahan ek ALAG StreamBuilder<DocumentSnapshot> tha
            // jo isi document ko dobara (UserProvider se independently)
            // sunta tha — sirf 'profileSetupDone' check karne ke liye.
            // Isse EK hi document ke liye 2 real-time listeners chal rahe
            // the (double network round-trip), jo profile/home dikhne me
            // extra delay laga raha tha. Ab seedha UserProvider (Consumer)
            // se hi profileSetupDone check karte hain — sirf EK listener.
            return Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                if (userProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final bool profileSetupDone =
                    userProvider.userData?['profileSetupDone'] ?? false;

                if (profileSetupDone) {
                  return BottomNav();
                } else {
                  return ProfileSetupScreen();
                }
              },
            );
          }else{
            return Verify();
          }


        }else{
          return SignupScreen();
        }
      }



      ),
    );

  }
}