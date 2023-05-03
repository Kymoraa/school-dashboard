// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAI_9SWedaA-rB5XaMTs8WL66CZlyj-jXU',
    appId: '1:765368906144:web:e838604a3385b7612374c5',
    messagingSenderId: '765368906144',
    projectId: 'school-dashboard-1fcd0',
    authDomain: 'school-dashboard-1fcd0.firebaseapp.com',
    storageBucket: 'school-dashboard-1fcd0.appspot.com',
    measurementId: 'G-RL0LL43SD4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAu5_-meQwj4ETgQMnOL4ZHOCHBFxK1B20',
    appId: '1:765368906144:android:c311095aaa57aae82374c5',
    messagingSenderId: '765368906144',
    projectId: 'school-dashboard-1fcd0',
    storageBucket: 'school-dashboard-1fcd0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDahLEhULKbV25Kly6dwNkfEpBEhEpJjo0',
    appId: '1:765368906144:ios:dc9732ed118ced6c2374c5',
    messagingSenderId: '765368906144',
    projectId: 'school-dashboard-1fcd0',
    storageBucket: 'school-dashboard-1fcd0.appspot.com',
    iosClientId: '765368906144-ossvj7a4atef4av311kadrsromt5eu74.apps.googleusercontent.com',
    iosBundleId: 'com.flutter.schoolDashboard',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDahLEhULKbV25Kly6dwNkfEpBEhEpJjo0',
    appId: '1:765368906144:ios:dc9732ed118ced6c2374c5',
    messagingSenderId: '765368906144',
    projectId: 'school-dashboard-1fcd0',
    storageBucket: 'school-dashboard-1fcd0.appspot.com',
    iosClientId: '765368906144-ossvj7a4atef4av311kadrsromt5eu74.apps.googleusercontent.com',
    iosBundleId: 'com.flutter.schoolDashboard',
  );
}
