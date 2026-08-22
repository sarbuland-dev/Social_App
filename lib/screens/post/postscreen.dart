import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/screens/home/home.dart';
import 'package:social_app/screens/post/post_crop.dart';
import 'package:social_app/services/firestore_service.dart';

class Postscreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PostscreenState();



}
class PostscreenState extends State<Postscreen> {

  TextEditingController caption=TextEditingController();

  // PageView control karne ke liye controller
  // isi se hum programmatically page change karenge (swipe se nahi)
  final PageController _pageController = PageController();



  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No image selected');
  }


  showSnackBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ), // SnackBar
    );
  }







  Uint8List? file;
  selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(10),
              child: Text("Take a Photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? pickedfile = await pickImage(ImageSource.camera);
                await _openCropScreen(pickedfile); // pehle crop screen khulega
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(10),
              child: Text("Choose from Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? pickedfile = await pickImage(ImageSource.gallery);
                await _openCropScreen(pickedfile); // pehle crop screen khulega
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(10),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Naya function: picked image ko crop screen mein bhejta hai
  // aur cropped result ko `file` mein set karta hai
  Future<void> _openCropScreen(Uint8List? pickedfile) async {
    if (pickedfile == null) return;

    final Uint8List? croppedBytes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCropScreen(imageBytes: pickedfile),
      ),
    );

    if (croppedBytes != null) {
      setState(() {
        file = croppedBytes;
      });
      // image select ho gayi -> ab code se hi (bina swipe ke) 2nd page pe le jao
      _pageController.jumpToPage(1);
    }
    // agar user ne crop screen se "cancel" (X) dabaya, to croppedBytes null
    // hoga aur `file` set nahi hoga, page bhi change nahi hoga
  }


  final FirestoreService _firestoreService = FirestoreService();
  bool isPosting = false;

  postImage() async {
    if (file == null) {
      showSnackBar("Pehle image select karo", context);
      return;
    }

    setState(() {
      isPosting = true;
    });

    String result = await _firestoreService.createPost(
      file!,
      caption.text,
    );

    setState(() {
      isPosting = false;
    });

    if (result == "success") {
      showSnackBar("Post ho gayi!", context);
      Get.back();
    } else {
      showSnackBar(result, context);
    }
  }

  @override
  void dispose() {
    caption.dispose();
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // AppBar sirf tabhi dikhega jab file select ho chuki ho (2nd page pe),
      // pehle page pe koi appbar nahi tha, wahi behavior maintain kiya hai
      appBar: file == null
          ? null
          : AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Post To",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.only(right: 20),
            child: GestureDetector(
              onTap: () => postImage(),
              child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Colors.green, Colors.blue], //
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: isPosting
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                      : Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
            ),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        // Yahi line swipe ko band karti hai — user ungli se page change
        // nahi kar sakta, sirf code se (jumpToPage) hi page badlega
        physics: NeverScrollableScrollPhysics(),
        children: [
          // ---------- PAGE 1: Image select karne wala part ----------
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Heading text - upload button ke upar
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [Colors.green, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      "Create Your Post",
                      style: GoogleFonts.cherryCreamSoda(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Chota sa slogan - gradient text

                  Text(
                        "Snap it. Share it. Vibe it.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.agbalumo(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),


                  SizedBox(
                    height: 15,
                  ),
                  // Instruction line - user ko batata hai ke button tap karna hai
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Tap the button below to choose a photo or take a new one",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(2), // ye border ki "thickness" hai
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Color(0xff4b5459)
                          color: Colors.black87),
                      child: GestureDetector(
                        onTap: () => selectImage(context),
                        child: Icon(
                          Icons.upload,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: ()=>Homescreen(),
                    child: Center(
                      child: Text('Cancel',style: TextStyle(color: Colors.red,fontSize: 15),),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------- PAGE 2: Post create/caption wala part ----------
          Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: EdgeInsets.all(1), // ye border ki "thickness" hai
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black87),
                        child: file == null
                            ? SizedBox() // safety fallback, is page pe file null nahi hogi
                            : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(file!,
                              fit: BoxFit.cover,)), // cropped image ka preview
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.all(2), // ye border ki "thickness" hai
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black87),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(10),
                        child: TextField(
                          controller: caption,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Write a Caption...",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none),
                          maxLines: 8,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




// Text("Post",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),