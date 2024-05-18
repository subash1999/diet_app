import 'package:diet_app/layout/app_layout.dart';
import 'package:diet_app/widgets/forgot_password_form.dart';
import 'package:diet_app/widgets/login_link.dart';
import 'package:flutter/material.dart';
import 'package:diet_app/widgets/sign_up_link.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: 'Forgot Password',
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: ForgotPasswordForm(),
            ),
            LoginLink(text:'Already a User? Login'),
            SignUpLink(text: 'New User? Sign Up',),
          ],
        ),
      ),
    );
  }
}