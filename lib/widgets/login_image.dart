import 'package:flutter/material.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/login_image.png', // Change this to your image path
      height: 300,
      width: 400,
      fit: BoxFit.cover,
    );
  }
}
