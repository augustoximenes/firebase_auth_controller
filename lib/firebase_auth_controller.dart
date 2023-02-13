library firebase_auth_controller;

import 'package:flutter/material.dart';
import 'package:firebase_auth_controller/firebase_auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthController extends ValueNotifier<FirebaseAuthState> {
  FirebaseAuthController({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookLogin? facebookLogin,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin(),
        super(SignedOutFirebaseAuthState());

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;

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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      value = SignedInFirebaseAuthState(user: _firebaseAuth.currentUser);
    } on FirebaseAuthException catch (e) {
      value = ErrorFirebaseAuthState(exception: e);
    }
  }

  Future<void> signInWithFacebook() async {
    value = SignningFirebaseAuthState();
    try {
      final FacebookLoginResult result = await _facebookLogin.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email,
        ],
      );

      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      await _firebaseAuth.signInWithCredential(credential);
      value = SignedInFirebaseAuthState(user: _firebaseAuth.currentUser);
    } on FirebaseAuthException catch (e) {
      value = ErrorFirebaseAuthState(exception: e);
    }
  }

  Future<void> signInWithApple() async {
    value = SignningFirebaseAuthState();
    try {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.fullName,
          AppleIDAuthorizationScopes.email,
        ],
      );

      final AuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      await _firebaseAuth.signInWithCredential(credential);
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
        _googleSignIn.signOut(),
        _facebookLogin.logOut(),
      ]);
      value = SignedOutFirebaseAuthState();
    } on FirebaseAuthException catch (e) {
      value = ErrorFirebaseAuthState(exception: e);
    }
  }
}
