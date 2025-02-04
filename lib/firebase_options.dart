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
    apiKey: 'AIzaSyA3RCGoDSo2f5_WBvm9ww0pC51LsuY81Yw',
    appId: '1:787517453402:web:55d20572615c4fd9fb1463',
    messagingSenderId: '787517453402',
    projectId: 'campus-coach-f5348',
    authDomain: 'campus-coach-f5348.firebaseapp.com',
    storageBucket: 'campus-coach-f5348.appspot.com',
    measurementId: 'G-3D6CDXJKH2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSxCvDVjytmXWvGmlaU1bHsqjSNHt-h04',
    appId: '1:787517453402:android:648844101e520a77fb1463',
    messagingSenderId: '787517453402',
    projectId: 'campus-coach-f5348',
    storageBucket: 'campus-coach-f5348.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuhBlT_X1INedKpEYN9JCcswtt8QJxNp0',
    appId: '1:787517453402:ios:b796139b7fdf7914fb1463',
    messagingSenderId: '787517453402',
    projectId: 'campus-coach-f5348',
    storageBucket: 'campus-coach-f5348.appspot.com',
    iosBundleId: 'com.example.campusCoachLogin01',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAuhBlT_X1INedKpEYN9JCcswtt8QJxNp0',
    appId: '1:787517453402:ios:b796139b7fdf7914fb1463',
    messagingSenderId: '787517453402',
    projectId: 'campus-coach-f5348',
    storageBucket: 'campus-coach-f5348.appspot.com',
    iosBundleId: 'com.example.campusCoachLogin01',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA3RCGoDSo2f5_WBvm9ww0pC51LsuY81Yw',
    appId: '1:787517453402:web:0a6c17602e73c578fb1463',
    messagingSenderId: '787517453402',
    projectId: 'campus-coach-f5348',
    authDomain: 'campus-coach-f5348.firebaseapp.com',
    storageBucket: 'campus-coach-f5348.appspot.com',
    measurementId: 'G-28LKCTBYB4',
  );
}
