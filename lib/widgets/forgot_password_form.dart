import 'package:diet_app/screens/otp_verification_page.dart';
import 'package:diet_app/utils/dialogs.dart';
import 'package:diet_app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/global_state.dart';
import '../utils/hash_util.dart';
import '../utils/otp.dart';
import 'dob_field.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // get current user
    UserModel? _user = context.read<GlobalState>().currentUser;
    // if the user is already logged in, fill up the name, dob, and email fields
    if (_user != null) {
      _nameController.text = _user.name ?? '';
      _dobController.text = _user.dob ?? '';
      _emailController.text = _user.email ?? '';
    }

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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // All fields are valid, process the reset password logic
                _sendPasswordResetEmail();
              }
            },
            child: const Text('Send Reset Password Email'),
          ),
        ],
      ),
    );
  }

  void _sendPasswordResetEmail() async {
    try {
      context.read<GlobalState>().setLoading(true);
      final String name = _nameController.text;
      final String dob = _dobController.text;
      final String email = _emailController.text;

      // check if the user exists in the database
      // if the user exists, send a password reset email
      UserModel? user =
          await AuthService().checkUserExistsByNameDobEmail(name, dob, email);

      // if the user does not exist, show an error message
      if (user == null) {
        showAlertDialog(context, 'No User Found',
            'User does not exist. $name, $dob, $email');
        return;
      }

      // You can perform password reset logic here
      final otp = OTP.generateOTP();
      // this a temporary measure to show the OTP in the popup
      user.passwordResetOtp = HashUtil.generateHash(otp);
      user.passwordResetOtpExpiry =
          DateTime.now().add(const Duration(minutes: 5));
      await user.updateInFirestore();
      // when fixed the user will receive an email with the OTP
      // the above 3 lines will be removed and the below line will be uncommented
      // await AuthService().sendPasswordResetEmail(
      //     "Please use this code to reset your password: $otp");

      String otpMessage = "Please use this code to reset your password: $otp";
      otpMessage += "\n\nThis code will expire in 5 minutes.";

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("OTP To Reset Password"),
            content: Text("Please use this code to reset your password: $otp"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );

      // Navigate to the OTP verification page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OTPVerificationPage()),
      );
    } catch (e) {
      if (e.toString().contains('invalid-email')) {
        showAlertDialog(context, 'Error', 'The email address is invalid.');
      } else {
        showAlertDialog(context, 'Error',
            'An error occurred while sending the password reset email. Please try again.');
      }
    } finally {
      context.read<GlobalState>().setLoading(false);
    }
  }
}
