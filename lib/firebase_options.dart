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
    apiKey: 'AIzaSyAtbV_qQXZZj93xNfBQkAdG-UBu4FQwqhw',
    appId: '1:276687207652:web:3f70931bd6cfaa2d0d00f1',
    messagingSenderId: '276687207652',
    projectId: 'o2tech-blood-pressure',
    authDomain: 'o2tech-blood-pressure.firebaseapp.com',
    storageBucket: 'o2tech-blood-pressure.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBM6UzsgnG9ZaeAbf0h5e78OXWttED2hw4',
    appId: '1:276687207652:android:cbd9314c44024f630d00f1',
    messagingSenderId: '276687207652',
    projectId: 'o2tech-blood-pressure',
    storageBucket: 'o2tech-blood-pressure.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHYst3TssfX8W7TDhPVslGSCyE1lDuLmc',
    appId: '1:276687207652:ios:5084515bfa7b6e460d00f1',
    messagingSenderId: '276687207652',
    projectId: 'o2tech-blood-pressure',
    storageBucket: 'o2tech-blood-pressure.firebasestorage.app',
    iosBundleId: 'com.example.o2Bp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBHYst3TssfX8W7TDhPVslGSCyE1lDuLmc',
    appId: '1:276687207652:ios:5084515bfa7b6e460d00f1',
    messagingSenderId: '276687207652',
    projectId: 'o2tech-blood-pressure',
    storageBucket: 'o2tech-blood-pressure.firebasestorage.app',
    iosBundleId: 'com.example.o2Bp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAtbV_qQXZZj93xNfBQkAdG-UBu4FQwqhw',
    appId: '1:276687207652:web:ba7e7868d2c174c00d00f1',
    messagingSenderId: '276687207652',
    projectId: 'o2tech-blood-pressure',
    authDomain: 'o2tech-blood-pressure.firebaseapp.com',
    storageBucket: 'o2tech-blood-pressure.firebasestorage.app',
  );
}
