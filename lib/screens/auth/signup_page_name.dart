import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupNamePage extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String? nameError;
  final String? lastNameError;

  const SignupNamePage({
    required this.firstNameController,
    required this.lastNameController,
    required this.nameError,
    required this.lastNameError,
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
                },child: Text(
                "Vibely",style: GoogleFonts.angkor(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

              ),

              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "Enter Your  ",
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
                  "Information",
                  style: GoogleFonts.cherryCreamSoda(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // Information Box
              FadeInUp(
                duration:Duration(seconds:2),
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
                          'Enter your First Name',
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

                              errorText: nameError,

                              hintText: 'First Name',
                              hintStyle: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),

                            controller: firstNameController,
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Text(
                          'Enter your Last Name',
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

                              errorText: lastNameError,

                              hintText: 'Last Name',
                              hintStyle: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),

                            controller: lastNameController,
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
                  child: Text("Note:If You Complete Your Information! Swipe To Next Page ", style: TextStyle(color: Colors.white,fontSize: 10,),maxLines: 2,))

            ],
          ),
        ),
      ),
    );
  }
}