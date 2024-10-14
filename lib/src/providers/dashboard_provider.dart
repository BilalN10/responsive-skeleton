// ignore_for_file: unused_field

import 'package:auto_route/auto_route.dart';
import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardProvider with ChangeNotifier {
  ///
  ///
  final GlobalKey<ScaffoldState> _dahsboardKey = GlobalKey();
  GlobalKey<ScaffoldState> get key => _dahsboardKey;

  ///
  String? _actualRoute;
  String? get route => _actualRoute;

  final ChangeNotifierProviderRef _ref;

  DashboardProvider(this._ref);

  void init(PageRouteInfo<void> route) {
    _actualRoute = route.routeName;
  }

  void updateRoute(String newRoute) {
    _actualRoute = newRoute;
    printInDebug(newRoute);
    notifyListeners();
  }
}
