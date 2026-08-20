import 'dart:ui';
import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2), // halka overlay, baaki blur karega
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // ✅ neeche wali screen blur
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
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