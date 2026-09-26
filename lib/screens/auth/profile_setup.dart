import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/screens/post/post_crop.dart';
import 'package:social_app/services/cloudinary_services.dart';
import 'package:social_app/services/firestore_service.dart';
import 'package:social_app/widgets/bottomsheet_widget.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _bioController = TextEditingController();

  Uint8List? profileImage;
  bool isSaving = false;

  @override
  void dispose() {
    _pageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    return null;
  }

  Future<void> selectProfileImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Set Profile Photo'),
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
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
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
        profileImage = croppedBytes;
      });
    }
  }

  void _goToBioPage() {
    _pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishSetup({String? bio}) async {
    setState(() {
      isSaving = true;
    });

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      Map<String, dynamic> updateData = {
        'profileSetupDone': true,
      };

      if (profileImage != null) {
        String url = await CloudinaryService.uploadImage(profileImage!);
        updateData['profileImageUrl'] = url;
      }

      if (bio != null && bio.trim().isNotEmpty) {
        updateData['bio'] = bio.trim();
      }

      await FirestoreService().updateUserProfile(uid, updateData);

    } catch (e) {
      if (!mounted) return;
      setState(() {
        isSaving = false;
      });
      showMessageSheet(
        context,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        title: "Profile SetUp failed",
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildPhotoPage(),
          _buildBioPage(),
        ],
      ),
    );
  }

  // ---------------- PAGE 0: Profile Photo ----------------
  Widget _buildPhotoPage() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [Colors.green, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                "Vibely",
                style: GoogleFonts.angkor(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => selectProfileImage(context),
              child: Container(
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
                  child: ClipOval(
                    child: profileImage != null
                        ? Image.memory(profileImage!, fit: BoxFit.cover)
                        : Icon(Icons.person, color: Colors.white54, size: 50),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [Colors.green, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                "Choose Your Profile Photo",
                style: GoogleFonts.cherryCreamSoda(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Add a profile photo so your friends can easily recognize you.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            SizedBox(height: 20),
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
              child: FadeInUp(
                duration: Duration(seconds: 1),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
                  child: GestureDetector(
                    onTap: () => selectProfileImage(context),
                    child: Icon(Icons.upload, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _goToBioPage,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _goToBioPage,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: 120,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black87,
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [Colors.green, Colors.blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---------------- PAGE 1: Bio ----------------
  Widget _buildBioPage() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [Colors.green, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  "Vibely",
                  style: GoogleFonts.angkor(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [Colors.green, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  "Write Your Bio",
                  style: GoogleFonts.cherryCreamSoda(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Tell people a little about yourself (optional).',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 30),
              FadeInUp(
                duration: Duration(seconds: 1),
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black87,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _bioController,
                        style: TextStyle(color: Colors.white),
                        maxLines: 5,
                        maxLength: 150,
                        decoration: InputDecoration(
                          hintText: "Write a short bio...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          counterStyle: TextStyle(color: Colors.white38),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: isSaving ? null : () => _finishSetup(bio: null),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: isSaving ? null : () => _finishSetup(bio: _bioController.text),
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: 120,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.black87,
                        ),
                        child: Center(
                          child: isSaving
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.purple, strokeWidth: 2),
                          )
                              : ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [Colors.green, Colors.blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: const Text(
                              "Finish",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}