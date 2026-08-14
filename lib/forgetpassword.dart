
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/loading.dart';
import 'package:social_app/signin.dart';
import 'package:social_app/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
class Forgetpassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ForgetpasswordState();



}
class _ForgetpasswordState extends State<Forgetpassword>{



  TextEditingController forget_gmail=TextEditingController();
  String? emailError;




  reset()async{

    setState(() {
      emailError = Validators.validateEmail(forget_gmail.text);

    });

    if (emailError != null) return;




    showLoadingDialog(context);


    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: forget_gmail.text );
      hideLoadingDialog( context);
      // Navigator.push(context, MaterialPageRoute(builder:(context)=> Homescreen()));

    }on FirebaseAuthException catch(e){
      hideLoadingDialog( context);
      Get.snackbar('error msg', e.code);

    }catch(e){
      hideLoadingDialog( context);
      Get.snackbar('error msg', e.toString());


    }











  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
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
                  height: 30,
                ),
                Lottie.asset("assets/animations/Forget password animation.json",height: 300),
                SizedBox(
                  height: 10,
                ),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Colors.green, Colors.blue], //
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "Reset Password",
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),
                      errorText: emailError,

                      hintText: 'Gmail',
                    ),
                    controller: forget_gmail,

                  ),
                ),
                SizedBox(
                  height: 20,
                ),



                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                    "back",
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
                          // Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                          Get.to(() => Signinscreen(), transition: Transition.fadeIn, duration: Duration(milliseconds: 400));


                        },
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
                          reset();


                        },
                      ),

                    ])
              ],
            ),
          ),
        )

    ));

  }}

