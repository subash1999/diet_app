import 'package:flutter/material.dart';
import 'package:diet_app/screens/forgot_password_page.dart';

class ForgotPasswordLink extends StatelessWidget {
  final String text;

  const ForgotPasswordLink({super.key, this.text = 'Forgot Password?'});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
        );
      },
      child: Text(text),
    );
  }
}