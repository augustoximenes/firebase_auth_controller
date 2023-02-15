import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_controller/providers/provider.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class FacebookProvider implements Provider {
  FacebookProvider({
    FacebookLogin? facebookLogin,
  }) : _facebookLogin = facebookLogin ?? FacebookLogin();

  final FacebookLogin _facebookLogin;

  @override
  Future<UserCredential> signIn() async {
    final FacebookLoginResult result = await _facebookLogin.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );

    final AuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    _facebookLogin.logOut();
  }
}
