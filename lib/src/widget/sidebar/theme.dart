import 'package:flutter/material.dart';

/// Theme of the SideBar.
///
/// {@category Theme}
class NavigationSidebarThemeData {
  /// Width of the SideBar.
  /// @Default: `250`
  final double width;

  /// Padding of the SideBar.
  /// @Default: `EdgeInsets.symetric(horizontal: 10, vertical: 4)`
  final EdgeInsetsGeometry padding;

  /// Background color of the SideBar.
  /// @Default: `Colors.white`
  final Color backgroundColor;

  /// Shadow of the SideBar
  /// @Default: []
  final List<BoxShadow> shadow;

  /// Spacing between items of the SideBar.
  /// @Default: `13`
  final double itemSpacing;

  const NavigationSidebarThemeData({
    this.width = 250,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.shadow = const [],
    this.itemSpacing = 13,
  });
}
