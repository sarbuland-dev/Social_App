
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/screens/auth/signin.dart';
import 'package:social_app/app/wrapper.dart';
import 'package:social_app/utils/loading_dialog.dart';
import 'package:social_app/utils/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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








  String? NameError;
  String? LastNameError;
  String? emailError;
  String? passwordError;
  String? phoneError;
  bool obscurePassword = true;



  sigup()async{
    setState(() {
      emailError = Validators.validateEmail(gmail.text);
      passwordError = Validators.validatePassword(password.text);
      NameError = Validators.validateName(firstname.text);
      LastNameError = Validators.validateName(lastname.text);
      phoneError = Validators.validatePhone(phone.text);
    });


    // Page 2 errors (Name)
    if (NameError != null || LastNameError != null) {
      pageController.jumpToPage(1);
      return;
    }
    // Page 3 errors (Gmail/Password)
    if (emailError != null || passwordError != null) {
      pageController.jumpToPage(2);
      return;
    }
    // Page 4 errors (Username/Phone)
    if (NameError != null || phoneError != null) {
      return; // already yahi page pe hain
    }




    showLoadingDialog(context);
    try{
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: gmail.text,
        password: password.text,
      );
      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        'firstname': firstname.text,
        'lastname': lastname.text,
        'email': gmail.text,
        'username': username.text,
        'phone': phone.text,
      });


      hideLoadingDialog( context);
      Get.offAll(wrapper());
      // Get.back();
    }on FirebaseAuthException catch(e){
      hideLoadingDialog( context);
      // Get.back();
      Get.snackbar('error msg', e.code);
    }catch (e){
      hideLoadingDialog( context);
      // Get.back();
      Get.snackbar('error msg', e.toString());
    }


  }


  int currentpage=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          PageView(
            controller: pageController,

            onPageChanged: (index) {
              setState(() {
                currentpage = index;
              });
            },

            children: [
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
                    ShaderMask(
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


                    // ===== TEXT WALA HISSA =====
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            'Makes Friend\naround the World',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cherryCreamSoda(
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
                                  Navigator.push(context,  MaterialPageRoute(builder: (context) => Signinscreen()),);
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

              // second page
              // second page
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

                        const SizedBox(
                          height: 40,
                        ),


                      ],
                    ),
                  ),
                ),
              ),





              //     3 screen
              // third page
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

                        // Vibely
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

                        // Enter Your
                        Text(
                          "Enter Your",
                          style: GoogleFonts.cherryCreamSoda(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),

                        // Gmail & Password
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
                          height: 20,
                        ),

                        // Gmail & Password Box
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

                                // Gmail Text
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

                                // Gmail TextField
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

                                // Password Text
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

                                // Password TextField
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

                                      // 👁 Password show/hide
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
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),

                        // Previous / Next Buttons

                      ],
                    ),
                  ),
                ),
              ),






              //     4 screen
              // fourth page
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

                        // Vibely
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

                        // Enter Your
                        Text(
                          "Enter Your",
                          style: GoogleFonts.cherryCreamSoda(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),

                        // Username & Phone
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

                        // Username & Phone Box
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

                                // Username
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

                                // Phone
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

                        const SizedBox(
                          height: 40,
                        ),

                        // Previous / Create Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            // Previous


                            // Create
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  sigup();
                                },

                                child: Container(
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
                                    padding: const EdgeInsets.all(5),

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
                                            colors: [
                                              Colors.green,
                                              Colors.blue,
                                            ],

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


          Positioned(
            bottom: 100,
              left: 130,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children:List.generate(4, (index){
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),

                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),

                      height: 8,
                      width: currentpage == index ? 25 : 8,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),

                        gradient: const LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.blue,
                          ],
                        ),
                      ),
                    );
                  })
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    currentpage == 3
                        ? "Swipe to go back"
                        : "Swipe to continue →",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                )
              ],
            ),

          ),





        ],
      ),
    );
  }
}




















//
// SizedBox(
// height: 470, // stack ki fixed height, avatars isi area mein rahenge
// child: Stack(
// children: [
// Positioned(
// top: 40,
// bottom: 0,
// left: 100,
// child: CircleAvatar(
// backgroundColor: Color(0xfffecd57),
// radius: 100,
// child: Image.asset('assets/avatar/people.png'),
// ),
// ),
// Positioned(
// top: 65,
// left: 30,
// child: CircleAvatar(
// backgroundColor: Color(0xffe5bcb8),
// radius: 50,
// child: Image.asset('assets/avatar/man.png'),
// ),
// ),
// Positioned(
// top: 300,
// left: -20,
// child: CircleAvatar(
// backgroundColor: Color(0xffe16208),
// radius: 70,
// child: Image.asset('assets/avatar/avatar.png'),
// ),
// ),
// Positioned(
// top: 65,
// right: -20,
// child: CircleAvatar(
// backgroundColor: Color(0xffbde6ff),
// radius: 60,
// child: Image.asset('assets/avatar/black-man.png'),
// ),
// ),
// Positioned(
// top: 350,
// right: 20,
// child: CircleAvatar(
// backgroundColor: Color(0xfff8bacc),
// radius: 60,
// child: Image.asset('assets/avatar/girl.png'),
// ),
// ),
//
// Positioned(
// top: 80,
// right: 140,
// child: CircleAvatar(
// backgroundColor: Color(0xffeed5f3),
// radius: 5,
//
// ),
// ),
//
//
// Positioned(
// top: 310,
// left: 115,
// child: CircleAvatar(
// backgroundColor: Color(0xffeed5f3),
// radius: 10,
//
// ),
// ),
//
//
// Positioned(
// top: 400,
// left: 100,
// child: CircleAvatar(
// backgroundColor: Color(0xffeed5f3),
// radius: 8,
//
// ),
// ),
//
//
//
// Positioned(
// top: 150,
// left: 80,
// child: CircleAvatar(
// backgroundColor: Color(0xffeed5f3),
// radius: 8,
//
// ),
// ),
//
//
//
// Positioned(
// top: 450,
// right: 42,
// child: CircleAvatar(
// backgroundColor: Color(0xffeed5f3),
// radius: 8,
//
// ),
// ),
//
//
// Positioned(
// top: 290,
// right: 25,
// child: CircleAvatar(
// backgroundColor: Color(0xffeed5f3),
// radius: 5,
//
// ),
// ),
//
//
//
// Positioned(
// top: 220,
// left: 25,
// child: CircleAvatar(
// backgroundColor: Color(0xffeed5f3),
// radius: 5,
//
// ),
// ),
//
//
//
// ],
// ),
// ),






// width: double.infinity,
// height: double.infinity,
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [Color(0xff17181c), Color(0xff1d2e28), Color(0xff233d2f)],
// begin: Alignment.bottomCenter,
// end: Alignment.topCenter,
// ),
// ),









// Text('Enter your First Name',style: TextStyle(fontSize: 20,color: Colors.white54),),
// SizedBox(
// height: 10,
// ),
//
// Container(
// width: 300,
// child: TextField(
// style: TextStyle(color: Colors.white),
// decoration: InputDecoration(
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(20),
// borderSide: BorderSide(color:Color(0xff4cde8d) )
//
// ),
// errorBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(20),
// borderSide: BorderSide(color: Colors.red),
// ),
// enabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(20),
// borderSide: BorderSide(color:Colors.black87 )
// ),
// prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),
// errorText: NameError,
//
// hintText: 'First Name',
// ),
// controller: firstname,
//
// ),
// ),
// SizedBox(
// height: 30,
// ),
// Text('Enter your Last Name',style: TextStyle(fontSize: 20,color: Colors.white54),),
// SizedBox(
// height: 10,
// ),
//
// Container(
// width: 300,
// child: TextField(
// style: TextStyle(color: Colors.white),
// decoration: InputDecoration(
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(20),
// borderSide: BorderSide(color:Color(0xff4cde8d) )
//
// ),
// errorBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(20),
// borderSide: BorderSide(color: Colors.red),
// ),
// enabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(20),
// borderSide: BorderSide(color:Colors.black87 )
// ),
// prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),
// errorText: LastNameError,
//
// hintText: 'Last Name',
// ),
// controller: lastname,
//
// ),
// ),