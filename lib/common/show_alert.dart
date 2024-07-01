import 'package:flutter/material.dart';

class Alert {
  BuildContext context;

  Alert.of(this.context);

  // show an error message
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // show an error message
  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
