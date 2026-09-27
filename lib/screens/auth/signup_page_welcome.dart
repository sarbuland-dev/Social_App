import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/screens/auth/signin.dart';

class SignupWelcomePage extends StatelessWidget {
  const SignupWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.only(top: 150),

      child: Column(
        children: [
          Text('Welcome To',style:GoogleFonts.cherryCreamSoda(
              fontSize: 20,
              color: Colors.white

          )),
          SizedBox(
            height: 10,
          ),
          JelloIn(
            duration: Duration(seconds: 4),
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [Colors.green, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },child: Text("Vibely",style: GoogleFonts.angkor(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
            ),
          ),

          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  'Makes Friend\naround the World',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.agbalumo(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30

                  ),

                ),
                SizedBox(height: 12),
                Text(
                  'Make friends around the world and discover new cultures, ideas, and smiles—no matter the distance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 20
                  ,
                ),
                Text(
                  'Swipe To\nMake Your Account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cherryCreamSoda(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 25

                  ),

                ),

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',style: TextStyle(color: Colors.white70,fontSize: 15),),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: Signinscreen(),
                            duration: Duration(milliseconds: 400),
                          ),
                        );

                      },
                      child:               ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Colors.green, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },child: Text("Sign In",style:TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
                      ),
                    )
                  ],
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}