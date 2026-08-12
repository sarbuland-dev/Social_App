
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/signup.dart';



class Signinscreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SigninscreenState();



}
class _SigninscreenState extends State<Signinscreen>{



  TextEditingController signin_gmail=TextEditingController();
  TextEditingController signin_password=TextEditingController();


  signin()async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: signin_gmail.text, password: signin_password.text);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:           Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff17181c), Color(0xff1d2e28), Color(0xff233d2f)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Lottie.asset("assets/animations/Pin code Password Protection, Secure Login animation.json",height: 300),
                    Text("Enter Your  ",style: TextStyle(color: Colors.white,fontSize: 30),),

                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [Colors.green, Colors.blue], //
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Text(
                        "Gmail & Password",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Enter your Gmail',style: TextStyle(fontSize: 20,color: Colors.white54),),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      width: 300,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color:Color(0xff4cde8d) )

                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color:Colors.black87 )
                          ),
                          prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),

                          hintText: 'Gmail',
                        ),
                        controller: signin_gmail,

                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Enter your Password',style: TextStyle(fontSize: 20,color: Colors.white54),),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      width: 300,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color:Color(0xff4cde8d) )

                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color:Colors.black87 )
                          ),
                          prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),

                          hintText: 'Password',
                        ),
                        controller: signin_password,

                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    GestureDetector(

                      child: Container(
                        padding: EdgeInsets.all(3), // ye border ki "thickness" hai
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                            padding: EdgeInsetsGeometry.all(5),
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.black87),
                            child: Center(
                              child:                  ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [Colors.green, Colors.blue], //
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  "login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                                  ),
                                ),
                              ),

                            )

                        ),
                      ),
                      onTap: (){
                        signin();

                      },
                    )






                  ],
                ),
              ),
            )




        ),
    );

  }
}