import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/app/wrapper.dart';
import 'package:social_app/services/firestore_service.dart';
import 'package:social_app/utils/loading_dialog.dart';
import 'package:social_app/utils/validators.dart';
import 'package:social_app/widgets/bottomsheet_widget.dart';

import 'signup_page_welcome.dart';
import 'signup_page_name.dart';
import 'signup_page_credentials.dart';
import 'signup_page_username.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
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

  String? nameError;
  String? lastNameError;
  String? emailError;
  String? passwordError;
  String? phoneError;

  bool isCreatingAccount = false;

  String getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Sign up is currently disabled. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }


  void validateAndCreateAccount() {
    setState(() {
      emailError = Validators.validateEmail(gmail.text);
      passwordError = Validators.validatePassword(password.text);
      nameError = Validators.validateName(firstname.text);
      lastNameError = Validators.validateName(lastname.text);

    });


    if (nameError != null || lastNameError != null) {
      pageController.jumpToPage(1);
      return;
    }

    if (emailError != null || passwordError != null) {
      pageController.jumpToPage(2);
      return;
    }



    signUp();
  }


  Future<void> signUp() async {
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
      final usernameTaken = await FirestoreService().checkUsernameExists(username.text.trim());
      if (!mounted) return;



      if (usernameTaken) {
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



      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: gmail.text,
        password: password.text,
      );
      String uid = userCredential.user!.uid;
      await FirestoreService().createUserProfile(uid, {
        'firstname': firstname.text,
        'lastname': lastname.text,
        'email': gmail.text,
        'username': username.text,
        'phone': phone.text,
        'profileImageUrl': '',
        'bio': '',
        'profileSetupDone': false,
      });




      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthWrapper()),
            (route) => false,
      );

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        isCreatingAccount = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getAuthErrorMessage(e.code))),
      );


    } catch (e) {
      if (!mounted) return;
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
          const SignupWelcomePage(),

          SignupNamePage(
            firstNameController: firstname,
            lastNameController: lastname,
            nameError: nameError,
            lastNameError: lastNameError,
          ),

          SignupCredentialsPage(
            gmailController: gmail,
            passwordController: password,
            confirmController: confirmpass,
            emailError: emailError,
            passwordError: passwordError,
          ),

          SignupUsernamePage(
            usernameController: username,
            phoneController: phone,
            phoneError: phoneError,
            isCreatingAccount: isCreatingAccount,
            onCreateAccount: validateAndCreateAccount,
          ),
        ],
      ),
    );
  }
}