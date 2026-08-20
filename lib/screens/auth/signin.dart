import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/screens/auth/forgetpassword.dart';
import 'package:social_app/utils/loading_dialog.dart';
import 'package:social_app/utils/validators.dart';
import 'package:social_app/screens/auth/signup.dart';
import 'package:social_app/app/wrapper.dart';

class Signinscreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {

  TextEditingController signin_gmail = TextEditingController();
  TextEditingController signin_password = TextEditingController();

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

                child: Text(
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
              // GMAIL & PASSWORD
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

                child: Text(
                  "Gmail & Password",
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
              // LOGIN BOX
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
                      // GMAIL
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

                      SizedBox(
                        width: 300,

                        child: TextField(
                          controller: signin_gmail,

                          style: const TextStyle(
                            color: Colors.white,
                          ),

                          decoration: InputDecoration(

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                              borderSide: const BorderSide(
                                color: Color(0xff4cde8d),
                              ),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                              borderSide: const BorderSide(
                                color: Colors.black87,
                              ),
                            ),

                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                              borderSide: const BorderSide(
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

                      const SizedBox(
                        height: 30,
                      ),

                      // =========================
                      // PASSWORD
                      // =========================

                      const Text(
                        'Enter your Password',

                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white54,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      SizedBox(
                        width: 300,

                        child: TextField(
                          controller: signin_password,

                          obscureText: obscurePassword,

                          style: const TextStyle(
                            color: Colors.white,
                          ),

                          decoration: InputDecoration(

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                              borderSide: const BorderSide(
                                color: Color(0xff4cde8d),
                              ),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                              borderSide: const BorderSide(
                                color: Colors.black87,
                              ),
                            ),

                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),

                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xff4cde8d),
                              size: 15,
                            ),

                            // 👁 SHOW / HIDE PASSWORD
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword =
                                  !obscurePassword;
                                });
                              },

                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,

                                color: const Color(0xff4cde8d),
                                size: 15,
                              ),
                            ),

                            errorText: passwordError,

                            hintText: 'Password',

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
                height: 15,
              ),

              // =========================
              // FORGET PASSWORD
              // =========================

              GestureDetector(
                onTap: () {
                  Get.to(() => Forgetpassword());
                },

                child: const Text(
                  'Forget Password ?',

                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              // =========================
              // BACK + LOGIN
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
                            () => SignupScreen(),
                        transition: Transition.fadeIn,
                        duration:
                        const Duration(milliseconds: 400),
                      );
                    },

                    child: Container(
                      padding: const EdgeInsets.all(1),

                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(40),

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

                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },

                            child: const Text(
                              "Back",

                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // =========================
                  // LOGIN BUTTON
                  // =========================

                  GestureDetector(
                    onTap: () {
                      signin();
                    },

                    child: Container(
                      padding: const EdgeInsets.all(1),

                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(40),

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

                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },

                            child: const Text(
                              "Sign In",

                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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