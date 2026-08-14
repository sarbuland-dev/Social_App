
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/forgetpassword.dart';
import 'package:social_app/home.dart';
import 'package:social_app/loading.dart';
import 'package:social_app/validations.dart';
import 'package:social_app/signup.dart';
import 'package:social_app/wrapper.dart';



class Signinscreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SigninscreenState();



}
class _SigninscreenState extends State<Signinscreen>{



  TextEditingController signin_gmail=TextEditingController();
  TextEditingController signin_password=TextEditingController();


  String? emailError;
  String? passwordError;
  bool obscurePassword = true;







  signin() async {
    setState(() {
      emailError = Validators.validateEmail(signin_gmail.text);
      passwordError = Validators.validatePassword(signin_password.text);
    });

    if (emailError != null || passwordError != null) return;

    showLoadingDialog(context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signin_gmail.text,
        password: signin_password.text,
      );
      hideLoadingDialog(context);
      Get.offAll(() => wrapper());

    } on FirebaseAuthException catch (e) {
      hideLoadingDialog(context);   // ye add karo
      Get.snackbar('error msg', e.code);
    } catch (e) {
      hideLoadingDialog(context);   // ye bhi add karo
      Get.snackbar('error msg', e.toString());
    }
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
                      height: 5,
                    ),
                    Lottie.asset("assets/animations/Employee content.json",height: 300),
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),
                          errorText: emailError,

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
                        obscureText: obscurePassword,
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
                          suffixIcon: IconButton(onPressed: (){
                            setState(() {
                              obscurePassword=!obscurePassword;
                            });
                          }, icon: Icon(          obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Color(0xff4cde8d),)),


                          errorText: passwordError,



                          hintText: 'Password',
                        ),
                        controller: signin_password,





                      ),
                    ),
                    SizedBox(
                      height: 10,

                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(()=>Forgetpassword());
                      },
                      child: Text('Forget Password ?',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600 ),),
                    ),
                    SizedBox(
                      height: 30,
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
                            Get.to(() => SignupScreen(), transition: Transition.fadeIn, duration: Duration(milliseconds: 400));


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
                          signin();
                      
                      
                        },
                      ),
                        
                    ])






                  ],
                ),
              ),
            )




        ),
    );

  }
}