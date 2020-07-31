import 'package:flutter/material.dart';

class SetDialogBox extends StatelessWidget {
  final String textContent;
  final String textHeading;
  final String secondaryAction;
  final Function secondaryActionCallback;
  const SetDialogBox({
    @required this.textHeading,
    @required this.textContent,
    this.secondaryAction,
    this.secondaryActionCallback,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(textHeading),
      content: Text(textContent),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Ok'),
        ),
        secondaryAction != null
            ? FlatButton(
                onPressed: secondaryActionCallback,
                child: Text(secondaryAction),
              )
            : null,
      ],
    );
  }
}
