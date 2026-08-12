
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class Homescreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomescreenState();



}
class _HomescreenState extends State<Homescreen>{
  signout()async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.amber,
        child: ElevatedButton(onPressed: (()=>signout()), child: Text("signout",style: TextStyle(color: Colors.red,)),
      )
    ));

  }
}
