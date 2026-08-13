
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/signin.dart';
import 'package:social_app/wrapper.dart';
import 'package:social_app/loading.dart';

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



  sigup()async{
    showLoadingDialog(context);
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: gmail.text, password: password.text);
      Get.offAll(wrapper());
    }on FirebaseAuthException catch(e){
      Get.snackbar('error msg', e.code);
    }catch (e){
      Get.snackbar('error msg', e.toString());
    }
    hideLoadingDialog( context);

  }


  int currentpage=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,

        children: [
          Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff17181c), Color(0xff1d2e28), Color(0xff233d2f)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              // ===== STACK WALA HISSA (avatars) =====
              SizedBox(
                height: 470, // stack ki fixed height, avatars isi area mein rahenge
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      bottom: 0,
                      left: 100,
                      child: CircleAvatar(
                        backgroundColor: Color(0xfffecd57),
                        radius: 100,
                        child: Image.asset('assets/avatar/people.png'),
                      ),
                    ),
                    Positioned(
                      top: 65,
                      left: 30,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffe5bcb8),
                        radius: 50,
                        child: Image.asset('assets/avatar/man.png'),
                      ),
                    ),
                    Positioned(
                      top: 300,
                      left: -20,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffe16208),
                        radius: 70,
                        child: Image.asset('assets/avatar/avatar.png'),
                      ),
                    ),
                    Positioned(
                      top: 65,
                      right: -20,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffbde6ff),
                        radius: 60,
                        child: Image.asset('assets/avatar/black-man.png'),
                      ),
                    ),
                    Positioned(
                      top: 350,
                      right: 20,
                      child: CircleAvatar(
                        backgroundColor: Color(0xfff8bacc),
                        radius: 60,
                        child: Image.asset('assets/avatar/girl.png'),
                      ),
                    ),

                    Positioned(
                      top: 80,
                      right: 140,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffeed5f3),
                        radius: 5,

                      ),
                    ),


                    Positioned(
                      top: 310,
                      left: 115,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffeed5f3),
                        radius: 10,

                      ),
                    ),


                    Positioned(
                      top: 400,
                      left: 100,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffeed5f3),
                        radius: 8,

                      ),
                    ),



                    Positioned(
                      top: 150,
                      left: 80,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffeed5f3),
                        radius: 8,

                      ),
                    ),



                    Positioned(
                      top: 450,
                      right: 42,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffeed5f3),
                        radius: 8,

                      ),
                    ),


                    Positioned(
                      top: 290,
                      right: 25,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffeed5f3),
                        radius: 5,

                      ),
                    ),



                    Positioned(
                      top: 220,
                      left: 25,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffeed5f3),
                        radius: 5,

                      ),
                    ),



                  ],
                ),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
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
                    GestureDetector(
                      onTap: (){
                        pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                      },

                      child: Container(
                        padding: EdgeInsets.all(5), // ye border ki "thickness" hai
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),



                        child: Container(
                          height: 70,
                          width: 300,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              // color: Color(0xff4b5459)
                              color: Colors.black87
                          ),
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(5),
                            child: Center(
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [Colors.green, Colors.blue], //
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                          child: Text('Sign In',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
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

          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff17181c), Color(0xff1d2e28), Color(0xff233d2f)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: Column(
                  children: [
                     Lottie.asset("assets/animations/Name Profile Icon Animation Filled.json",height: 300),
                    Text("Enter Your  ",style: TextStyle(color: Colors.white,fontSize: 30),),

                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [Colors.green, Colors.blue], //
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Text(
                        "Information",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Enter your First Name',style: TextStyle(fontSize: 20,color: Colors.white54),),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      width: 300,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color:Color(0xff4cde8d) )

                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color:Colors.black87 )
                          ),
                          prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),

                          hintText: 'First Name',
                         ),
                        controller: firstname,

                        ),
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Enter your Last Name',style: TextStyle(fontSize: 20,color: Colors.white54),),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      width: 300,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color:Color(0xff4cde8d) )

                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color:Colors.black87 )
                          ),
                          prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),

                          hintText: 'Last Name',
                        ),
                        controller: lastname,

                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(

                          child: Container(
                            padding: EdgeInsets.all(3), // ye border ki "thickness" hai
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
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.black87),
                              child: Center(
                                child:                  ShaderMask(
                                  shaderCallback: (bounds) {
                                    return const LinearGradient(
                                      colors: [Colors.green, Colors.blue], //
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    "Previous",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                                    ),
                                  ),
                                ),

                              )

                            ),
                          ),
                          onTap: (){
                            pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                          },
                        ),


                        GestureDetector(

                          child: Container(
                            padding: EdgeInsets.all(3), // ye border ki "thickness" hai
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
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.black87),
                                child: Center(
                                  child:                  ShaderMask(
                                    shaderCallback: (bounds) {
                                      return const LinearGradient(
                                        colors: [Colors.green, Colors.blue], //
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds);
                                    },
                                    child: const Text(
                                      "Next",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                                      ),
                                    ),
                                  ),

                                )

                            ),
                          ),
                          onTap: (){
                            pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                          },
                        )
                      ],
                    )





                  ],
                ),
              ),
            )




                   ),



      //     3 screen
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff17181c), Color(0xff1d2e28), Color(0xff233d2f)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Lottie.asset("assets/animations/Pin code Password Protection, Secure Login animation.json",height: 300),
                      Text("Enter Your  ",style: TextStyle(color: Colors.white,fontSize: 30),),

                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Colors.green, Colors.blue], //
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Text(
                          "Gmail & Password",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Enter your Gmail',style: TextStyle(fontSize: 20,color: Colors.white54),),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        width: 300,
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color:Color(0xff4cde8d) )

                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color:Colors.black87 )
                            ),
                            prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),

                            hintText: 'Gmail',
                          ),
                          controller: gmail,

                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Enter your Password',style: TextStyle(fontSize: 20,color: Colors.white54),),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        width: 300,
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color:Color(0xff4cde8d) )

                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color:Colors.black87 )
                            ),
                            prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),

                            hintText: 'Password',
                          ),
                          controller: password,

                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(

                            child: Container(
                              padding: EdgeInsets.all(3), // ye border ki "thickness" hai
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.black87),
                                  child: Center(
                                    child:                  ShaderMask(
                                      shaderCallback: (bounds) {
                                        return const LinearGradient(
                                          colors: [Colors.green, Colors.blue], //
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds);
                                      },
                                      child: const Text(
                                        "Previous",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                                        ),
                                      ),
                                    ),

                                  )

                              ),
                            ),
                            onTap: (){
                              pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                            },
                          ),


                          GestureDetector(

                            child: Container(
                              padding: EdgeInsets.all(3), // ye border ki "thickness" hai
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.black87),
                                  child: Center(
                                    child:                  ShaderMask(
                                      shaderCallback: (bounds) {
                                        return const LinearGradient(
                                          colors: [Colors.green, Colors.blue], //
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds);
                                      },
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                                        ),
                                      ),
                                    ),

                                  )

                              ),
                            ),
                            onTap: (){
                              pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                            },
                          )
                        ],
                      )





                    ],
                  ),
                ),
              )




          ),





      //     4 screen
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff17181c), Color(0xff1d2e28), Color(0xff233d2f)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Lottie.asset("assets/animations/People reading news on phone.json",height: 300),
                      Text("Enter Your  ",style: TextStyle(color: Colors.white,fontSize: 30),),

                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Colors.green, Colors.blue], //
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Text(
                          "Username & \nPhone Number",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Enter your Username',style: TextStyle(fontSize: 20,color: Colors.white54),),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        width: 300,
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color:Color(0xff4cde8d) )

                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color:Colors.black87 )
                            ),
                            prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),

                            hintText: 'Username',
                          ),
                          controller: firstname,

                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Enter your Phone Number',style: TextStyle(fontSize: 20,color: Colors.white54),),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        width: 300,
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(

                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color:Color(0xff4cde8d) )

                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color:Colors.black87 )
                            ),
                            prefixIcon:Icon(Icons.person,color:Color(0xff4cde8d)  ,),

                            hintText: 'Phone Number (optional)',
                          ),
                          controller: lastname,

                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(

                            child: Container(
                              padding: EdgeInsets.all(3), // ye border ki "thickness" hai
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.black87),
                                  child: Center(
                                    child:                  ShaderMask(
                                      shaderCallback: (bounds) {
                                        return const LinearGradient(
                                          colors: [Colors.green, Colors.blue], //
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds);
                                      },
                                      child: const Text(
                                        "Previous",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                                        ),
                                      ),
                                    ),

                                  )

                              ),
                            ),
                            onTap: (){
                              pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                            },
                          ),


                          GestureDetector(

                            child: Container(
                              padding: EdgeInsets.all(3), // ye border ki "thickness" hai
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: Colors.black87),
                                  child: Center(
                                    child:                  ShaderMask(
                                      shaderCallback: (bounds) {
                                        return const LinearGradient(
                                          colors: [Colors.green, Colors.blue], //
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds);
                                      },
                                      child: const Text(
                                        "Create",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                                        ),
                                      ),
                                    ),

                                  )

                              ),
                            ),
                            onTap: (){
                              // pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                              sigup();
                            },
                          )
                        ],
                      )





                    ],
                  ),
                ),
              )




          ),





      ],
      ),
    );
  }
}