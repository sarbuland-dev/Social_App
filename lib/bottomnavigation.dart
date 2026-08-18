import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/home.dart';

class BottomNav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int currentindex = 0;

  List<Widget> pages = [
    Homescreen(),
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

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: .15))

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(child: Icon(Icons.home, color: currentindex == 0 ? Colors.white : Colors.black87,),onTap: (){
                              setState(() {
                                currentindex==0;
                              });
                            },),
                            GestureDetector(child: Icon(Icons.search, color: currentindex == 1 ? Colors.white : Colors.black87,),onTap: (){
                              setState(() {
                                currentindex==1;
                              });
                            },),
                            GestureDetector(child: Icon(Icons.person, color: currentindex == 2 ? Colors.white : Colors.black87,),onTap: (){
                              setState(() {
                                currentindex==2;
                              });
                            },),


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
      ),

    );
  }
}
















//
// extendBody: true,
// body: IndexedStack(
// index: currentindex,
// children: pages,
// ),
// bottomNavigationBar: Container(
// padding: const EdgeInsets.all(3), // gradient border ki "thickness"
// decoration: BoxDecoration(
// borderRadius: const BorderRadius.only(
// topLeft: Radius.circular(25),
// topRight: Radius.circular(25),
// bottomLeft: Radius.circular(25),
// bottomRight: Radius.circular(25)
// ),
// gradient: const LinearGradient(
// colors: [Colors.green, Colors.blue],
// begin: Alignment.topLeft,
// end: Alignment.bottomRight,
// ),
// ),
// child: ClipRRect(
// borderRadius:  BorderRadius.only(
// topLeft: Radius.circular(25), // outer se thora kam
// topRight: Radius.circular(25),
// bottomLeft: Radius.circular(25), // outer se thora kam
// bottomRight: Radius.circular(25),
// ),
// child: SizedBox(
// height: 100,
// child: BottomNavigationBar(
// backgroundColor: Colors.black87,
//
// selectedItemColor: Colors.white,
// unselectedItemColor: Colors.blueGrey,
// currentIndex: currentindex,
// onTap: (index) {
// setState(() {
// currentindex = index;
// });
// },
// items: const [
// BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
// BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
// BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
// ],
// ),
// ),
// ),
// ),