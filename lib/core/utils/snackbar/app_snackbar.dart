import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 16,
      ),
    ),
    duration: const Duration(seconds: 3),
  );

  // Show the Snackbar using ScaffoldMessenger
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
