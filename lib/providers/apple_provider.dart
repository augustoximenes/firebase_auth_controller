import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_controller/providers/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleProvider implements Provider {
  @override
  Future<UserCredential> signIn() async {
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

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {}
}
