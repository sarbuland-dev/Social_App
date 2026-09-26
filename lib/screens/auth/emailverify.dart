import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/screens/auth/signup.dart';
import 'package:social_app/app/wrapper.dart';
import 'package:social_app/widgets/bottomsheet_widget.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<StatefulWidget> createState() => VerifyState();
}

class VerifyState extends State<Verify> {

  bool linkSent = false;

  @override
  void initState() {
    super.initState();
    if (!linkSent) {
      sendverifylink();
      linkSent = true;
    }
  }



  Future<void> sendverifylink() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      if (!mounted) return;
      showMessageSheet(
        context,
        icon: Icons.email,
        iconColor: Colors.green,
        title: "Link Sent!",
        message: "Link Sent To Your ${user.email} For Verification",
      );

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showMessageSheet(
        context,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        title: "Failed to send link",
        message: e.message ?? e.code,
      );
    }
  }

  Future<void> reload() async {
    await FirebaseAuth.instance.currentUser!.reload();
    User? refreshedUser = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (refreshedUser != null && refreshedUser.emailVerified) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthWrapper()),
            (route) => false,
      );
    } else {
      showMessageSheet(
        context,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        title: "Not Verified!",
        message: "Verify Your Email First",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(height: 30),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [Colors.green, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                "Verification",
                style: GoogleFonts.cherryCreamSoda(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Open your mail and click on the link provided to verify email & reload this page",
                style: TextStyle(color: Colors.white, fontSize: 30),
                maxLines: 4,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(1),
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.black87),
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
                              "back",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                    ),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                          (route) => false,
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(3),
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.black87),
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
                              "Reload",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                    ),
                  ),
                  onTap: () {
                    reload();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}