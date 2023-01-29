<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Firebase Authentication Controller

Flutter controller package for firebase authentication

## Features

Sign In with Google, Facebook and Apple providers.

## Getting started

Add the reference in `pubspec.yaml`

```
firebase_auth_controller: ^0.0.1
```

## Usage

Import the module:

```dart
import 'package:firebase_auth_controller/firebase_auth_controller.dart';
```

And use the `FirebaseAuthController`.


```dart
final FirebaseAuthController _authFirebaseController = FirebaseAuthController();

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder(
        valueListenable: _authFirebaseController,
        builder: (context, value, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Click to login',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
```

## Additional information

This package is under construction.
