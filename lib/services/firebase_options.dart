// File generated by FlutterFire CLI.
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCGZodf-kGJT8kB9lMefOby2kWGBnkpci0',
    appId: '1:1087905135138:web:1511e6f10f30fcce67e87b',
    messagingSenderId: '1087905135138',
    projectId: 'evaluacion3-appmoviles-9c232',
    authDomain: 'evaluacion3-appmoviles-9c232.firebaseapp.com',
    storageBucket: 'evaluacion3-appmoviles-9c232.firebasestorage.app',
    measurementId: 'G-D4MRW0FDLT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYpQBpXkLKD2Ob1so0M0EnHv26-r0ohnA',
    appId: '1:1087905135138:android:eacb59261c8fa48f67e87b',
    messagingSenderId: '1087905135138',
    projectId: 'evaluacion3-appmoviles-9c232',
    storageBucket: 'evaluacion3-appmoviles-9c232.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxrftvX3HNQyKETkzFzIp8nq4CYKl7dHw',
    appId: '1:1087905135138:ios:08cea0d654bc26e667e87b',
    messagingSenderId: '1087905135138',
    projectId: 'evaluacion3-appmoviles-9c232',
    storageBucket: 'evaluacion3-appmoviles-9c232.firebasestorage.app',
    iosBundleId: 'com.example.evaluacion34',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCxrftvX3HNQyKETkzFzIp8nq4CYKl7dHw',
    appId: '1:1087905135138:ios:08cea0d654bc26e667e87b',
    messagingSenderId: '1087905135138',
    projectId: 'evaluacion3-appmoviles-9c232',
    storageBucket: 'evaluacion3-appmoviles-9c232.firebasestorage.app',
    iosBundleId: 'com.example.evaluacion34',
  );
}
