import 'package:flutter/material.dart';

class ResponsiveSettingsThemeData {
  final TextStyle? nameStyle;
  final TextStyle? subTitleStyle;
  final TextStyle? titleStyle;
  final double verticalSpacing;
  final double verticalSectionSpacing;
  final double? setingsDefaultPageTopSpacing;

  final double? cardBorderRadius;
  final double? cardWidth;

  final double? settingsLeftSpacing;
  final double? settingsRightSpacing;
  final double? settingsVeriticalSpacing;

  final Color? iconBackColor;

  const ResponsiveSettingsThemeData({
    this.nameStyle,
    this.titleStyle,
    this.subTitleStyle,
    this.setingsDefaultPageTopSpacing,
    this.verticalSpacing = 7,
    this.verticalSectionSpacing = 17,
    this.cardBorderRadius,
    this.cardWidth,
    this.settingsLeftSpacing,
    this.settingsVeriticalSpacing,
    this.settingsRightSpacing,
    this.iconBackColor,
  });
}
