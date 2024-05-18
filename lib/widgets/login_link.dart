import 'package:diet_app/screens/login_page.dart';
import 'package:flutter/material.dart';

class LoginLink extends StatelessWidget {
  final String text;
  
  const LoginLink({super.key, this.text = 'Login' });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: Text(text),
    );
  }
}