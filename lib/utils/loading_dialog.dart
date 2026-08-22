import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Pehle ye 'showDialog(context: context...)' se ban raha tha, jiski wajah se
/// agar background me auth-state-change ki wajah se underlying page (jaise
/// SignupScreen) dispose ho jaye is se pehle ke hideLoadingDialog() call ho,
/// to Navigator.pop(context) us purane/dispose ho chuke context pe fail ho
/// jata tha aur dialog hamesha ke liye screen pe atka reh jata tha.
///
/// Ab GetX ka apna 'Get.dialog' / 'Get.back()' use kar rahe hain jo kisi
/// specific BuildContext pe depend nahi karta - GetX ka global navigator key
/// use karta hai, isliye chahe koi bhi page beech me swap/dispose ho jaye,
/// ye dialog reliably close ho jayega.
void showLoadingDialog(BuildContext context) {
  Get.dialog(
    BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // neeche wali screen blur
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.purple,
          strokeWidth: 4,
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2), // halka overlay
  );
}

void hideLoadingDialog(BuildContext context) {
  // Sirf tabhi close karo jab dialog abhi bhi open ho -> warna error aayega
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}