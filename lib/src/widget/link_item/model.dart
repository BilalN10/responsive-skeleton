import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum LinkItemPosition {
  appbar,
  sidebar,
  bottombar,
}

class LinkItemModel {
  /// @required [String] name
  /// Name of button
  final String tag;

  ///
  ///
  final LinkItemPosition position;

  /// @required [String] route
  /// Route where app will redirect onTap
  final String route;

  /// @required [String] routeName
  ///
  final String routeName;

  /// @optional [String]? iconInactivePath
  /// path to item icon (default state) (/!\ must be SVG file)
  final String? iconInactiveAndDefaultPath;

  /// @optional [String]? iconActivePath
  /// path to item icon (active state) (/!\ must be SVG file)
  final String? iconActivePath;

  ///
  ///
  final String? label;

  final bool Function(BuildContext, WidgetRef)? havePastille;

  /// @optional [Function]? onTap
  /// if item is triggered and route is empty, dashboard will execute this.
  final Function(BuildContext? router)? onTap;

  LinkItemModel({
    required this.tag,
    this.position = LinkItemPosition.sidebar,
    required this.route,
    required this.routeName,
    this.iconInactiveAndDefaultPath,
    this.iconActivePath,
    this.label,
    this.onTap,
    this.havePastille,
  });

  LinkItemModel copyWith({
    String? tag,
    LinkItemPosition? position,
    String? route,
    String? routeName,
    String? iconInactiveAndDefaultPath,
    String? iconActivePath,
    String? label,
    Function(BuildContext? context)? onTap,
  }) =>
      LinkItemModel(
        tag: tag ?? this.tag,
        position: position ?? this.position,
        route: route ?? this.route,
        routeName: routeName ?? this.routeName,
        iconInactiveAndDefaultPath: iconInactiveAndDefaultPath ?? this.iconInactiveAndDefaultPath,
        iconActivePath: iconActivePath ?? this.iconActivePath,
        label: label ?? this.label,
        onTap: onTap ?? this.onTap,
      );
}
