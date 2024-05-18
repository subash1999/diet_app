import 'package:flutter/material.dart';
import 'dart:io';
import 'package:diet_app/widgets/login_link.dart';
import 'package:diet_app/widgets/sign_up_link.dart';
import 'package:provider/provider.dart';

import '../utils/global_state.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const AppLayout({super.key, required this.child, this.title = ''});

  @override
  Widget build(BuildContext context) {
    // Access environment variable 'APP_TITLE' or use default value
    String appTitle = Platform.environment['APP_NAME'] ?? 'Diet App';
    if (title.isNotEmpty) {
      appTitle = title;
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
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Open drawer
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
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
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(Platform.environment['APP_NAME'] ?? 'Diet App'),
            ),
            ListTile(
              title: const LoginLink(),
              onTap: () {
                // Handle navigation to item 1
              },
            ),
            ListTile(
              title: const SignUpLink(),
              onTap: () {
                // Handle navigation to item 2
              },
            ),
          ],
        ),
      ),
    );
  }
}
