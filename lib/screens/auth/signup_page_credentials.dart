import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupCredentialsPage extends StatefulWidget {
  final TextEditingController gmailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final String? emailError;
  final String? passwordError;

  const SignupCredentialsPage({
    required this.gmailController,
    required this.passwordController,
    required this.confirmController,
    required this.emailError,
    required this.passwordError,
    super.key,
  });

  @override
  State<SignupCredentialsPage> createState() => _SignupCredentialsPageState();
}

class _SignupCredentialsPageState extends State<SignupCredentialsPage> {
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,

      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(
                height: 70,
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
                    colors: [Colors.green, Colors.blue],
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
                height: 15,
              ),

              FadeInUp(
                duration: Duration(seconds: 2),
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
                    width: double.infinity,

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.black87,
                    ),

                    child: Column(
                      children: [

                        Text(
                          'Enter your Gmail',
                          style: const TextStyle(
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
                            style: const TextStyle(
                              color: Colors.white,
                            ),

                            controller: widget.gmailController,

                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),

                                borderSide: const BorderSide(
                                  color: Color(0xff4cde8d),
                                ),
                              ),

                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),

                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),

                                borderSide: const BorderSide(
                                  color: Colors.black87,
                                ),
                              ),

                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color(0xff4cde8d),
                                size: 15,
                              ),

                              errorText: widget.emailError,

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

                        Text(
                          'Enter your Password',
                          style: const TextStyle(
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
                            controller: widget.passwordController,

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

                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),

                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),

                                borderSide: const BorderSide(
                                  color: Colors.black87,
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
                                    obscurePassword = !obscurePassword;
                                  });
                                },

                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,

                                  color: const Color(0xff4cde8d),
                                ),
                              ),

                              errorText: widget.passwordError,

                              hintText: 'Password',

                              hintStyle: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),




                        const SizedBox(
                          height: 30,
                        ),

                        Text(
                          'Confirm your Password',
                          style: const TextStyle(
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
                            controller: widget.confirmController,

                            obscureText: obscureConfirm,

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

                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),

                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),

                                borderSide: const BorderSide(
                                  color: Colors.black87,
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
                                    obscureConfirm = !obscureConfirm;
                                  });
                                },

                                icon: Icon(
                                  obscureConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,

                                  color: const Color(0xff4cde8d),
                                ),
                              ),

                              errorText: widget.passwordError,

                              hintText: 'Confirm Password',

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
              ),

              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text("Note:If You Complete Your Gmail & Password! Swipe To Next Page ", style: TextStyle(color: Colors.white,fontSize: 10,),maxLines: 2,))

            ],
          ),
        ),
      ),
    );
  }
}