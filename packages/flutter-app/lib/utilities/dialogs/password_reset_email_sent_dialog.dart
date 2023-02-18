import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "password_reset",
    content: "password_reset",
    optionsBuilder: () => {
      "ok": null,
    },
  );
}
