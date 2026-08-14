import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/home.dart';
import 'package:social_app/signup.dart';
import 'package:social_app/wrapper.dart';
class Verify extends StatefulWidget{
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

// sendverifylink()async{
//     final user= FirebaseAuth.instance.currentUser!;
//     await user.sendEmailVerification().then((value) => {
//       Get.snackbar("Link Send", "A link has been send to your Email",margin: EdgeInsets.all(20),snackPosition: SnackPosition.TOP)
//     });
// }





  sendverifylink() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      Get.snackbar("Link Sent", "A link has been sent to your Email",
          margin: EdgeInsets.all(20), snackPosition: SnackPosition.TOP);
    } on FirebaseAuthException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
    }
  }



  reload() async {
    await FirebaseAuth.instance.currentUser!.reload();
    User? refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null && refreshedUser.emailVerified) {
      Get.offAll(() => wrapper());   // naya wrapper instance -> naya StreamBuilder subscribe -> fresh data
    } else {
      Get.snackbar("Not Verified", "Verify your Email first",
          margin: EdgeInsets.all(20), snackPosition: SnackPosition.TOP);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [Colors.green, Colors.blue], //
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Text(
                "Verification",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // IMPORTANT: white rakhna zaroori hai
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("Open your mail\n and click on the link \nprovided to verify \nemail & reload this page",style: TextStyle(color: Colors.white,fontSize: 30),),
            SizedBox(
              height: 30,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [GestureDetector(

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
                            "back",
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
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(() => SignupScreen());


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
                              "Reload",
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
                    reload();


                  },
                )
  ])
          ],
        ),
      ),
    );
  }


}