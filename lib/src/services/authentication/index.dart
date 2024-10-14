import 'package:cloud_functions/cloud_functions.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
import 'package:skeleton_kosmos/src/services/authentication/error/error_handler.dart';
import 'package:skeleton_kosmos/src/services/authentication/model/auth_response.dart';

class AuthService {
  //TODO Phone connexion
  /*
  static Future<Tuple2<IsUserWithPhoneExistResponse, String?>> existPhone(String numTel) async {
    var response = await http.post(
        Uri.https(
          CLOUD_FUNCTIONS_BASE_URL,
          '/existUserWithPhone',
        ),
        body: jsonEncode({"numTel": numTel}));
    if (response.statusCode == 200) {
      return Tuple2(IsUserWithPhoneExistResponse.notExist, null);
    } else if (response.statusCode == 404) {
      var state = jsonDecode(response.body);
      print(state.toString());
      if ((state['verified'] as bool) == true)
        return Tuple2(IsUserWithPhoneExistResponse.existWithValidatedEmail, null);
      else {
        return Tuple2(IsUserWithPhoneExistResponse.existWithUvalidatedEmail, state['email']);
      }
    }
    return Tuple2(IsUserWithPhoneExistResponse.error, null);
  }

  static Future<IsUserExistResponse> existEmail(String email) async {
    var response = await http.post(
        Uri.https(
          CLOUD_FUNCTIONS_BASE_URL,
          '/existsUserWithEmail',
        ),
        body: jsonEncode({"email": email}));
    if (response.statusCode == 200) {
      return IsUserExistResponse.notExist;
    } else if (response.statusCode == 404) return IsUserExistResponse.exist;
    return IsUserExistResponse.error;
  }
  */

  static updatePhone({
    required String phone,
    required Function(PhoneAuthCredential credential) connexionDone,
    required Function(String verificationId, int? forecResendToken) codeSent,
    required Function redirectAfterTimeOut,
    required Function setLoading,
    required void Function(FirebaseAuthException e) verificationFailed,
    required void Function(FirebaseAuthException e) verificationError,
  }) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: GetIt.instance<ApplicationDataModel>().requestTimeout,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          connexionDone(credential);
        } on FirebaseAuthException catch (e) {
          verificationError(e);
        }
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static signInWithPhone({
    required String phone,
    required Function connexionDone,
    required Function(String verificationId, int? forecResendToken) codeSent,
    required Function redirectAfterTimeOut,
    required Function setLoading,
    required void Function(FirebaseAuthException e) verificationFailed,
    required void Function(FirebaseAuthException e) verificationError,
  }) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: GetIt.instance<ApplicationDataModel>().requestTimeout,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final UserCredential _ = await FirebaseAuth.instance.signInWithCredential(credential);
          connexionDone();
        } on FirebaseAuthException catch (e) {
          verificationError(e);
        }
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static Future<AuthResponse> signUpWithEmail(String email, String password, [bool veriedEmail = true]) async {
    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.trim(), password: password);
      if (kDebugMode) {
        print(result);
      }
      if (result.user != null) {
        result.user!.sendEmailVerification();
        return AuthResponse('ok', 'connexion effectuée');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      return updateEmailErrorHandler(e);
    } catch (e) {
      return AuthResponse('sign-in-error', "field.form-validator.firebase.error".tr());
    }
    return AuthResponse('sign-in-error', "field.form-validator.firebase.error".tr());
  }

  static Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      UserCredential result =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password);
      if (result.user != null) {
        return AuthResponse('ok', 'connexion effectuée');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      return updateEmailErrorHandler(e);
    } catch (e) {
      return AuthResponse('sign-in-error', "field.form-validator.firebase.error".tr());
    }
    return AuthResponse('sign-in-error', "field.form-validator.firebase.error".tr());
  }

  ///
  ///
  ///
  static Future<String?> sendResetPasswordEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
      return "error";
    }
    return null;
  }

  static Future<bool> phoneDoesExist(String phone) async {
    try {
      printInDebug("check if phone exist on firebase");
      final call = FirebaseFunctions.instance.httpsCallable("checkPhoneIsAvailable");
      final rep = await call({"phoneNumber": phone});
      return rep.data;
    } catch (e) {
      printInDebug(e.toString());
    }
    return true;
  }

  static Future<bool> emailDoesExist(String email) async {
    try {
      final call = FirebaseFunctions.instance.httpsCallable("checkEmailIsAvailable");
      final rep = await call({"email": email});

      return rep.data;
    } catch (e) {
      printInDebug(e.toString());
      rethrow;
    }
  }
}
