import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  var toast = ScaffoldMessenger.of(context);
  toast.showSnackBar(SnackBar(
    content: Text(message),
    action: SnackBarAction(label: 'OK', onPressed: toast.hideCurrentSnackBar),
  ));
}

Future<void> showAlertDialog(
    {required BuildContext context, required Function onPressedOk}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('OPOZORILO'),
      content: const Text('Želite nepovratno izbrisati igro?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Prekliči'),
        ),
        TextButton(
          onPressed: () {
            onPressedOk;
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
