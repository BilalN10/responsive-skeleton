import 'package:flutter/material.dart';

/// Theme of [CustomExpansionPanelList]
///
/// {@category Theme}
class CustomExpansionPanelListThemeData {
  /// Padding présent dans le header de l'expansion panel.
  /// @Nullable
  final EdgeInsets? headerPadding;

  /// Padding présent dans le child de l'expansion panel.
  /// @Nullable
  final EdgeInsets? contentPadding;

  /// Taille lorsque l'expansion est fermée.
  /// @Nullable
  final double? collapsedHeight;

  /// Widget custom pour ouvrir ou fermé le panel.
  /// @Nullable
  final Widget? expansionButton;

  /// Shadow du panel.
  /// @Nullable
  final List<BoxShadow>? shadow;

  const CustomExpansionPanelListThemeData({
    this.headerPadding,
    this.collapsedHeight,
    this.contentPadding,
    this.expansionButton,
    this.shadow,
  });
}
