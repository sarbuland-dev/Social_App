import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/screens/post/post_crop.dart';
import 'package:social_app/services/firestore_service.dart';
import 'package:social_app/widgets/bottomsheet_widget.dart';

class Postscreen extends StatefulWidget {
  const Postscreen({super.key});

  @override
  State<StatefulWidget> createState() => PostscreenState();
}

class PostscreenState extends State<Postscreen> {

  TextEditingController caption = TextEditingController();

  final PageController _pageController = PageController();

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      return await pickedImage.readAsBytes();
    }
    return null;
  }

  Uint8List? file;
  Future<void> selectImage(BuildContext context) async {
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
                await _openCropScreen(pickedfile);
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(10),
              child: Text("Choose from Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? pickedfile = await pickImage(ImageSource.gallery);
                await _openCropScreen(pickedfile);
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

  Future<void> _openCropScreen(Uint8List? pickedfile) async {
    if (pickedfile == null) return;

    final Uint8List? croppedBytes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCropScreen(imageBytes: pickedfile),
      ),
    );

    if (!mounted) return;

    if (croppedBytes != null) {
      setState(() {
        file = croppedBytes;
      });

      _pageController.jumpToPage(1);
    }
  }

  final FirestoreService _firestoreService = FirestoreService();
  bool isPosting = false;

  Future<void> postImage() async {
    if (file == null) {
      showMessageSheet(
        context,
        icon: Icons.image_outlined,
        iconColor: Colors.orange,
        title: "First Select Your Image",
        message: "First Select Your Image !.",
      );
      return;
    }

    setState(() {
      isPosting = true;
    });

    String result = await _firestoreService.createPost(
      file!,
      caption.text,
    );

    if (!mounted) return;

    setState(() {
      isPosting = false;
    });

    if (result == "success") {
      await showMessageSheet(
        context,
        icon: Icons.check,
        iconColor: Colors.green,
        title: "Posted!!",
        message: "Your post has been shared successfully.",
      );

      if (!mounted) return;
      Navigator.pop(context);
    } else {
      showMessageSheet(
        context,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        title: "Failed to post.",
        message: "Failed to post.",
      );
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
      appBar: file == null
          ? null
          : AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
                      colors: [Colors.green, Colors.blue],
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
        physics: NeverScrollableScrollPhysics(),
        children: [

          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                  SizedBox(height: 20),
                  Text(
                    "Snap it. Share it. Vibe it.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.agbalumo(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
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
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(2),
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
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),


          Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: EdgeInsets.all(1),
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
                            ? SizedBox()
                            : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(file!,
                              fit: BoxFit.cover,)),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.all(2),
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


