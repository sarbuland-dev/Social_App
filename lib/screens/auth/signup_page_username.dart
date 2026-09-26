import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupUsernamePage extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController phoneController;
  final String? phoneError;
  final bool isCreatingAccount;
  final VoidCallback onCreateAccount;

  const SignupUsernamePage({
    required this.usernameController,
    required this.phoneController,
    required this.phoneError,
    required this.isCreatingAccount,
    required this.onCreateAccount,
    super.key,
  });

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
                height: 100,
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
                  "Username & Phone",
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
                          'Enter your Username',
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
                            controller: usernameController,

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
                                Icons.person,
                                color: Color(0xff4cde8d),
                                size: 15,
                              ),

                              hintText: 'Username',

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
                          'Enter your Phone Number',
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
                            controller: phoneController,

                            keyboardType: TextInputType.phone,

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
                                Icons.phone,
                                color: Color(0xff4cde8d),
                                size: 15,
                              ),

                              errorText: phoneError,

                              hintText: 'Phone Number (optional)',

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

              const SizedBox(
                height: 40,
              ),

              // ---------------- Create Account button ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: isCreatingAccount
                          ? null
                          : () {
                        onCreateAccount();
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
                          padding: const EdgeInsets.all(5),
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black87,
                          ),
                          child: Center(
                            child: isCreatingAccount
                                ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                                : ShaderMask(
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                  colors: [Colors.green, Colors.blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: const Text(
                                "Create",
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}