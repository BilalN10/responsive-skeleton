// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

/// {@category Provides}
class CreateAccountProvider with ChangeNotifier {
  /// étape actuel de la création de compte
  final PageController controller = PageController(initialPage: 0);

  String? phoneValidationId;
  String? email;
  PhoneNumber? phone;
  String? password;

  int actualPage = 0;

  /// Données de la création de compte.
  Map<String, dynamic> fieldData = {};

  final ChangeNotifierProviderRef _ref;

  CreateAccountProvider(this._ref);

  void setSmsProvider(String value) {
    phoneValidationId = value;
    notifyListeners();
  }

  void init([int page = 0]) {
    actualPage = 0;
    if (controller.hasClients) {
      controller.jumpToPage(actualPage);
    }
  }

  void updatePage(int newPage) {
    actualPage = newPage;
    controller.jumpToPage(actualPage);
    notifyListeners();
  }

  void addFieldData(String key, dynamic data) {
    fieldData[key] = data;
  }
}
