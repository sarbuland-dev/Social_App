import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/utils/loading_dialog.dart';
import 'package:social_app/screens/auth/signin.dart';
import 'package:social_app/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/services/firestore_service.dart';
import 'package:social_app/widgets/bottomsheet_widget.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<StatefulWidget> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {

  TextEditingController forgetGmail = TextEditingController();
  String? emailError;

  Future<void> reset() async {
    setState(() {
      emailError = Validators.validateEmail(forgetGmail.text);
    });

    if (emailError != null) return;

    showLoadingDialog(context);

    try {
      final email = forgetGmail.text.trim();

      final emailExists = await FirestoreService().checkEmailExists(email);

      if (!mounted) return;

      if (!emailExists) {
        hideLoadingDialog(context);
        showMessageSheet(
          context,
          icon: Icons.error_outline,
          iconColor: Colors.red,
          title: "No account found",
          message: "Is email se koi account register nahi hai.",
        );
        return;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;
      hideLoadingDialog(context);

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.mark_email_read_outlined,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Reset Link Sent!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We've sent a password reset link to\n${forgetGmail.text}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Please check your inbox and follow the link to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      hideLoadingDialog(context);
      showMessageSheet(
        context,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        title: "Login failed",
        message: e.code,
      );
    } catch (e) {
      if (!mounted) return;
      hideLoadingDialog(context);
      showMessageSheet(
        context,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        title: "Login failed",
        message: e.toString(),
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
              const SizedBox(height: 100),
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [Colors.green, Colors.blue],
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
              const SizedBox(height: 10),
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
                    colors: [Colors.green, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  "Reset Password",
                  style: GoogleFonts.cherryCreamSoda(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.blue],
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
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: forgetGmail,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xff4cde8d)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.black87),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            prefixIcon: const Icon(Icons.email, color: Color(0xff4cde8d), size: 15),
                            errorText: emailError,
                            hintText: 'Gmail',
                            hintStyle: const TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Forgot your password? Don't worry! Enter your email and we'll help you get back into your Vibely account.",
                style: TextStyle(color: Colors.white54, fontSize: 15),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: Signinscreen(),
                          duration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.black87,
                        ),
                        child: Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [Colors.green, Colors.blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: const Text(
                              "Back",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      reset();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.black87,
                        ),
                        child: Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [Colors.green, Colors.blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: const Text(
                              "Reset",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

