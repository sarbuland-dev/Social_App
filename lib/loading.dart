import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 4,
          ),
        ),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}