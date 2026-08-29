
import 'package:flutter/material.dart';
import 'package:social_app/screens/home/home.dart';
import 'package:social_app/screens/home/search.dart';
import 'package:social_app/screens/home/profile.dart';

class BottomNav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int currentindex = 0;

  List<Widget> pages = [
    Homescreen(),
    Search(),
    Profile()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(

        children: [
          IndexedStack(
            index: currentindex,
            children: pages



          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),

                  child:Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      height: 50,
                      width: 280,

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          // color: Color(0xff4b5459)
                          color: Colors.black87
                      ),child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(child: Icon(Icons.home, color: currentindex == 0 ? Colors.white : Colors.white54,),onTap: (){
                          setState(() {
                            currentindex = 0;
                          });
                        },),
                        GestureDetector(child: Icon(Icons.search, color: currentindex == 1 ? Colors.white : Colors.white54,),onTap: (){
                          setState(() {
                            currentindex = 1;
                          });
                        },),
                        GestureDetector(child: Icon(Icons.person, color: currentindex == 2 ? Colors.white : Colors.white54,),onTap: (){
                          setState(() {
                            currentindex = 2;
                          });
                        },),




                      ],

                    ),
                    ),
                  )
                ),
              ),
            ),

          ],
      ),

    );
  }
}
