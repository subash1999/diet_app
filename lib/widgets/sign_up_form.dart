import 'package:diet_app/utils/dialogs.dart';
import 'package:diet_app/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_page.dart';
import '../services/auth_service.dart';
import '../utils/global_state.dart';
import 'dob_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DOBField(dobController: _dobController),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: EmailValidator.validate,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: PasswordValidator.validate,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: (value) {
              if (value != _passwordController.text &&
                  PasswordValidator.validate(_passwordController.text) ==
                      null) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _registerUser();
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  void _registerUser() async {
    final name = _nameController.text;
    final dob = _dobController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Start loading
      context.read<GlobalState>().setLoading(true);

      // Use AuthService to register user
      await AuthService().registerUser(name, dob, email, password);

      // Optionally, log in the user immediately after registration
      await AuthService().loginUser(email, password);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      // signout if user signed in while registering
      await AuthService().signOut();
      if (e.code == 'email-already-in-use') {
        // Email already exists
        showAlertDialog(context, 'User Already Exists',
            'The email address is already in use by another account.');
      } else {
        // Other FirebaseAuth errors
        showAlertDialog(context, 'Error',
            e.message ?? 'An error occurred. Please try again.');
      }
    } catch (e) {
      // Generic error handling
      showAlertDialog(
          context, 'Error', 'An unexpected error occurred. Please try again.');
    } finally {
      // Stop loading
      context.read<GlobalState>().setLoading(false);
    }
  }
}
