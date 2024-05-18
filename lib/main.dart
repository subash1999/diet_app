import 'package:diet_app/firebase_options.dart';
import 'package:diet_app/utils/dialogs.dart';
import 'package:diet_app/utils/global_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:diet_app/screens/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app and provide the global state
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupErrorHandler();
  }

  void setupErrorHandler() {
    FlutterError.onError = (details) {
      bool isReleaseMode = bool.fromEnvironment('dart.vm.product');
      String title = isReleaseMode ? 'Error' : 'Error: ${details.exception}';
      String message = isReleaseMode
          ? 'An unexpected error occurred. Please try again.'
          : details.exceptionAsString();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAlertDialog(context, title, message);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diet Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
