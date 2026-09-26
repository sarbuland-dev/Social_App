
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/user_provider.dart';
import 'package:social_app/screens/home/bottomnavigation.dart';
import 'package:social_app/screens/auth/signup.dart';
import 'package:social_app/screens/auth/emailverify.dart';
import 'package:social_app/screens/auth/profile_setup.dart';

class AuthWrapper extends StatefulWidget{
  const AuthWrapper({super.key});
  @override
  State<StatefulWidget> createState() => _AuthWrapperState();
}
class _AuthWrapperState extends State<AuthWrapper>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
        if (snapshot.hasData){
          if(snapshot.data!.emailVerified){

            context.read<UserProvider>().listenToUser(snapshot.data!.uid);

            return Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                if (userProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final bool profileSetupDone =
                    userProvider.userData?['profileSetupDone'] ?? false;

                if (profileSetupDone) {
                  return BottomNav();
                } else {
                  return ProfileSetupScreen();
                }
              },
            );
          }else{
            return Verify();
          }


        }else{
          return SignupScreen();
        }
      }



      ),
    );

  }
}