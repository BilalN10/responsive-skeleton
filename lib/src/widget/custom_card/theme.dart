import 'package:flutter/material.dart';

/// Theme of the [CustomCard] Widget.
///
/// {@category Theme}
class CustomCardThemeData {
  /// Largeur maximum de la card. Si null, la carte prendra la largeur maximale.
  /// @Nullable
  final double? maxWidth;

  /// Hauteur maximum de la card. Si null, la carte prendra la largeur maximale.
  /// @Nullable
  final double? maxHeight;

  /// Padding vertical de la card.
  /// @Nullable
  final double? verticalPadding;
  final EdgeInsets? padding;

  /// Padding horizontal de la card.
  /// @Nullable
  final double? horizontalPadding;

  /// Radius des angles de la card (equivalent to BorderRadius.circular(x)).
  /// @Nullable
  final double? radius;

  /// Couleur de la card.
  /// @Nullable
  final Color? backgroundColor;

  /// Couleur des ombres de la card.
  /// @Nullable
  final Color? shadowColor;

  /// BlurRadius de la card.
  /// @Nullable
  final double? blurRadius;

  /// SpreadRadius de la card.
  /// @Nullable
  final double? spreadRadius;

  /// Shadow card offset.
  /// @Nullable
  final Offset? offset;

  const CustomCardThemeData({
    this.maxWidth,
    this.maxHeight,
    this.padding,
    this.verticalPadding,
    this.horizontalPadding,
    this.backgroundColor,
    this.radius,
    this.blurRadius,
    this.spreadRadius,
    this.shadowColor,
    this.offset,
  });
}
