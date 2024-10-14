import 'package:flutter/material.dart';

/// This class is used to create a [ThemeData] for the [AuthenticationPage] (login, create account, login with phone, ...).
///
/// {@category Theme}
class AuthenticationPageThemeData {
  /// Text style for the title of the page.
  /// @Nullable
  final TextStyle? titleStyle;
  final TextStyle? codeTitleStyle;
  final TextStyle? titleOtpStyle;

  /// Text style for the subtitle / text of the page.
  /// @Nullable
  final TextStyle? subTitleStyle;
  final TextAlign? codeAlignment;

  /// Text style for hint of text button.
  /// @Nullable
  /// password-reset-label
  final TextStyle? richTextStyle;

  /// Text style for text button.
  /// @Nullable
  /// password-reset-cliquable
  final TextStyle? cliquableTextStyle;

  /// Text style for hint of text button.
  /// @Nullable
  /// not-have-label
  final TextStyle? richTextNotHaveAccountStyle;

  /// Text style for text button.
  /// @Nullable
  /// not-have-cliquable
  final TextStyle? cliquableNotHaveAccountTextStyle;

  /// Spacing betweenn title and form
  /// @Nullable
  final double? titleSpacing;
  final double? topTitleSpacing;
  final double? codeOtpTopSpacing;
  final double? formWidth;
  final double? titleParentWidth;
  final double? modalBottomRadius;
  final Color? resetPasswordEncocheColor;
  final Color? resetPasswordBackgroundColor;
  final Color? verifyNumberBox;
  final TextStyle? verifyNumberStyle;
  final Color? popupBackgroundColor;
  final TextStyle? popupTitleStyle;
  final TextStyle? popupContentStyle;
  final Color? popupButtonCloseColor;
  final double? popupRadius;
  final EdgeInsets? appBarPhonePadding;
  final double? checkCodeOtpTitleWidthConstraint;
  final double? cguCtaWidth;

  const AuthenticationPageThemeData({
    this.appBarPhonePadding,
    this.codeOtpTopSpacing,
    this.titleOtpStyle,
    this.checkCodeOtpTitleWidthConstraint,
    this.titleStyle,
    this.popupRadius,
    this.codeTitleStyle,
    this.subTitleStyle,
    this.cliquableTextStyle,
    this.richTextStyle,
    this.titleSpacing,
    this.popupBackgroundColor,
    this.formWidth,
    this.modalBottomRadius,
    this.codeAlignment,
    this.resetPasswordEncocheColor,
    this.resetPasswordBackgroundColor,
    this.verifyNumberBox,
    this.verifyNumberStyle,
    this.titleParentWidth,
    this.topTitleSpacing,
    this.popupTitleStyle,
    this.popupContentStyle,
    this.popupButtonCloseColor,
    this.cliquableNotHaveAccountTextStyle,
    this.richTextNotHaveAccountStyle,
    this.cguCtaWidth,
  });
}
