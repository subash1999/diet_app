import 'package:flutter/material.dart';
import 'package:diet_app/widgets/forgot_password_form.dart';
import 'package:diet_app/widgets/login_link.dart';
import 'package:diet_app/widgets/sign_up_link.dart';
import 'package:diet_app/layout/app_layout.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../utils/global_state.dart';

// Step 1: Convert ForgotPasswordPage to a StatefulWidget
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

// Step 2: Implement the State class
class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Step 3: Define state variables and methods here

  @override
  Widget build(BuildContext context) {
    UserModel? _user = context.read<GlobalState>().currentUser;
    // Step 4: Use state variables and methods in the UI
    return AppLayout(
      title: _user == null ? 'Forgot Password' : 'Change Password',
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20),
              child: ForgotPasswordForm(),
            ),
            if (_user == null) ...[
              const LoginLink(text: 'Already a User? Login'),
              const SignUpLink(text: 'New User? Sign Up'),
            ],
          ],
        ),
      ),
    );
  }
}
