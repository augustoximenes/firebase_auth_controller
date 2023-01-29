library firebase_auth_controller;

import 'package:flutter/material.dart';
import 'package:firebase_auth_controller/firebase_auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

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

  Future<bool> get isSignedIn async => _firebaseAuth.currentUser != null;

  Future<void> signInWithGoogle() async {
    value = SignningFirebaseAuthState();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      value = SignedInFirebaseAuthState(user: _firebaseAuth.currentUser);
    } catch (e) {
      value = ErrorFirebaseAuthState();
    }
  }

  Future<void> signInWithFacebook() async {
    value = SignningFirebaseAuthState();
    try {
      final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken.token);

      await _firebaseAuth.signInWithCredential(credential);
      value = SignedInFirebaseAuthState(user: _firebaseAuth.currentUser);
    } catch (e) {
      value = ErrorFirebaseAuthState();
    }
  }

  Future<void> signOut() async {
    value = SignningFirebaseAuthState();
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      value = SignedOutFirebaseAuthState();
    } catch (e) {
      value = ErrorFirebaseAuthState();
    }
  }
}
