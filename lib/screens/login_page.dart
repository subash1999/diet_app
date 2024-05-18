import 'package:flutter/material.dart';
import 'package:diet_app/layout/app_layout.dart';
import 'package:diet_app/widgets/login_image.dart';
import 'package:diet_app/widgets/login_form.dart';
import 'package:diet_app/widgets/sign_up_link.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Login',
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20),
              child: LoginImage(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: LoginForm(),
            ),
            const SignUpLink(text:'New User? Sign Up'),
          ],
        ),
      ),
    );
  }
}