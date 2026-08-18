
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/signup.dart';



class Homescreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomescreenState();



}
class _HomescreenState extends State<Homescreen>{
  signout()async{
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder:(context)=> SignupScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        
        toolbarHeight: 88,
        backgroundColor:Colors.black87,
        actions: [
          Padding(
              padding: EdgeInsetsGeometry.all(15),
              child: GestureDetector(
                onTap: (){},
                child: Image.asset('assets/pngs/message.png',height: 25,width: 25,color: Colors.white,),
              ))
        ],
        leading: Padding(padding: EdgeInsetsGeometry.all(15),child: 
          GestureDetector(
            onTap: (){},
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0a0b0d), // almost black
              Color(0xff10231c), // deep dark green
              Color(0xff1a3d2e), // richer green, thora bright taake glass pe reflection dikhe
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child:Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(1), // ye border ki "thickness" hai
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Color(0xff4b5459)
                      color: Colors.black87
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.all(1), // ye border ki "thickness" hai
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Color(0xff4b5459)
                      color: Colors.black87
                  ),
                ),
              ),
              ElevatedButton(onPressed: (()=>signout())

              , child: Text("signup",style: TextStyle(fontSize: 15),))

            ],

          ),
        )

    ),

        );






  }
}









// ElevatedButton(onPressed: (()=>signout()),child:
// Text("signout",style: TextStyle(fontSize: 15),),
//
// ),