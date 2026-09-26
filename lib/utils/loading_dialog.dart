import 'dart:ui';
import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.2),
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.purple,
          strokeWidth: 4,
        ),
      ),
    ),
  );
}

void hideLoadingDialog(BuildContext context) {
  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop();
}