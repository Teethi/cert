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
    apiKey: 'AIzaSyDPc2bGh5ry5BH0N3t2UBYH_W-nF_W9eFc',
    appId: '1:172073501542:web:033d773e639339d684fea7',
    messagingSenderId: '172073501542',
    projectId: 'spitattendance',
    authDomain: 'spitattendance.firebaseapp.com',
    storageBucket: 'spitattendance.appspot.com',
    measurementId: 'G-2KGGR4Q5GB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYYhnIEtATeRIRdj0cNulxlBirXM4ZtMI',
    appId: '1:172073501542:android:413f1061c7d0dc2f84fea7',
    messagingSenderId: '172073501542',
    projectId: 'spitattendance',
    storageBucket: 'spitattendance.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0IhPdrb49raczSRxramm3hmyx4JOjzC0',
    appId: '1:172073501542:ios:d2e47d4f2779e54f84fea7',
    messagingSenderId: '172073501542',
    projectId: 'spitattendance',
    storageBucket: 'spitattendance.appspot.com',
    iosClientId: '172073501542-bigpj08kiepms0sf21tene0ucokubhod.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendance',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0IhPdrb49raczSRxramm3hmyx4JOjzC0',
    appId: '1:172073501542:ios:d2e47d4f2779e54f84fea7',
    messagingSenderId: '172073501542',
    projectId: 'spitattendance',
    storageBucket: 'spitattendance.appspot.com',
    iosClientId: '172073501542-bigpj08kiepms0sf21tene0ucokubhod.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendance',
  );
}
