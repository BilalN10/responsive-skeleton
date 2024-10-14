import 'package:firebase_auth/firebase_auth.dart';
import 'package:skeleton_kosmos/src/services/authentication/error/error_handler.dart';
import 'package:skeleton_kosmos/src/services/authentication/model/auth_response.dart';

abstract class UserAuthUpdate {
  static Future<AuthResponse> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);
    try {
      await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
      return AuthResponse("ok", 'ok');
    } on FirebaseAuthException catch (e) {
      return updatePasswordErrorHandler(e);
    }
  }

  static Future<AuthResponse> changeEmail({
    required String email,
    required String newEmail,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    try {
      await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
      return AuthResponse("ok", 'ok');
    } on FirebaseAuthException catch (e) {
      return updateEmailErrorHandler(e);
    }
  }
}
