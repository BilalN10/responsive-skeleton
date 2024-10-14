import 'package:flutter/material.dart';

class LinkItemThemeData {
  ///
  ///
  final double fontSize;

  ///
  ///
  final FontWeight fontWeight;

  ///
  ///
  final double iconWidth;

  /// @default()
  ///
  final Color colorActive;

  /// @default()
  ///
  final Color colorInactiveAndDefault;

  final double spacing;

  const LinkItemThemeData({
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.iconWidth = 16,
    this.colorActive = Colors.black,
    this.colorInactiveAndDefault = const Color(0xFFA7A7A7),
    this.spacing = 13,
  });
}
