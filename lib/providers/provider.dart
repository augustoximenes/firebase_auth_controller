import 'package:firebase_auth/firebase_auth.dart';

abstract class Provider {
  Future<UserCredential> signIn();
  Future<void> signOut();
}
