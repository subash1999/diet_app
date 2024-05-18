import 'package:diet_app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPVerificationPage extends StatefulWidget {
  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();

  Future<void> _verifyOTPAndResetPassword() async {
    try {
      // Assuming you have a way to get the user's email or oobCode from the password reset link
      String email = "user@example.com"; // Placeholder for user's email
      String oobCode = "OTP_FROM_EMAIL"; // Placeholder for OTP from email

      // Verify the OTP (oobCode) - In actual implementation, this step might differ
      // This is a placeholder to represent the action of verifying the OTP
      // Firebase Auth does not directly expose an OTP verification method for password reset in Flutter

      // If OTP verification is successful, reset the password
      await FirebaseAuth.instance.confirmPasswordReset(
        code: oobCode,
        newPassword: _newPasswordController.text,
      );

      // Inform the user of success
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Password Reset Successful'),
          content: Text(
              'Your password has been reset. Please log in with your new password.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.of(context).pop(); // Go back to the previous screen
              },
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle errors, e.g., incorrect OTP
      print(e); // Consider using a more user-friendly error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
            ),
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              validator: PasswordValidator.validate,
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _verifyOTPAndResetPassword,
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
