import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/bottomnavigation.dart';
import 'package:social_app/signin.dart';
import 'package:social_app/signup.dart';
import 'package:social_app/home.dart';
import 'package:social_app/emailverify.dart';

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
