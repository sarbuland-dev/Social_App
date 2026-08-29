import 'package:flutter/material.dart';



Future<void> showMessageSheet(
    BuildContext context, {
      required String title,
      required String message,
      IconData icon = Icons.info_outline,
      Color iconColor = Colors.green,
      Widget? header,
    }) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xff293038),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            header ?? Icon(icon, color: iconColor, size: 55),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    },
  );
}