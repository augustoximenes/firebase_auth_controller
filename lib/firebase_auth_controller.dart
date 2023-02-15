library firebase_auth_controller;

import 'package:firebase_auth_controller/providers/apple_provider.dart';
import 'package:firebase_auth_controller/providers/facebook_provider.dart';
import 'package:firebase_auth_controller/providers/google_provider.dart';
import 'package:firebase_auth_controller/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_controller/firebase_auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthController extends ValueNotifier<FirebaseAuthState> {
  FirebaseAuthController({
    FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(SignedOutFirebaseAuthState());

  final FirebaseAuth _firebaseAuth;
  final Provider _googleProvider = GoogleProvider();
  final Provider _facebookProvider = FacebookProvider();
  final Provider _appleProvider = AppleProvider();

  Future<bool> get isSignedIn async {
    if (_firebaseAuth.currentUser != null) {
      value = SignedInFirebaseAuthState(user: _firebaseAuth.currentUser);
      return true;
    } else {
      value = SignedOutFirebaseAuthState();
      return false;
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithGoogle() async {
    value = SignningFirebaseAuthState();
    try {
      await _googleProvider.signIn();
      value = SignedInFirebaseAuthState(user: _firebaseAuth.currentUser);
    } on FirebaseAuthException catch (e) {
      value = ErrorFirebaseAuthState(exception: e);
    }
  }

  Future<void> signInWithFacebook() async {
    value = SignningFirebaseAuthState();
    try {
      await _facebookProvider.signIn();
      value = SignedInFirebaseAuthState(user: _firebaseAuth.currentUser);
    } on FirebaseAuthException catch (e) {
      value = ErrorFirebaseAuthState(exception: e);
    }
  }

  Future<void> signInWithApple() async {
    value = SignningFirebaseAuthState();
    try {
      await _appleProvider.signIn();
      value = SignedInFirebaseAuthState(user: _firebaseAuth.currentUser);
    } on FirebaseAuthException catch (e) {
      value = ErrorFirebaseAuthState(exception: e);
    }
  }

  Future<void> signOut() async {
    value = SignningFirebaseAuthState();
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleProvider.signOut(),
        _facebookProvider.signOut(),
      ]);
      value = SignedOutFirebaseAuthState();
    } on FirebaseAuthException catch (e) {
      value = ErrorFirebaseAuthState(exception: e);
    }
  }
}
