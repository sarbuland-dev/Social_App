
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/utils/loading_dialog.dart';
import 'package:social_app/screens/auth/signin.dart';
import 'package:social_app/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
class Forgetpassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ForgetpasswordState();



}
class _ForgetpasswordState extends State<Forgetpassword> {


  TextEditingController forget_gmail = TextEditingController();
  String? emailError;


  reset() async {
    setState(() {
      emailError = Validators.validateEmail(forget_gmail.text);
    });

    if (emailError != null) return;


    showLoadingDialog(context);


    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: forget_gmail.text);
      hideLoadingDialog(context);
      // Navigator.push(context, MaterialPageRoute(builder:(context)=> Homescreen()));

    } on FirebaseAuthException catch (e) {
      hideLoadingDialog(context);
      Get.snackbar('error msg', e.code);
    } catch (e) {
      hideLoadingDialog(context);
      Get.snackbar('error msg', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const SizedBox(
                height: 100,
              ),

              // =========================
              // VIBELY
              // =========================

              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.blue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },

                child:  Text(
                  "Vibely",

                  style: GoogleFonts.angkor(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // =========================
              // ENTER YOUR
              // =========================

               Text(
                "Enter Your",

                style: GoogleFonts.cherryCreamSoda(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),

              // =========================
              // RESET PASSWORD
              // =========================

              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.blue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },

                child:  Text(
                  "Reset Password",

                  style: GoogleFonts.cherryCreamSoda(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // =========================
              // GMAIL BOX
              // =========================

              Container(
                padding: const EdgeInsets.all(1),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),

                  gradient: const LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.blue,
                    ],

                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.black87,
                  ),

                  child: Column(
                    children: [

                      // =========================
                      // GMAIL TEXT
                      // =========================

                      const Text(
                        'Enter your Gmail',

                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white54,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // =========================
                      // GMAIL TEXTFIELD
                      // =========================

                      SizedBox(
                        width: 300,

                        child: TextField(
                          controller: forget_gmail,

                          style: const TextStyle(
                            color: Colors.white,
                          ),

                          decoration: InputDecoration(

                            focusedBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(20),

                              borderSide:
                              const BorderSide(
                                color: Color(0xff4cde8d),
                              ),
                            ),

                            enabledBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(20),

                              borderSide:
                              const BorderSide(
                                color: Colors.black87,
                              ),
                            ),

                            errorBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(20),

                              borderSide:
                              const BorderSide(
                                color: Colors.red,
                              ),
                            ),

                            prefixIcon: const Icon(
                              Icons.email,

                              color: Color(0xff4cde8d),
                              size: 15,
                            ),

                            errorText: emailError,

                            hintText: 'Gmail',

                            hintStyle: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Text("Forgot your password? Don't worry! Enter your email and we'll help you get back into your Vibely account.",style: TextStyle(
                color: Colors.white54,
                fontSize: 15,

              ),maxLines: 3,),
              SizedBox(
                height: 20,
              ),

              // =========================
              // BACK + RESET BUTTON
              // =========================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  // =========================
                  // BACK BUTTON
                  // =========================

                  GestureDetector(
                    onTap: () {
                      Get.to(
                            () => Signinscreen(),

                        transition:
                        Transition.fadeIn,

                        duration:
                        const Duration(
                          milliseconds: 400,
                        ),
                      );
                    },

                    child: Container(
                      padding:
                      const EdgeInsets.all(1),

                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(40),

                        gradient:
                        const LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.blue,
                          ],

                          begin:
                          Alignment.topLeft,

                          end:
                          Alignment.bottomRight,
                        ),
                      ),

                      child: Container(
                        width: 60,
                        height: 60,

                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(40),

                          color: Colors.black87,
                        ),

                        child: Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  Colors.green,
                                  Colors.blue,
                                ],

                                begin:
                                Alignment.topLeft,

                                end:
                                Alignment.bottomRight,
                              ).createShader(bounds);
                            },

                            child: const Text(
                              "Back",

                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // =========================
                  // RESET BUTTON
                  // =========================

                  GestureDetector(
                    onTap: () {
                      reset();
                    },

                    child: Container(
                      padding:
                      const EdgeInsets.all(1),

                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(40),

                        gradient:
                        const LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.blue,
                          ],

                          begin:
                          Alignment.topLeft,

                          end:
                          Alignment.bottomRight,
                        ),
                      ),

                      child: Container(
                        width: 100,
                        height: 60,

                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(40),

                          color: Colors.black87,
                        ),

                        child: Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  Colors.green,
                                  Colors.blue,
                                ],

                                begin:
                                Alignment.topLeft,

                                end:
                                Alignment.bottomRight,
                              ).createShader(bounds);
                            },

                            child: const Text(
                              "Reset",

                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

