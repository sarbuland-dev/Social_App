import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

/// ImageCropScreen: user ki pick ki hui image ko Instagram jaisa square
/// crop + zoom/pan karne deta hai. "Done" dabane pe cropped image bytes
/// wapis (Navigator.pop se) bhej deta hai.
class ImageCropScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const ImageCropScreen({super.key, required this.imageBytes});

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final CropController _cropController = CropController();
  bool _isCropping = false;

  void _onDonePressed() {
    setState(() => _isCropping = true);
    _cropController.crop(); // ✅ ye crop widget ke onCropped callback ko trigger karega
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context), // cancel — koi image nahi bhejta
        ),
        title: const Text(
          "Move and Scale",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _isCropping ? null : _onDonePressed,
              child: _isCropping
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.purple,
                  strokeWidth: 2,
                ),
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
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Crop(
          image: widget.imageBytes,
          controller: _cropController,
          aspectRatio: 1, // ✅ 1:1 square — Instagram jaisa
          withCircleUi: false,
          baseColor: Colors.black,
          maskColor: Colors.black.withOpacity(0.65), // crop area ke bahar ka hissa dhundhla
          radius: 0,
          interactive: true, // ✅ pinch-to-zoom + drag/pan allow karta hai
          progressIndicator: const CircularProgressIndicator(color: Colors.purple),
          onCropped: (CropResult result) {
            switch (result) {
              case CropSuccess(:final croppedImage):
                Navigator.pop(context, croppedImage); // ✅ cropped bytes wapis postscreen ko
              case CropFailure(:final cause):
                setState(() => _isCropping = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Crop fail ho gaya: $cause")),
                );
            }
          },
        ),
      ),
    );
  }
}