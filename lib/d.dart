// import 'package:flutter/material.dart';
//
//
//
//
//
//
//
//
// class loginScreen extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => loginScreenState() ;
//
// }
// class loginScreenState extends State<loginScreen>{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [Color(0xff17181c),Color(0xff1d2e28),Color(0xff233d2f)],
//           begin: AlignmentGeometry.bottomEnd,end: AlignmentGeometry.topCenter)
//         ),
//         child:
//             Stack(
//             children: [
//               Positioned(
//                 top: 200,
//                   bottom: 540,
//                   // right: 200,
//                   left: 140,
//
//                   child: CircleAvatar(backgroundColor: Colors.amber,radius: 100,child:
//                     Image.asset('assets/avatar/manager.png')
//
//
//                   )
//               ),
//               Positioned(
//                   top: 80,
//
//                   // right: 200,
//                   left: 50,
//
//                   child: CircleAvatar(backgroundColor: Colors.amber,radius: 50,child:
//                   Image.asset('assets/avatar/man.png')
//
//
//                   )
//               ),
//
//               Positioned(
//                   top: 400,
//
//                   bottom: 400,
//                   left: -20,
//
//                   child: CircleAvatar(backgroundColor: Color(0xffe16208),radius: 70,child:
//                   Image.asset('assets/avatar/avatar.png')
//
//
//                   )
//               ),
//
//
//               Positioned(
//                   top: 100,
//
//
//                   right: -20,
//
//                   child: CircleAvatar(backgroundColor: Color(0xffe16208),radius: 60,child:
//                   Image.asset('assets/avatar/black-man.png')
//
//
//                   )
//               ),
//
//
//               Positioned(
//                   top: 400,
//                   bottom: 420,
//
//
//                   right: 20,
//
//                   child: CircleAvatar(backgroundColor: Color(0xffe16208),radius: 60,child:
//                   Image.asset('assets/avatar/girl.png')
//
//
//                   )
//               ),
//
//
//
//
//
//
//             ],
//           ),
//
//
//     ),
//
//
//       );
//
//
//
//
//   }
//
// }






























import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => loginScreenState();
}

class loginScreenState extends State<loginScreen> {
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
                  Container(
                    height: 70,
                    width: 300,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0xff4b5459)
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xff4cde8d),
                            child: Icon(Icons.person,color: Colors.black,),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Get Start',style: TextStyle(color: Colors.white,fontSize: 20),),
                          SizedBox(
                            width: 60,
                          ),
                          Text('>>',style: TextStyle(color: Colors.white,fontSize: 25),),


                        ],
                      
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
                        onTap: (){},
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
    );
  }
}