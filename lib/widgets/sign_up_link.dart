import 'package:flutter/material.dart';
import 'package:diet_app/screens/sign_up_page.dart';

class SignUpLink extends StatelessWidget {
  final String text;

  const SignUpLink({super.key, this.text = 'Sign Up' });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      },
      child: Text(text),
    );
  }
}
