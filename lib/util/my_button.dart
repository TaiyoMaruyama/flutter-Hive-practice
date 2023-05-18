import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  String text;

  ///　初めてみたゾーン
  VoidCallback onPressed;
  MyButton({required this.text, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///　初めてみたゾーン
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.green,
      elevation: 8.0,
      child: Text(
        text,
      ),
    );
  }
}
