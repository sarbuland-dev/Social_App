import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/screens/auth/signin.dart';
import 'package:social_app/app/wrapper.dart';
import 'package:social_app/utils/loading_dialog.dart';
import 'package:social_app/utils/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/widgets/bootomsheet_widget.dart';


class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  PageController pageController=PageController(initialPage: 0);

  TextEditingController firstname=TextEditingController();
  TextEditingController lastname=TextEditingController();
  TextEditingController gmail=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController username=TextEditingController();
  TextEditingController confirmpass=TextEditingController();

  String? NameError;
  String? LastNameError;
  String? emailError;
  String? passwordError;
  String? phoneError;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  bool isCreatingAccount = false;


  validateAndCreateAccount() {
    setState(() {
      emailError = Validators.validateEmail(gmail.text);
      passwordError = Validators.validatePassword(password.text);
      NameError = Validators.validateName(firstname.text);
      LastNameError = Validators.validateName(lastname.text);

    });


    if (NameError != null || LastNameError != null) {
      pageController.jumpToPage(1);
      return;
    }

    if (emailError != null || passwordError != null) {
      pageController.jumpToPage(2);
      return;
    }



    sigup();
  }


  sigup() async {
    if (confirmpass.text != password.text) {
      showMessageSheet(
        context,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        title: "Password doesn't match",
        message: "Please enter the same password in both fields.",
      );


      return;
    }

    setState(() {
      isCreatingAccount = true;
    });

    try {

      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where(
        'username',
        isEqualTo: username.text.trim(),
      )
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        setState(() {
          isCreatingAccount = false;
        });

        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Try new User Name",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "User Name Already taken.",
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),

                  SizedBox(height: 10),
                ],
              ),
            );
          },
        );

        return;
      }

      // showLoadingDialog(context);

      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: gmail.text,
        password: password.text,
      );
      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'firstname': firstname.text,
        'lastname': lastname.text,
        'email': gmail.text,
        'username': username.text,
        'phone': phone.text,
        'profileImageUrl': '',
        'bio': '',
        'profileSetupDone': false,
      });

      // hideLoadingDialog(context);
      Get.offAll(wrapper());
    } on FirebaseAuthException catch (e) {
      // hideLoadingDialog(context);
      setState(() {
        isCreatingAccount = false;
      });
      Get.snackbar('error msg', e.message ?? e.code);
    } catch (e) {
      hideLoadingDialog(context);
      setState(() {
        isCreatingAccount = false;
      });


      showMessageSheet(
        context,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        title: "SignUp  failed",
        message: e.toString(),
      );
    }
  }


  int currentpage=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,


      body: PageView(
          controller: pageController,

          onPageChanged: (index) {
            setState(() {
              currentpage = index;
            });
          },

          children: [
            // ---------------- PAGE 0: Welcome ----------------
            Container(
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
                          colors: [Colors.green, Colors.blue], //
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
                                    colors: [Colors.green, Colors.blue], //
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
            ),

            // ---------------- PAGE 1: First/Last Name ----------------
            Container(
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
                            colors: [Colors.green, Colors.blue], //
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

                                      errorText: NameError,

                                      hintText: 'First Name',
                                      hintStyle: const TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),

                                    controller: firstname,
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

                                      errorText: LastNameError,

                                      hintText: 'Last Name',
                                      hintStyle: const TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),

                                    controller: lastname,
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
            ),

            // ---------------- PAGE 2: Gmail & Password ----------------
            Container(
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

                                    controller: gmail,

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
                                    controller: password,

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

                                      errorText: passwordError,

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
                                    controller:confirmpass,

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

                                      errorText: passwordError,

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
            ),

            // ---------------- PAGE 3: Username & Phone (last page — account create yahin hota hai) ----------------
            Container(
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
                                    controller: username,

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
                                    controller: phone,

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
                                validateAndCreateAccount();
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
            ),

          ],
        ),


    );
  }
}