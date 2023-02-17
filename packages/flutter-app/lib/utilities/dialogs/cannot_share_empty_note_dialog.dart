import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "sharing",
    content: "cannot_share_empty_note_prompt",
    optionsBuilder: () => {
      "ok": null,
    },
  );
}
