import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoadingDialog(BuildContext context) {
  Get.dialog(
    BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.purple,
          strokeWidth: 4,
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2),
  );
}

void hideLoadingDialog(BuildContext context) {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}