import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/screens/auth/forgetpassword.dart';
import 'package:social_app/utils/loading_dialog.dart';
import 'package:social_app/utils/validators.dart';
import 'package:social_app/screens/auth/signup.dart';
import 'package:social_app/app/wrapper.dart';
import 'package:social_app/widgets/bottomsheet_widget.dart';

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});
  @override
  State<StatefulWidget> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {

  TextEditingController signinGmail = TextEditingController();
  TextEditingController signinPassword = TextEditingController();

  String? emailError;
  String? passwordError;

  bool obscurePassword = true;


  String getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  Future<void> signin() async {
    setState(() {
      emailError = Validators.validateEmail(signinGmail.text);
      passwordError = Validators.validatePassword(signinPassword.text);
    });

    if (emailError != null || passwordError != null) return;

    showLoadingDialog(context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinGmail.text,
        password: signinPassword.text,
      );

      if (!mounted) return;
      hideLoadingDialog(context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthWrapper()),
            (route) => false,
      );

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      hideLoadingDialog(context);
      showMessageSheet(
          context,
          icon: Icons.error_outline,
          iconColor: Colors.red,
          title: "Login failed",
          message: getAuthErrorMessage(e.code)
      );

    } catch (e) {
      if (!mounted) return;
      hideLoadingDialog(context);
      showMessageSheet(
          context,
          icon: Icons.error_outline,
          iconColor: Colors.red,
          title: "Login failed",
          message: e.toString()
      );
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



              Text(
                "Enter Your",
                style: GoogleFonts.cherryCreamSoda(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),



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
                          controller: signinGmail,

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
                          controller: signinPassword,

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



              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: Forgetpassword(),
                      duration: Duration(milliseconds: 400),
                    ),
                  );
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



              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [



                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: SignupScreen(),
                          duration: Duration(milliseconds: 400),
                        ),
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