import 'package:authentications/core/theme/palette.dart';
import 'package:flutter/material.dart';
class ErrorText extends StatelessWidget {
  final String message;
  const ErrorText({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return Text('Error: $message',style: TextStyle(color: Palette.redColor,backgroundColor: Palette.yellowColor),);
  }
}
