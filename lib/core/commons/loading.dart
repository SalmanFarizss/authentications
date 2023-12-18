import 'package:authentications/core/theme/palette.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(backgroundColor: Palette.greyColor);
  }
}
