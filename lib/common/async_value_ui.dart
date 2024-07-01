import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showSnackBarOnError(BuildContext context) {
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
