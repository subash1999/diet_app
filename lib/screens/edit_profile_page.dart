import 'package:diet_app/widgets/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:diet_app/layout/app_layout.dart';
import 'package:diet_app/widgets/login_image.dart';
import 'package:diet_app/widgets/login_form.dart';
import 'package:diet_app/widgets/sign_up_link.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Sign Up',
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: EditProfileForm(),
            ),
          ],
        ),
      ),
    );
  }
}
