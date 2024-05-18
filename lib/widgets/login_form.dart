import 'package:diet_app/utils/dialogs.dart';
import 'package:diet_app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:diet_app/widgets/forgot_password_link.dart';
import 'package:provider/provider.dart';
import '../screens/home_page.dart';
import '../services/auth_service.dart';
import '../utils/global_state.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const ForgotPasswordLink(),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _loginUser(emailController.text, passwordController.text);
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _loginUser(String email, String password) async {
    try {
      // Start loading
      context.read<GlobalState>().setLoading(true);
      await AuthService().loginUser(email, password);

      // Navigate to home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      showAlertDialog(context, "Login Failed", "Invalid Credentials.");
      // Stop loading
      context.read<GlobalState>().setLoading(false);
      await AuthService().signOut();
    } finally {
      // Stop loading
      context.read<GlobalState>().setLoading(false);
    }
  }
}
