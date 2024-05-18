import 'package:diet_app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:diet_app/widgets/forgot_password_link.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: EmailValidator.validate,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        const ForgotPasswordLink(),
        ElevatedButton(
          onPressed: () {
            // Implement login functionality here
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
