import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthState {}

class SignedOutFirebaseAuthState extends FirebaseAuthState {}

class SignedInFirebaseAuthState extends FirebaseAuthState {
  SignedInFirebaseAuthState({this.user});

  User? user;
}

class SignningFirebaseAuthState extends FirebaseAuthState {}

class ErrorFirebaseAuthState extends FirebaseAuthState {}
