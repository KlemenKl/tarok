import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  var toast = ScaffoldMessenger.of(context);
  toast.showSnackBar(SnackBar(
    content: Text(message),
    action: SnackBarAction(label: 'OK', onPressed: toast.hideCurrentSnackBar),
  ));
}
