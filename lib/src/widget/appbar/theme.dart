import 'package:flutter/material.dart';

/// Theme of the [ResponsiveAppBar] Widget.
/// Used for appBar and bottomBar.
///
/// {@category Theme}
class ResponsiveAppBarThemeData {
  /// Height of the AppBar.
  /// @Default: `75`
  final double height;

  /// Color of the AppBar.
  /// @Default: `Colors.white`
  final Color backgroundColor;

  /// Padding of the AppBar.
  /// @Default: `const EdgeInsets.symmetric(horizontal: 25)`
  final EdgeInsetsGeometry padding;

  /// Shadows of the AppBar. None by default
  /// @Default: `[]`
  final List<BoxShadow> shadow;

  /// TextStyle of the link item.
  /// @Nullable
  final TextStyle? itemStyle;

  /// Width of the Logo (defined in [ApplicationModel]).
  /// @Default: `140`
  final double logoWidth;
  final double logoHeight;

  /// Color of drawer icon button.
  /// Darwer button is only visible in tablet / phone UI and if navigation is in AppBar.
  /// @Default: `Colors.black`
  final Color drawerButtonColor;

  /// Size of drawer icon button.
  /// @Default: `22`
  final double drawerButtonSize;

  /// Gradient for appBar background.
  /// @Nullable
  final LinearGradient? gradient;

  /// Spacing between link item.
  /// @Default: `15`
  final double itemSpacing;

  /// Vertical spacing between link item.
  /// @Default: `10`
  final double itemRunSpacing;

  const ResponsiveAppBarThemeData({
    this.height = 75,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 25),
    this.shadow = const [],
    this.itemStyle,
    this.logoWidth = 140,
    this.logoHeight = 70,
    this.drawerButtonColor = Colors.black,
    this.drawerButtonSize = 22,
    this.gradient,
    this.itemSpacing = 15,
    this.itemRunSpacing = 10,
  });
}
