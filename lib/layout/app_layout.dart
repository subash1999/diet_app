import 'package:diet_app/screens/edit_profile_page.dart';
import 'package:diet_app/screens/forgot_password_page.dart';
import 'package:diet_app/widgets/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../screens/login_page.dart';
import '../services/auth_service.dart';
import '../utils/global_state.dart';
import '../utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:diet_app/utils/dialogs.dart';
import 'package:diet_app/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_page.dart';
import '../services/auth_service.dart';
import '../utils/global_state.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final String title;

  const AppLayout({Key? key, required this.child, this.title = ''})
      : super(key: key);

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<GlobalState>(context).currentUser;

    // Access environment variable 'APP_TITLE' or use default value
    String? appTitle = Platform.environment['APP_NAME'] ?? 'Diet App';

    if (widget.title.isNotEmpty) {
      appTitle = widget.title;
    }

    bool isLoading = Provider.of<GlobalState>(context).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        actions: <Widget>[
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0), // Add right margin
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.account_circle_outlined),
                  onPressed: () {
                    // Open drawer
                    Scaffold.of(context).openEndDrawer();
                  },
                  iconSize: 30.0, // Double the icon size
                ),
              ),
            ),
        ],
      ),
      body: Stack(children: [
        SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.child,
        )),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ]),
      endDrawer: _buildDrawer(context, user),
    );
  }

  Drawer? _buildDrawer(BuildContext context, UserModel? user) {
    return user != null
        ? Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomePage())); // Navigate to home page
                  },
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.home,
                            color: Colors.white), // Home icon
                        const SizedBox(
                            width: 10), // Space between icon and text
                        Expanded(
                          child: Text(
                            user.name,
                            textAlign:
                                TextAlign.center, // Center the header text
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home), // Change Password Icon
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit), // Change Password Icon
                  title: const Text('Edit Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.lock_outline), // Change Password Icon
                  title: const Text('Change Password'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout), // Logout Icon
                  title: const Text('Logout'),
                  onTap: _logoutUser,
                ),
              ],
            ),
          )
        : null;
  }

  void _logoutUser() async {
    try {
      // Start loading
      context.read<GlobalState>().setLoading(true);
      await AuthService().logoutUser();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout successfully")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      showAlertDialog(context, "Logout Failed", e.toString());
    } finally {
      // Stop loading
      context.read<GlobalState>().setLoading(false);
    }
  }
}
