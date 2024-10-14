import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_kosmos/core_kosmos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/src/model/user/user_model.dart';

/// Provider stockant les données de l'utilisateur.
/// Permet de récupérer les données de l'utilisateur en temps réel, avec n'importe quel type d'utilisateur du moment que votre
/// class extends de [UserModel].
///
/// {@category Provider}
class UserProvider<U extends UserModel> with ChangeNotifier {
  /// Main data of user
  ///
  /// [T] extends from [UserModel]
  U? userData;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userStream;

  /// Payment history of user
  ///
  ///

  // ignore: unused_field
  final ChangeNotifierProviderRef _ref;

  // ignore: unused_field
  final U Function(Map<String, dynamic> json)? _constructor;

  final String userCollection;

  UserProvider(this._ref, this.userCollection, this._constructor);

  Future<void> init(String uid, BuildContext context) async {
    userStream?.cancel();
    userStream = FirebaseFirestore.instance.collection(userCollection).doc(uid).snapshots().listen((event) async {
      if (!event.exists) {
        printInDebug("Error, no user found on collection: $userCollection");
        userStream?.cancel();
        AutoRouter.of(context).replaceNamed("/logout");
        return;
      }
      userData = _constructor!(event.data()!);
      if (context.locale.countryCode != userData?.language?.toUpperCase() && userData?.language != null) {
        await _updateLanguage(context);
      }
      notifyListeners();
    });
  }

  _updateLanguage(BuildContext context) async {
    final l = context.supportedLocales.where((element) => element.countryCode == userData?.language?.toUpperCase());
    await context.setLocale(l.first);
    await Get.updateLocale(l.first);
  }

  ///Clear
  void clear() {
    if (userStream != null || userData != null) {
      userStream?.cancel();
      userData = null;
    }
  }

  @override
  void dispose() {
    userStream?.cancel();
    super.dispose();
  }
}
