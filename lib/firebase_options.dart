// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDUbfG5cJRvhdcAxEA_X0MQ7t_aMLcSfZk',
    appId: '1:219055183006:web:b6eb965fdf592875b0d78f',
    messagingSenderId: '219055183006',
    projectId: 'diet-app-f2fb4',
    authDomain: 'diet-app-f2fb4.firebaseapp.com',
    storageBucket: 'diet-app-f2fb4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDC6qY12bwAfi-Niaappqg4L_caaD80IFI',
    appId: '1:219055183006:android:9bda9fcd75a7c42bb0d78f',
    messagingSenderId: '219055183006',
    projectId: 'diet-app-f2fb4',
    storageBucket: 'diet-app-f2fb4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfblW4x8uKavUj_OyfgQ2qhlYI2Hm12po',
    appId: '1:219055183006:ios:ab1bc8a8b4669568b0d78f',
    messagingSenderId: '219055183006',
    projectId: 'diet-app-f2fb4',
    storageBucket: 'diet-app-f2fb4.appspot.com',
    iosBundleId: 'com.example.dietApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDfblW4x8uKavUj_OyfgQ2qhlYI2Hm12po',
    appId: '1:219055183006:ios:ab1bc8a8b4669568b0d78f',
    messagingSenderId: '219055183006',
    projectId: 'diet-app-f2fb4',
    storageBucket: 'diet-app-f2fb4.appspot.com',
    iosBundleId: 'com.example.dietApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUbfG5cJRvhdcAxEA_X0MQ7t_aMLcSfZk',
    appId: '1:219055183006:web:67668acddd3deb3fb0d78f',
    messagingSenderId: '219055183006',
    projectId: 'diet-app-f2fb4',
    authDomain: 'diet-app-f2fb4.firebaseapp.com',
    storageBucket: 'diet-app-f2fb4.appspot.com',
  );
}
