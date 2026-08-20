import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/screens/home/bottomnavigation.dart';
import 'package:social_app/screens/auth/signin.dart';
import 'package:social_app/screens/auth/signup.dart';
import 'package:social_app/screens/home/home.dart';
import 'package:social_app/screens/auth/emailverify.dart';

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
            return BottomNav();
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
