import 'package:diet_app/layout/app_layout.dart';
import 'package:diet_app/widgets/login_link.dart';
import 'package:diet_app/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: 'Sign Up',
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: SignUpForm(),
            ),
            LoginLink(text: 'Already a User? Login',),
          ],
        ),
      ),
    );
  }
}