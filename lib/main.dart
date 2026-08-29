import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/wrapper.dart';
import 'package:social_app/providers/user_prodiver.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(

    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: myApp(),
    ),
  );
}
class myApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home:wrapper() ,
    );


  }


}
